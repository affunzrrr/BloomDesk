param(
    [string]$DatabaseHost = '127.0.0.1',
    [int]$DatabasePort = 3306,
    [string]$AdminUser = 'root',
    [string]$MySqlExe = ''
)
$ErrorActionPreference = 'Stop'
if (-not $MySqlExe) {
    $command = Get-Command mysql.exe -ErrorAction SilentlyContinue
    if ($command) { $MySqlExe = $command.Source }
    elseif (Test-Path 'C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe') { $MySqlExe = 'C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe' }
    else { throw 'Install MySQL Server 8.0+ and its command-line client, then pass -MySqlExe with the client path.' }
}
if ($DatabaseHost -notmatch '^[a-zA-Z0-9.-]+$' -or $AdminUser -notmatch '^[a-zA-Z0-9_]+$' -or $DatabasePort -lt 1 -or $DatabasePort -gt 65535) { throw 'Invalid host, administrator name or port.' }
$adminSecret = Read-Host 'MySQL administrator password' -AsSecureString
$ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($adminSecret)
try { $adminPassword = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr) }
finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr) }
$random = New-Object byte[] 24
$rng = [Security.Cryptography.RandomNumberGenerator]::Create()
$rng.GetBytes($random)
$appPassword = -join ($random | ForEach-Object { $_.ToString('x2') })
$rng.Dispose()
$sql = @"
CREATE DATABASE IF NOT EXISTS afra_bloom CHARACTER SET utf8mb4;
CREATE USER IF NOT EXISTS 'bloom_app'@'127.0.0.1' IDENTIFIED BY '$appPassword';
ALTER USER 'bloom_app'@'127.0.0.1' IDENTIFIED BY '$appPassword';
GRANT ALL PRIVILEGES ON afra_bloom.* TO 'bloom_app'@'127.0.0.1';
CREATE USER IF NOT EXISTS 'bloom_app'@'localhost' IDENTIFIED BY '$appPassword';
ALTER USER 'bloom_app'@'localhost' IDENTIFIED BY '$appPassword';
GRANT ALL PRIVILEGES ON afra_bloom.* TO 'bloom_app'@'localhost';
"@
$schemaFile = Join-Path $PSScriptRoot 'database.sql'
if (-not (Test-Path -LiteralPath $schemaFile)) { throw 'The bundled database.sql file is missing.' }
$sql += "`nUSE afra_bloom;`n" + [IO.File]::ReadAllText($schemaFile)
$info = New-Object Diagnostics.ProcessStartInfo
$info.FileName = $MySqlExe
$info.Arguments = "--protocol=TCP --host=$DatabaseHost --port=$DatabasePort --user=$AdminUser --default-character-set=utf8mb4"
$info.UseShellExecute = $false
$info.CreateNoWindow = $true
$info.RedirectStandardInput = $true
$info.RedirectStandardError = $true
$info.RedirectStandardOutput = $true
$info.EnvironmentVariables['MYSQL_PWD'] = $adminPassword
$process = New-Object Diagnostics.Process
$process.StartInfo = $info
try {
    [void]$process.Start()
    $process.StandardInput.WriteLine($sql)
    $process.StandardInput.Close()
    $failure = $process.StandardError.ReadToEnd()
    $process.WaitForExit()
    if ($process.ExitCode -ne 0) { throw "Database provisioning failed: $failure" }
} finally { $process.Dispose(); $adminPassword = $null; $info.EnvironmentVariables.Remove('MYSQL_PWD') }
$configDir = Join-Path $env:USERPROFILE '.ead\bloomdesk'
New-Item -ItemType Directory -Path $configDir -Force | Out-Null
$connection = @"
host=$DatabaseHost
port=$DatabasePort
database=afra_bloom
user=bloom_app
password=$appPassword
"@
$configFile = Join-Path $configDir 'database.properties'
[IO.File]::WriteAllText($configFile,$connection,[Text.UTF8Encoding]::new($false))
$appPassword = $null
Write-Host 'BloomDesk database and restricted local application account are ready.'
Write-Host "Connection settings: $configFile"
Write-Host 'The four simple tables, demo records and login have been created.'
Write-Host 'Demo sign-in: admin / Bloom@2026'
