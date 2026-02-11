# ============================================
# Script untuk Get SHA-1 & SHA-256
# ============================================

Write-Host "🔑 Getting SHA-1 & SHA-256 Fingerprints" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$keystorePath = "C:\Users\Acer\upload-keystore.jks"
$alias = "upload"

# Check if keystore exists
if (-Not (Test-Path $keystorePath)) {
    Write-Host "❌ Keystore not found at: $keystorePath" -ForegroundColor Red
    Write-Host ""
    Write-Host "Do you want to create a new keystore? (y/n): " -NoNewline -ForegroundColor Yellow
    $response = Read-Host
    
    if ($response -eq "y") {
        Write-Host ""
        Write-Host "🔨 Creating new keystore..." -ForegroundColor Green
        Write-Host ""
        
        keytool -genkey -v -keystore $keystorePath -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias $alias
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "✅ Keystore created successfully!" -ForegroundColor Green
        } else {
            Write-Host ""
            Write-Host "❌ Failed to create keystore" -ForegroundColor Red
            exit 1
        }
    } else {
        exit 1
    }
}

Write-Host ""
Write-Host "📄 Getting fingerprints from: $keystorePath" -ForegroundColor Yellow
Write-Host ""

# Get fingerprints
keytool -list -v -keystore $keystorePath -alias $alias | Select-String -Pattern "SHA1:|SHA256:"

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "📋 Next Steps:" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Copy SHA-1 dan SHA-256 dari output di atas" -ForegroundColor White
Write-Host "2. Buka Firebase Console:" -ForegroundColor White
Write-Host "   https://console.firebase.google.com/" -ForegroundColor Blue
Write-Host "3. Settings > Project settings > Your apps > Android" -ForegroundColor White
Write-Host "4. Klik 'Add fingerprint' dan paste SHA-1" -ForegroundColor White
Write-Host "5. Klik 'Add fingerprint' lagi dan paste SHA-256" -ForegroundColor White
Write-Host "6. Save" -ForegroundColor White
Write-Host ""
Write-Host "7. Buka Google Cloud Console:" -ForegroundColor White
Write-Host "   https://console.cloud.google.com/" -ForegroundColor Blue
Write-Host "8. APIs & Services > Credentials" -ForegroundColor White
Write-Host "9. Edit OAuth Client ID untuk Android" -ForegroundColor White
Write-Host "10. Tambahkan SHA-1 yang sama" -ForegroundColor White
Write-Host "11. Save" -ForegroundColor White
Write-Host ""
Write-Host "12. Tunggu 5-10 menit untuk propagasi" -ForegroundColor Yellow
Write-Host ""
Write-Host "✅ Done! Now you can build release APK" -ForegroundColor Green
Write-Host ""
