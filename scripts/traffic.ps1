# Sends requests for N seconds and counts failures. Used to prove zero-downtime
# while deleting pods, upgrading or rolling back
# Usage: .\scripts\traffic.ps1 -Url http://dev.127.0.0.1.nip.io/api/users/ -Seconds 60
param(
    [Parameter(Mandatory = $true)][string]$Url,
    [int]$Seconds = 60
)

$end = (Get-Date).AddSeconds($Seconds)
$ok = 0
$err = 0
while ((Get-Date) -lt $end) {
    try {
        Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 3 | Out-Null
        $ok++
    }
    catch {
        $err++
        Write-Host "$(Get-Date -Format HH:mm:ss.fff) ERROR $($_.Exception.Message)"
    }
    Start-Sleep -Milliseconds 200
}
"$(Get-Date -Format s) url=$Url seconds=$Seconds ok=$ok err=$err"