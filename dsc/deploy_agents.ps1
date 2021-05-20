param ($VHDLocations, $InstallSourceFSLogix, $InstallSourceABR)

New-Item -Path "C:\" -Name "Install" -ItemType "directory"

if (-not ([string]::IsNullOrEmpty($InstallSourceFsLogix)))
{
    New-Item -Path "HKLM:\SOFTWARE" -Name "FSLogix"
    New-Item -Path "HKLM:\SOFTWARE\FSLogix" -Name "Profiles"
    New-ItemProperty -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name "Enabled" -Value "1" -PropertyType "Dword" -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name "VHDLocations" -Value $VHDLocations -PropertyType "MultiString" -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\FSLogix\Profiles" -Name "DeleteLocalProfileWhenVHDShouldApply" -Value "1" -PropertyType "Dword" -Force
    Invoke-WebRequest -Uri $InstallSourceFSLogix -OutFile "C:\Install\FSLogixAppsSetup.exe"
    Start-Process -Wait -FilePath "C:\Install\FSLogixAppsSetup.exe" -ArgumentList "/install /quiet" -PassThru
}

if (-not ([string]::IsNullOrEmpty($InstallSourceABR)))
{
    Invoke-WebRequest -Uri $InstallSourceABR -OutFile "C:\Install\abr_7_ws.msi"
    Start-Process -Wait -FilePath "msiexec" -ArgumentList "/i C:\Install\abr_7_ws.msi /q" -PassThru
}
