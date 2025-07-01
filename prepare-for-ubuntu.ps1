# PowerShell script to prepare Ubuntu Welcome Fancy for transfer to Ubuntu
# This script creates a setup instruction file since we can't chmod on Windows

Write-Host "Ubuntu Fancy Welcome Screen - Windows Preparation Complete!" -ForegroundColor Green
Write-Host ""
Write-Host "To set up on Ubuntu, transfer all files to your Ubuntu system and run:" -ForegroundColor Cyan
Write-Host ""
Write-Host "# Make scripts executable" -ForegroundColor Yellow
Write-Host "chmod +x *.sh templates/*.sh" -ForegroundColor White
Write-Host ""
Write-Host "# Run the installer" -ForegroundColor Yellow  
Write-Host "./install-welcome.sh" -ForegroundColor White
Write-Host ""
Write-Host "Files created:" -ForegroundColor Green
Get-ChildItem -Path "c:\Github\UbuntuWelcomeFancy" -Recurse -File | Select-Object Name, Directory | Format-Table -AutoSize

Write-Host ""
Write-Host "Repository ready for GitHub upload!" -ForegroundColor Green
Write-Host "GitHub: https://github.com/SteffMet/ubuntu-welcome-fancy" -ForegroundColor Blue
