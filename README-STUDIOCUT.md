# StudioCut

Fork do [Shotcut](https://www.shotcut.org/) com rebrand para **StudioCut**.
Mesma base de código (Qt 6 + MLT), licença **GPLv3**, com o objetivo de manter
paridade funcional com o Shotcut.

## Ambiente usado nesta máquina

- Código-fonte: `C:\Users\ronne\shotcut`
- MSYS2: `C:\Users\ronne\msys64` (UCRT64)
- Build: `C:\Users\ronne\shotcut\build\msys2-local-debug`
- Instalação: `C:\Users\ronne\shotcut\install\msys2-local-debug`

Pacotes MSYS2 instalados: toolchain (gcc 16.2), CMake 4.5, Ninja, pkgconf,
Qt 6.12 (base, declarative, svg, tools, 5compat, charts, multimedia, websockets),
MLT 7.42, FFTW 3.3.11, frei0r, SDL2.

> O caminho original `C:\Users\ronne\Documents\Projeto Padrão\shotcut` contém
> o caractere `ã`, que quebra o `moc` do Qt no MSYS2. Por isso o build é feito
> na cópia sem acentos `C:\Users\ronne\shotcut`.

## Comandos

```powershell
# Configurar (uma vez)
& 'C:\Users\ronne\msys64\ucrt64\bin\cmake.exe' --preset msys2-local-debug

# Compilar
& 'C:\Users\ronne\msys64\usr\bin\bash.exe' -lc 'cd /c/Users/ronne/shotcut && export PATH=/ucrt64/bin:$PATH && cmake --build build/msys2-local-debug --parallel 8'

# Instalar (QML, filtros e recursos)
& 'C:\Users\ronne\msys64\usr\bin\bash.exe' -lc 'cd /c/Users/ronne/shotcut && export PATH=/ucrt64/bin:$PATH && cmake --install build/msys2-local-debug'

# Implantar dependências de runtime (uma vez, ou após reinstall)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File 'C:\Users\ronne\shotcut\deploy-runtime.ps1'

# Executar (não precisa ter o MSYS2 no PATH)
& 'C:\Users\ronne\shotcut\install\msys2-local-debug\studiocut.exe'
```

Para depuração no Windows, defina `QSG_RHI_BACKEND=d3d11`.

## Rebrand aplicado

Script: `rebrand-studiocut.ps1` (na raiz do repositório). Ele altera:

- Nome da aplicação, organização, domínio e mutex (`src/main.cpp`)
- Título da janela e menu "About" (`src/mainwindow.ui`, `.h`, `.cpp`)
- Texto do diálogo "Sobre" com atribuição a Shotcut
- Nome do executável (`studiocut.exe`) via `OUTPUT_NAME`
- Metadados do executável Windows (`packaging/windows/shotcut.rc.in`)
- Ícones próprios: SVG vetorial (`icons/studiocut-logo-64.svg`) e ICO
  multi-tamanho (`packaging/windows/studiocut-logo-64.ico`)

O deploy de runtime (`deploy-runtime.ps1`) cobre:

- `windeployqt` (DLLs e plugins do Qt, incluindo `platforms/qwindows.dll`)
- `libCuteLogger.dll`, `exchndl.dll` e **`mgwhelp.dll`** (este último é
  dependência do `exchndl.dll`; sem ele o app falha com `0xC0000135`)
- 28 DLLs do MSYS2 (MLT, FFTW, GCC, ICU, GLib etc.)

Os módulos do MLT continuam sendo resolvidos no prefixo do MSYS2
(`C:\Users\ronne\msys64\ucrt64\lib\mlt` nesta máquina). Para distribuir em outro
computador, copie essa pasta junto e defina `MLT_REPOSITORY`.

## Repositório

- Fork: https://github.com/ronney13/studiocut (`origin`)
- Upstream: https://github.com/mltframework/shotcut.git (`upstream`)

## Validação

- Build: concluído (`BUILD_EXIT=0`).
- Executável: `install\msys2-local-debug\studiocut.exe` inicia e exibe
  `Untitled - Automatic - StudioCut` como título da janela.
- Resolução de imports: 0 DLLs faltando (verificação recursiva com `objdump`).

## Obrigações de licença

Este é um derivado de Shotcut sob GPLv3. Você deve:

- manter os avisos de copyright de Meltytech, LLC e a licença GPLv3;
- disponibilizar o código-fonte das suas modificações ao distribuir o binário;
- não remover a atribuição ao projeto original.

O diálogo "Sobre" continua apontando para o código-fonte upstream como
oferta de código, e menciona explicitamente que StudioCut é baseado no Shotcut.

## Pendências / próximos passos

- ícones próprios já aplicados (SVG + ICO gerados a partir do mesmo desenho).
- Substituir `studiocut.local` e a URL de verificação de versão por domínios
  reais do fork (a checagem de atualização ainda consulta `check.shotcut.org`).
- Atualizar traduções (`translations/`) e textos de interface que ainda citam "Shotcut".
- Rodar os testes JS disponíveis:
  `node src/qml/export-edl/test-node.js` e `node src/qml/export-chapters/test-node.js`.
- Publicar releases/instalador e documentar a instalação para outras máquinas
  (copiar `lib\mlt` do MSYS2 e definir `MLT_REPOSITORY`).
