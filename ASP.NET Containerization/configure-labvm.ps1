function Disable-InternetExplorerESC {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 -Force
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 -Force
    Stop-Process -Name Explorer -Force
    Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green
}

# Resolves an error caused by Powershell defaulting to TLS 1.0 to connect to websites, but website security requires TLS 1.2.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls, [Net.SecurityProtocolType]::Tls11, [Net.SecurityProtocolType]::Tls12, [Net.SecurityProtocolType]::Ssl3
[Net.ServicePointManager]::SecurityProtocol = "Tls, Tls11, Tls12, Ssl3"

# Disable IE ESC
Disable-InternetExplorerESC

# Download and istall Microsoft Edge
Invoke-WebRequest 'https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/0a4291f0-226e-4d0a-a702-7aa901f20ff4/MicrosoftEdgeEnterpriseX64.msi' -OutFile 'C:\MicrosoftEdgeEnterpriseX64.msi'
$msiArgs = @(
    "/i"
    "C:\MicrosoftEdgeEnterpriseX64.msi"
    "/qn"
    "/norestart"
    "/L*v C:\edge-install-log.txt"
)
Start-Process msiexec.exe -ArgumentList $msiArgs -Wait -NoNewWindow

# Set Trusted Hosts to access everything
Set-Item WSMan:\localhost\Client\TrustedHosts -Value * -Force

# Download and install MicrosoftWebDeployTool
Invoke-WebRequest 'https://aka.ms/webdeploy3.6' -OutFile 'C:\MicrosoftWebDeploy.msi'
$msiArgs = @(
    "/i"
    "C:\MicrosoftWebDeploy.msi"
    "/qn"
    "/norestart"
    "/L*v C:\webdeploytool-install-log.txt"
)
Start-Process msiexec.exe -ArgumentList $msiArgs -Wait -NoNewWindow