#!/usr/bin/env python3
"""Conclui a tradução pt-BR do Vídeo Studio BR.

- Traduz as mensagens ainda marcadas como `unfinished` no arquivo Qt Linguist.
- Substitui menções à marca antiga (Shotcut/StudioCut) pelo novo nome.
- Normaliza alguns termos europeus que existem na tradução herdada do upstream.

Uso: python scripts/translate-pt-br.py
"""

from __future__ import annotations

import html
import json
import random
import re
import time
import urllib.parse
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path
from xml.sax.saxutils import escape

ROOT = Path(__file__).resolve().parents[1]
TS_FILE = ROOT / "translations" / "shotcut_pt_BR.ts"
CACHE_FILE = Path(__file__).with_name(".pt-br-translation-cache.json")
ENDPOINT = "https://clients5.google.com/translate_a/t"

# Fontes cujo texto foi alterado no código (main.cpp) precisam acompanhar.
SOURCE_RENAMES = {
    "Fill the screen with the Shotcut window.":
        "Fill the screen with the Vídeo Studio BR window.",
    "Run Glaxnimate instead of Shotcut.":
        "Run Glaxnimate instead of Vídeo Studio BR.",
}

# Tradução herdada do upstream contém alguns termos de pt-PT.
PT_PT_TO_PT_BR = {
    "ficheiro": "arquivo", "Ficheiro": "Arquivo", "ficheiros": "arquivos",
    "Ficheiros": "Arquivos", "Actualizar": "Atualizar", "actualizar": "atualizar",
    "Actualização": "Atualização", "actualização": "atualização",
    "Guardar": "Salvar", "guardar": "salvar", "ecrã": "tela", "Ecrã": "Tela",
    "Directório": "Diretório", "directório": "diretório",
}

MESSAGE_RE = re.compile(r"<message\b.*?</message>", re.DOTALL)
SOURCE_RE = re.compile(r"<source>(.*?)</source>", re.DOTALL)
TRANSLATION_RE = re.compile(r"<translation\b[^>]*>.*?</translation>", re.DOTALL)
UNFINISHED_RE = re.compile(r"<translation\b[^>]*\btype=\"unfinished\"[^>]*>")

_cache: dict[str, str] = json.loads(CACHE_FILE.read_text("utf-8")) if CACHE_FILE.exists() else {}


def translate(text: str) -> str | None:
    """Traduz um texto usando o endpoint público do Google Translate."""
    text = text.strip()
    if not text or not re.search(r"[A-Za-zÀ-ÿ]", text) or len(text) > 1500:
        return text if text else None
    if text in _cache:
        return _cache[text]

    url = ENDPOINT + "?" + urllib.parse.urlencode({
        "client": "dict-chrome-ex", "sl": "en", "tl": "pt-BR", "q": text,
    })
    for attempt in range(4):
        try:
            req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
            with urllib.request.urlopen(req, timeout=25) as response:
                data = json.loads(response.read().decode("utf-8"))
            if isinstance(data, str):
                result = data
            elif isinstance(data, list) and data:
                first = data[0]
                result = first if isinstance(first, str) else "".join(
                    part[0] for part in first if part and part[0]
                )
            else:
                result = ""
            result = result.strip()
            if result:
                _cache[text] = result
                return result
            return None
        except Exception:
            if attempt == 3:
                return None
            time.sleep(1.5 * (attempt + 1) + random.random())
    return None


def brand_and_terms(text: str) -> str:
    text = text.replace("StudioCut", "Vídeo Studio BR").replace("Shotcut", "Vídeo Studio BR")
    for old, new in PT_PT_TO_PT_BR.items():
        text = re.sub(rf"\b{re.escape(old)}\b", new, text)
    return text


def main() -> None:
    text = TS_FILE.read_text("utf-8")
    pending: list[tuple[str, str]] = []

    for match in MESSAGE_RE.finditer(text):
        block = match.group(0)
        if not UNFINISHED_RE.search(block):
            continue
        source_match = SOURCE_RE.search(block)
        if not source_match:
            continue
        source = html.unescape(source_match.group(1))
        if source.strip():
            pending.append((match.group(0), source))

    print(f"Mensagens pendentes: {len(pending)}", flush=True)
    translated: dict[str, str] = {}
    with ThreadPoolExecutor(max_workers=4) as pool:
        futures = {pool.submit(translate, source): block for block, source in pending}
        for i, future in enumerate(as_completed(futures), 1):
            block = futures[future]
            try:
                result = future.result()
            except Exception:
                result = None
            if result:
                translated[block] = escape(result)
            if i % 100 == 0:
                print(f"  {i}/{len(pending)}", flush=True)
                CACHE_FILE.write_text(json.dumps(_cache, ensure_ascii=False, indent=1), "utf-8")

    def replace_message(match: re.Match[str]) -> str:
        block = match.group(0)
        if block not in translated:
            return block
        value = translated[block]
        if 'numerus="yes"' in block:
            # Mensagens plurais do Qt exigem <numerusform> em vez de texto simples.
            value = ("\n        <numerusform>%s</numerusform>"
                     "\n        <numerusform>%s</numerusform>\n    " % (value, value))
        return re.sub(
            r"<translation\b[^>]*>.*?</translation>",
            f"<translation>{value}</translation>",
            block,
            count=1,
            flags=re.DOTALL,
        )

    text = MESSAGE_RE.sub(replace_message, text)

    # Novo nome nas fontes que mudaram no código e em todas as traduções.
    for old, new in SOURCE_RENAMES.items():
        text = text.replace(f"<source>{old}</source>", f"<source>{new}</source>")

    def replace_translation(match: re.Match[str]) -> str:
        attrs, body = match.group(1), match.group(2)
        return f"<translation{attrs}>{brand_and_terms(body)}</translation>"

    text = re.sub(r"<translation(\b[^>]*)>(.*?)</translation>", replace_translation,
                  text, flags=re.DOTALL)

    TS_FILE.write_text(text, "utf-8")
    CACHE_FILE.write_text(json.dumps(_cache, ensure_ascii=False, indent=1), "utf-8")
    remaining = len(UNFINISHED_RE.findall(text))
    print(f"Concluído. Pendências restantes: {remaining}", flush=True)


if __name__ == "__main__":
    main()
