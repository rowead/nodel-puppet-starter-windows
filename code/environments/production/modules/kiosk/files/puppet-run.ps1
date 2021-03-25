$lockfile = "C:\kiosk\locks\puppet-run.lock"

If( -not (Test-Path -Path $lockfile) ) {
    New-item -path $lockfile
    cd C:\ProgramData\PuppetLabs
    git pull
    puppet apply code\environments\production\manifests\sites.pp
    Remove-Item -path $lockfile
} else {
    Write-Host "Lock file detected, skipping puppet run"
}
exit