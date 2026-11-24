# Vídeo Studio BR

Fork do [Shotcut](https://www.shotcut.org/) com interface em **português do Brasil**,
tema **dark moderno (roxo/ciano)** e nome próprio. Mesma base de código
(Qt 6 + MLT), licença **GPLv3**, com o objetivo de manter paridade funcional
com o Shotcut.

## Ambiente usado nesta máquina

- Código-fonte: `C:\Users\ronne\video-studio-br`
- MSYS2: `C:\Users\ronne\msys64` (UCRT64)
- Build: `C:\Users\ronne\video-studio-br\build\msys2-local-debug`
- Instalação: `C:\Users\ronne\video-studio-br\install\msys2-local-debug`
- Executável: `video-studio-br.exe`

> O caminho `C:\Users\ronne\Documents\Projeto Padrão` contém `ã`, o que quebra
> o `moc` do Qt no MSYS2. Por isso o build é feito em um diretório sem acentos.

Pacotes MSYS2: toolchain gcc 16.2, CMake 4.5, Ninja, Qt 6.12
(base, declarative, svg, tools, 5compat, charts, multimedia, websockets),
MLT 7.42, FFTW 3.3.11, frei0r, SDL2.

## Comandos

```powershell
# Configurar (uma vez)
& 'C:\Users\ronne\msys64\ucrt64\bin\cmake.exe' --preset msys2-local-debug

# Tradução (opcional: refaz as mensagens pendentes e troca a marca no .ts)
python 'C:\Users\ronne\video-studio-br\scripts\translate-pt-br.py'

# Compilar
& 'C:\Users\ronne\msys64\usr\bin\bash.exe' -lc 'cd /c/Users/ronne/video-studio-br && export PATH=/ucrt64/bin:$PATH && cmake --build build/msys2-local-debug --parallel 8'

# Instalar (QML, filtros, recursos e arquivos .qm)
& 'C:\Users\ronne\msys64\usr\bin\bash.exe' -lc 'cd /c/Users/ronne/video-studio-br && export PATH=/ucrt64/bin:$PATH && cmake --install build/msys2-local-debug'

# Implantar dependências de runtime (uma vez, ou após reinstall)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File 'C:\Users\ronne\video-studio-br\deploy-runtime.ps1'

# Executar (não precisa ter o MSYS2 no PATH)
$env:QSG_RHI_BACKEND = 'd3d11'
& 'C:\Users\ronne\video-studio-br\install\msys2-local-debug\video-studio-br.exe'
```

## O que mudou em relação ao fork anterior

- **Nome:** `Vídeo Studio BR` em applicationName, título da janela, menu
  "Sobre", metadados do `.exe` e nome do binário (`video-studio-br.exe`).
- **Layout:** paleta Qt e QSS do tema dark reescritos com fundo azul-noite
  (`#0e1526`), roxo (`#241250` / `#6a3df5`) e ciano (`#2cecff`); abas
  arredondadas, docks com gradiente, botões/campos/menus/scrollbars estilizados.
  O tema dos componentes QML acompanha a mesma paleta
  (`src/resources/qtquickcontrols2-dark.conf`).
- **Idioma:** `pt_BR` é o padrão em `ShotcutSettings::language()`; uma escolha
  explícita no menu Idioma continua sendo respeitada. Os `.qm` agora são
  instalados em `share/translations` também no Windows.
- **Tradução:** `translations/shotcut_pt_BR.ts` teve as mensagens pendentes
  traduzidas e as menções a "Shotcut"/"StudioCut" substituídas pelo novo nome.
  O script `scripts/translate-pt-br.py` reproduz o processo.

## Deploy de runtime

`deploy-runtime.ps1` cobre:

- `windeployqt` (DLLs e plugins do Qt, incluindo `platforms/qwindows.dll`);
- arquivos `.qm` copiados para `share/translations`;
- `libCuteLogger.dll`, `exchndl.dll` e **`mgwhelp.dll`** (dependência do
  `exchndl.dll`; sem ele o app falha com `0xC0000135`);
- 28 DLLs do MSYS2 (MLT, FFTW, GCC, ICU, GLib etc.).

Os módulos do MLT são resolvidos no prefixo do MSYS2
(`C:\Users\ronne\msys64\ucrt64\lib\mlt`). Para distribuir em outro computador,
copie essa pasta junto e defina `MLT_REPOSITORY`.

## Repositório

- Fork: https://github.com/ronney13/studiocut (`origin`)
- Upstream: https://github.com/mltframework/shotcut.git (`upstream`)

O nome do repositório remoto ainda é `studiocut`; o nome do **programa** é
`Vídeo Studio BR`.

## Obrigações de licença

Este é um derivado de Shotcut sob GPLv3. Você deve:

- manter os avisos de copyright de Meltytech, LLC e a licença GPLv3;
- disponibilizar o código-fonte das suas modificações ao distribuir o binário;
- não remover a atribuição ao projeto original.

O diálogo "Sobre" continua apontando para o código-fonte upstream como oferta
de código, menciona o Shotcut como projeto base e preserva o copyright da
Meltytech.

## Instaladores

### Windows (MSI + EXE)

Com a instalação pronta e o runtime implantado:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File 'packaging\windows\build-installer.ps1'
```

Gera em `install\installers\`:

- `video-studio-br.msi` — MSI WiX 5 (instala em `Program Files\Vídeo Studio BR`,
  atalhos no menu Iniciar e na área de trabalho, desinstalação pelo Painel de Controle);
- `video-studio-br-setup.exe` — bootstrapper Burn com licença RTF e o MSI embutido.

Requisitos locais: WiX 5 (`wix.exe`) e as extensões
`WixToolset.UI.wixext` e `WixToolset.BootstrapperApplications.wixext`
na versão 5.0.2 (`wix extension add WixToolset.BootstrapperApplications.wixext/5.0.2`).

### Linux (DEB, RPM, AppImage, Flatpak, snap, Arch)

O repositório contém:

- `packaging/cpack/CPackConfig.cmake` — gera `.deb`, `.rpm` e `.tar.gz`;
- `packaging/rpm/video-studio-br.spec` — spec alternativo para `rpmbuild`;
- `packaging/linux/appimage/appimage.yml` — receita AppImage;
- `packaging/flatpak/org.videostudiobr.VideoStudioBR.json` — manifest Flatpak;
- `packaging/linux/snapcraft.yaml` — snap (confinamento clássico);
- `packaging/arch/PKGBUILD` — pacote para Arch Linux/AUR;
- `packaging/linux/video-studio-br.desktop` e o metainfo — integração de desktop.

O workflow `.github/workflows/package-linux.yml` compila e publica DEB, TGZ,
RPM, AppImage e Flatpak como artefatos do GitHub Actions (execute por
`workflow_dispatch` ou por uma tag `v*`).

## Pendências

- A checagem de atualização ainda consulta `check.shotcut.org`.
- Testes JS disponíveis:
  `node src/qml/export-edl/test-node.js` e `node src/qml/export-chapters/test-node.js`.
- Documentar a instalação em outras máquinas após a primeira release pública.
