$lockfile = "C:\kiosk\initial-install.lock"

If( -not (Test-Path -Path $lockfile) ) {
    Write-Host "Installing packages"
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    choco install puppet-agent --version=5.5.22 -y --no-progress
#    choco install pdk -y --no-progress
    choco install git -y --no-progress

    cmd.exe /k '"C:\Program Files\Puppet Labs\Puppet\bin\environment.bat" & "C:\Program Files\Puppet Labs\Puppet\sys\ruby\bin\gem.bat" install --no-ri --no-rdoc hiera-eyaml & exit'

    echo 'Setting Up C:/\ProgramData/\PuppetLabs'
    rmdir 'C:/\ProgramData/\PuppetLabs' -Force -Recurse

    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    
    git clone 'https://github.com/rowead/nodel-puppet-starter-windows.git' 'C:/\ProgramData/\PuppetLabs'

    New-item -ItemType "directory" -Path "C:\kiosk"
    New-item -Path "C:\kiosk\install-method-git"
    Write-Host "Writing lockfile to $lockfile"
    New-item -ItemType "directory" -Path "C:\kiosk\locks"
    New-item -Path $lockfile
}
else {
    Write-Host "Initial packages already installed"
}
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
Write-Host "Performing Puppet Run"
puppet apply C:\ProgramData\PuppetLabs\code\environments\production\manifests\sites.pp