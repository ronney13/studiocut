# Implanta as dependencias de runtime na pasta de instalacao do Video Studio BR.
# Uso: powershell -NoProfile -ExecutionPolicy Bypass -File deploy-runtime.ps1
$ErrorActionPreference = 'Stop'

$root = 'C:\Users\ronne\video-studio-br'
$ucrtBin = 'C:\Users\ronne\msys64\ucrt64\bin'
$installDir = Join-Path $root 'install\msys2-local-debug'
$buildDir = Join-Path $root 'build\msys2-local-debug'
$exeName = 'video-studio-br.exe'

$env:Path = "$ucrtBin;$installDir;$env:Path"
$env:QSG_RHI_BACKEND = 'd3d11'

if (-not (Test-Path (Join-Path $installDir $exeName))) {
    throw "$exeName nao encontrado em $installDir"
}

Write-Host '== windeployqt =='
& (Join-Path $ucrtBin 'windeployqt.exe') --release (Join-Path $installDir $exeName) | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'windeployqt falhou' }

Write-Host '== traducoes (pt-BR e demais idiomas) =='
$qmSource = Join-Path $buildDir 'translations'
$qmDest = Join-Path $installDir 'share\translations'
New-Item -ItemType Directory -Path $qmDest -Force | Out-Null
Copy-Item (Join-Path $qmSource '*.qm') $qmDest -Force
if (-not (Test-Path (Join-Path $qmDest 'shotcut_pt_BR.qm'))) {
    throw 'shotcut_pt_BR.qm nao foi copiado'
}

Write-Host '== bibliotecas auxiliares =='
Copy-Item (Join-Path $buildDir 'CuteLogger\libCuteLogger.dll') $installDir -Force
Copy-Item (Join-Path $root 'drmingw\x64\bin\exchndl.dll') $installDir -Force
# exchndl.dll depende de mgwhelp.dll; sem ele o Windows falha com 0xC0000135.
Copy-Item (Join-Path $root 'drmingw\x64\bin\mgwhelp.dll') $installDir -Force

Write-Host '== DLLs do MSYS2 =='
$names = @(
    'libb2-1.dll', 'libbrotlicommon.dll', 'libbrotlidec.dll', 'libbz2-1.dll',
    'libdl.dll', 'libdouble-conversion.dll', 'libfftw3-3.dll', 'libfreetype-6.dll',
    'libgcc_s_seh-1.dll', 'libglib-2.0-0.dll', 'libgraphite2.dll', 'libharfbuzz-0.dll',
    'libiconv-2.dll', 'libicudt78.dll', 'libicuin78.dll', 'libicuuc78.dll',
    'libintl-8.dll', 'libmd4c.dll', 'libmlt++-7.dll', 'libmlt-7.dll',
    'libpcre2-16-0.dll', 'libpcre2-8-0.dll', 'libpng16-16.dll', 'libstdc++-6.dll',
    'libwinpthread-1.dll', 'libz-1.dll', 'libzstd.dll', 'zlib1.dll'
)
foreach ($n in $names) {
    Copy-Item (Join-Path $ucrtBin $n) (Join-Path $installDir $n) -Force
}

Write-Host "PRONTO: $installDir"
Write-Host 'Para executar:'
Write-Host "  & '$installDir\$exeName'"
