param(
    [string]$JdkHome = '',
    [string]$WixDirectory = (Join-Path $PSScriptRoot '..\..\.tools\wix'),
    [switch]$SkipBuild
)
$ErrorActionPreference = 'Stop'
$project = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
if (-not $JdkHome) {
    $bundledJdk = Get-ChildItem (Join-Path $project '..\.tools\temurin17') -Directory -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($bundledJdk) { $JdkHome = $bundledJdk.FullName } elseif ($env:JAVA_HOME) { $JdkHome = $env:JAVA_HOME } else { throw 'Pass -JdkHome with a JDK 17+ directory.' }
}
$jpackage = Join-Path $JdkHome 'bin\jpackage.exe'
if (-not (Test-Path -LiteralPath $jpackage)) { throw 'A JDK 17+ with jpackage is required.' }
if (-not (Test-Path (Join-Path $WixDirectory 'candle.exe'))) { throw 'WiX 3 build tools are required. Pass -WixDirectory with their extracted location.' }
if (-not $SkipBuild) {
    Push-Location $project
    try { & mvn -B -ntp package; if ($LASTEXITCODE -ne 0) { throw 'Maven build failed.' } }
    finally { Pop-Location }
}
$stage = Join-Path $project 'build\installer-input'
New-Item -ItemType Directory -Force -Path $stage | Out-Null
Copy-Item -LiteralPath (Join-Path $project 'target\bloomdesk-1.0.0.jar') -Destination $stage -Force
Copy-Item -LiteralPath (Join-Path $project 'setup\Setup-Database.ps1') -Destination $stage -Force
Copy-Item -LiteralPath (Join-Path $project 'README.md') -Destination $stage -Force
Copy-Item -LiteralPath (Join-Path $project 'THIRD-PARTY-NOTICES.md') -Destination $stage -Force
Copy-Item -LiteralPath (Join-Path $project 'setup\database.sql') -Destination $stage -Force
$outDir = Join-Path $project 'dist'
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
$env:PATH = $WixDirectory + ';' + $env:PATH
$common = @('--icon',(Join-Path $project 'setup\app-icon.ico'),'--input',$stage,'--main-jar','bloomdesk-1.0.0.jar','--name','BloomDesk','--app-version','1.0.0','--vendor','Afra - EAD Coursework','--description','Floral sales orders and delivery planning','--java-options','-Dfile.encoding=UTF-8','--add-modules','java.se,jdk.crypto.ec,jdk.charsets')
$image = Join-Path $outDir 'BloomDesk'
if (Test-Path -LiteralPath $image) { throw "Existing app image at $image. Move it aside before rebuilding to keep the prior package." }
& $jpackage --type app-image --dest $outDir @common
if ($LASTEXITCODE -ne 0) { throw 'App image generation failed.' }
& $jpackage --type exe --dest $outDir --app-image $image --name BloomDesk --app-version 1.0.0 --vendor 'Afra - EAD Coursework' --win-per-user-install --win-dir-chooser --win-menu --win-shortcut --win-menu-group 'EAD Coursework' --install-dir BloomDesk
if ($LASTEXITCODE -ne 0) { throw 'Installer generation failed.' }
Write-Host 'BloomDesk application image and Windows EXE setup generated.'
