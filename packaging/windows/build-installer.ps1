# Gera o MSI e o EXE (bootstrapper) do Vídeo Studio BR com WiX 5.
# Requer: cmake --install + deploy-runtime.ps1 já executados.
$ErrorActionPreference = 'Stop'

$root = 'C:\Users\ronne\video-studio-br'
$installDir = Join-Path $root 'install\msys2-local-debug'
$wixDir = Join-Path $root 'packaging\windows\installer'
$outDir = Join-Path $root 'install\installers'
$wix = 'C:\Users\ronne\.dotnet\tools\wix.exe'

if (-not (Test-Path (Join-Path $installDir 'video-studio-br.exe'))) {
    throw 'Instalação não encontrada. Rode cmake --install e deploy-runtime.ps1 primeiro.'
}
New-Item -ItemType Directory -Path $outDir -Force | Out-Null

# License.rtf para a tela de licença do MSI.
$license = (Get-Content (Join-Path $root 'COPYING') -Raw) -replace "`r", ''
$license = $license.Replace('\', '\\').Replace('{', '\{').Replace('}', '\}').Replace("`n", '\par ')
[IO.File]::WriteAllText((Join-Path $wixDir 'License.rtf'),
    '{\rtf1\ansi\deff0{\fonttbl{\f0 Consolas;}}\f0\fs18 ' + $license + '}',
    [Text.Encoding]::ASCII)

# Coleta automática dos arquivos instalados usando o recurso nativo <Files> do WiX 5.
$harvest = '<Wix xmlns="http://wixtoolset.org/schemas/v4/wxs">
  <Fragment>
    <ComponentGroup Id="ApplicationFiles">
      <Files Include="$(InstallDir)\**" Directory="INSTALLFOLDER" />
    </ComponentGroup>
  </Fragment>
</Wix>
'
[IO.File]::WriteAllText((Join-Path $wixDir 'Harvest.wxs'), $harvest, [Text.UTF8Encoding]::new($false))
$count = (Get-ChildItem -LiteralPath $installDir -Recurse -File).Count
Write-Host "Arquivos coletados: $count"

$msi = Join-Path $outDir 'video-studio-br.msi'
Write-Host '== Compilando MSI =='
Push-Location $wixDir
try {
    & $wix build -arch x64 -d "InstallDir=$installDir" -ext WixToolset.UI.wixext `
        (Join-Path $wixDir 'Product.wxs') (Join-Path $wixDir 'Harvest.wxs') -out $msi
} finally {
    Pop-Location
}
if ($LASTEXITCODE -ne 0) { throw 'Falha ao gerar MSI' }

Write-Host '== Compilando EXE instalador (Burn) =='
$setup = Join-Path $outDir 'video-studio-br-setup.exe'
Push-Location $wixDir
try {
    & $wix build -arch x64 -d "MsiPath=$msi" -ext WixToolset.BootstrapperApplications.wixext `
        (Join-Path $wixDir 'Bundle.wxs') -out $setup
} finally {
    Pop-Location
}
if ($LASTEXITCODE -ne 0) { throw 'Falha ao gerar EXE instalador' }

Write-Host "MSI : $msi"
Write-Host "EXE : $setup"
