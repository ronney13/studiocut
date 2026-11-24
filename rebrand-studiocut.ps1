$ErrorActionPreference = 'Stop'
$root = 'C:\Users\ronne\shotcut'
$utf8 = [System.Text.UTF8Encoding]::new($false)

function Replace-InFile {
    param([string]$RelativePath, [hashtable]$Replacements)
    $path = Join-Path $root $RelativePath
    $text = [IO.File]::ReadAllText($path)
    foreach ($old in $Replacements.Keys) {
        if (-not $text.Contains($old)) {
            throw "Texto nao encontrado em $RelativePath : $old"
        }
        $text = $text.Replace($old, $Replacements[$old])
    }
    [IO.File]::WriteAllText($path, $text, $utf8)
    Write-Host "OK  $RelativePath"
}

Replace-InFile 'CMakeLists.txt' @{
    'DESCRIPTION "cross-platform (Qt), open-source (GPLv3) video editor"' =
        'DESCRIPTION "StudioCut - cross-platform (Qt), open-source (GPLv3) video editor based on Shotcut"'
    'HOMEPAGE_URL "https://www.shotcut.org"' =
        'HOMEPAGE_URL "https://github.com/mltframework/shotcut"'
}

Replace-InFile 'src/main.cpp' @{
    'Meltytech Shotcut Running Mutex' = 'StudioCut Running Mutex'
    'setOrganizationName("Meltytech");' = 'setOrganizationName("StudioCut");'
    'setOrganizationDomain("shotcut.org");' = 'setOrganizationDomain("studiocut.local");'
    'setOrganizationDomain("meltytech.com");' = 'setOrganizationDomain("studiocut.local");'
    'setDesktopFileName("org.shotcut.Shotcut");' = 'setDesktopFileName("org.studiocut.StudioCut");'
    'setApplicationName("Shotcut");' = 'setApplicationName("StudioCut");'
    'Fill the screen with the Shotcut window.' = 'Fill the screen with the StudioCut window.'
}

Replace-InFile 'src/mainwindow.ui' @{
    '<string>Shotcut</string>' = '<string>StudioCut</string>'
    'shotcut-logo-64.svg' = 'studiocut-logo-64.svg'
    'actionAbout_Shotcut' = 'actionAbout_StudioCut'
    '&amp;About Shotcut' = '&amp;About StudioCut'
}

Replace-InFile 'src/mainwindow.h' @{
    'on_actionAbout_Shotcut_triggered' = 'on_actionAbout_StudioCut_triggered'
}

Replace-InFile 'src/mainwindow.cpp' @{
    'on_actionAbout_Shotcut_triggered' = 'on_actionAbout_StudioCut_triggered'
    'Shotcut version %2' = 'StudioCut version %2'
    'const auto url = QStringLiteral("https://www.shotcut.org/");' =
        'const auto url = QStringLiteral("https://github.com/mltframework/shotcut");'
    '<p><a href=\"%3\">%1</a> is a free, open source, cross platform video editor.</p>' =
        '<p><a href=\"%3\">%1</a> is a free, open source, cross platform video editor based on <a href=\"https://www.shotcut.org/\">Shotcut</a>.</p>'
}

Replace-InFile 'src/CMakeLists.txt' @{
    '# Compile HDR gain shader' = "set_target_properties(shotcut PROPERTIES OUTPUT_NAME `"studiocut`")`n`n# Compile HDR gain shader"
}

Replace-InFile 'packaging/windows/shotcut.rc.in' @{
    'shotcut-logo-64.ico' = 'studiocut-logo-64.ico'
    'VALUE "CompanyName", "Meltytech, LLC\0"' = 'VALUE "CompanyName", "StudioCut\0"'
    'VALUE "FileDescription", "Shotcut video editor\0"' = 'VALUE "FileDescription", "StudioCut video editor\0"'
    'VALUE "LegalCopyright", "Copyright (C) 2011-2026 Meltytech, LLC. All rights reserved.\0"' =
        'VALUE "LegalCopyright", "Copyright (C) 2011-2026 Meltytech, LLC. StudioCut fork.\0"'
    'VALUE "OriginalFilename", "shotcut.exe\0"' = 'VALUE "OriginalFilename", "studiocut.exe\0"'
    'VALUE "ProductName", "Shotcut\0"' = 'VALUE "ProductName", "StudioCut\0"'
}

Replace-InFile 'icons/resources.qrc' @{
    '<file>shotcut-logo-64.svg</file>' =
        "<file>shotcut-logo-64.svg</file>`n        <file>studiocut-logo-64.svg</file>"
}

Copy-Item (Join-Path $root 'packaging\windows\shotcut-logo-64.ico') (Join-Path $root 'packaging\windows\studiocut-logo-64.ico') -Force
Copy-Item (Join-Path $root 'icons\shotcut-logo-64.svg') (Join-Path $root 'icons\studiocut-logo-64.svg') -Force
Write-Host 'OK  icones copiados'
Write-Host 'REBRAND CONCLUIDO'
