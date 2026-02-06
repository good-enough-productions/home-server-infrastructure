# Run this in PowerShell on your Windows machine to set the API Key
[System.Environment]::SetEnvironmentVariable('N8N_API_KEY', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI0N2NkYjUyYi02MjU0LTQzZTYtYWIyNi05M2E2MGE4OTc0NmEiLCJpc3MiOiJuOG4iLCJhdWQiOiJwdWJsaWMtYXBpIiwiaWF0IjoxNzY0MDE3MTkyfQ.sXj2CPKgzLHr6tLFRxwkVyDCl_mC4GbMZU-KQZJlGvQ', 'User')

Write-Host "N8N_API_KEY has been set for your user account."
Write-Host "You may need to restart your terminal or VS Code for it to take effect."
