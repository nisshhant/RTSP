# Set Variables
$projectPath = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
$venvPath = "$projectPath\venv"
$mainApp = "RTSP_Live_streaming.py"
$serviceName = "FAAVService"
$nssmPath = "nssm"  # Ensure nssm.exe is in PATH or give full path like "C:\Tools\nssm.exe"

# Step 1: Create Virtual Environment
Write-Output "Creating virtual environment..."
python -m venv $venvPath

# Step 2: Activate and install dependencies
Write-Output "Installing FastAPI and Uvicorn..."
& "$venvPath\Scripts\pip.exe" install --upgrade pip
& "$venvPath\Scripts\pip.exe" install fastapi uvicorn

# Step 3: Create a start script for the service
$runScriptPath = "$projectPath\run_api.bat"
$runCommand = "@echo off`n$venvPath\Scripts\python.exe $projectPath\$mainApp"
$runCommand | Out-File -Encoding ASCII $runScriptPath

# Step 4: Register Windows Service using NSSM
Write-Output "Registering Windows service '$serviceName'..."
& $nssmPath install $serviceName "$runScriptPath"

# Optional: Configure service properties (autostart, restart on fail, etc.)
& $nssmPath set $serviceName Start SERVICE_AUTO_START
& $nssmPath set $serviceName AppDirectory $projectPath

# Step 5: Start the service
Write-Output "Starting the service..."
Start-Service $serviceName

Write-Output "`n✅ FastAPI Service '$serviceName' is set up and running!"
