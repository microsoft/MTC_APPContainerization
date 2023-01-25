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
Invoke-WebRequest 'https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/f5524660-74d7-4441-9aba-4c5884a171a5/MicrosoftEdgeEnterpriseX64.msi' -OutFile 'C:\MicrosoftEdgeEnterpriseX64.msi'
$msiArgs = @(
    "/i"
    "C:\MicrosoftEdgeEnterpriseX64.msi"
    "/qn"
    "/norestart"
    "/L*v C:\edge-install-log.txt"
)
Start-Process msiexec.exe -ArgumentList $msiArgs -Wait -NoNewWindow

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

# Enable the PowerShell remote setting
Enable-PSRemoting -Force

# Install IIS and relavant features
Install-WindowsFeature -name Web-Server -IncludeManagementTools
Set-ExecutionPolicy Bypass -Scope Process -Force

Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServer
Enable-WindowsOptionalFeature -Online -FeatureName IIS-CommonHttpFeatures
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpErrors
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpRedirect
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationDevelopment

Enable-WindowsOptionalFeature -online -FeatureName NetFx4Extended-ASPNET45
Enable-WindowsOptionalFeature -Online -FeatureName IIS-NetFxExtensibility45

Enable-WindowsOptionalFeature -Online -FeatureName IIS-HealthAndDiagnostics
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpLogging
Enable-WindowsOptionalFeature -Online -FeatureName IIS-LoggingLibraries
Enable-WindowsOptionalFeature -Online -FeatureName IIS-RequestMonitor
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpTracing
Enable-WindowsOptionalFeature -Online -FeatureName IIS-Security
Enable-WindowsOptionalFeature -Online -FeatureName IIS-RequestFiltering
Enable-WindowsOptionalFeature -Online -FeatureName IIS-Performance
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerManagementTools
Enable-WindowsOptionalFeature -Online -FeatureName IIS-IIS6ManagementCompatibility
Enable-WindowsOptionalFeature -Online -FeatureName IIS-Metabase
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ManagementConsole
Enable-WindowsOptionalFeature -Online -FeatureName IIS-BasicAuthentication
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WindowsAuthentication
Enable-WindowsOptionalFeature -Online -FeatureName IIS-StaticContent
Enable-WindowsOptionalFeature -Online -FeatureName IIS-DefaultDocument
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebSockets
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationInit
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ISAPIExtensions
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ISAPIFilter
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpCompressionStatic

Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASPNET45

# Download and unzip the sample app file
Invoke-WebRequest 'https://appcontainerizationlearn.blob.core.windows.net/appcontainerizationlearndotnet/parts.zip' -OutFile 'D:\parts.zip'
Expand-Archive -LiteralPath 'D:\parts.zip' -DestinationPath D:\parts

# Update the database connection string
$dbname = $args[0]
((Get-Content -path D:\parts\parts\Web.config -Raw) -replace 'RANDBNAME', $dbname) | Set-Content -Path D:\parts\parts\Web.config

# Delete default website and create the application pool and website
Get-WebSite -Name "Default Web Site" | Remove-WebSite -Confirm:$false -Verbose
new-WebSite -name "parts" -Port 80 -PhysicalPath "D:\parts\parts\" -Force
