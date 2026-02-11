# ============================================
# Script untuk Build & Deploy Release APK
# ============================================

Write-Host "🚀 Building Release APK" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Check if key.properties exists
$keyPropsPath = "android\key.properties"
if (-Not (Test-Path $keyPropsPath)) {
    Write-Host "❌ key.properties not found!" -ForegroundColor Red
    Write-Host "Please create android/key.properties with your keystore info" -ForegroundColor Yellow
    exit 1
}

# Check if keystore exists
$keystore = Get-Content $keyPropsPath | Select-String -Pattern "storeFile=" | ForEach-Object { $_.ToString().Split("=")[1] }
if (-Not (Test-Path $keystore)) {
    Write-Host "❌ Keystore not found at: $keystore" -ForegroundColor Red
    Write-Host "Please update android/key.properties with correct keystore path" -ForegroundColor Yellow
    exit 1
}

Write-Host "✓ Found keystore: $keystore" -ForegroundColor Green
Write-Host ""

# Step 1: Clean
Write-Host "🧹 Step 1: Cleaning project..." -ForegroundColor Yellow
flutter clean
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Clean failed!" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Clean complete" -ForegroundColor Green
Write-Host ""

# Step 2: Get dependencies
Write-Host "📦 Step 2: Getting dependencies..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Pub get failed!" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Dependencies installed" -ForegroundColor Green
Write-Host ""

# Step 3: Build APK
Write-Host "🔨 Step 3: Building release APK..." -ForegroundColor Yellow
Write-Host "This may take a few minutes..." -ForegroundColor Gray
flutter build apk --release
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build failed!" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Build complete" -ForegroundColor Green
Write-Host ""

$apkPath = "build\app\outputs\flutter-apk\app-release.apk"
if (Test-Path $apkPath) {
    $apkSize = (Get-Item $apkPath).Length / 1MB
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "✅ APK Ready!" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📱 APK Location: $apkPath" -ForegroundColor White
    Write-Host "📦 APK Size: $([math]::Round($apkSize, 2)) MB" -ForegroundColor White
    Write-Host ""
    Write-Host "📋 Next Steps:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Option 1 - Install via ADB:" -ForegroundColor White
    Write-Host "  adb install -r $apkPath" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Option 2 - Transfer manual:" -ForegroundColor White
    Write-Host "  1. Copy APK ke device" -ForegroundColor Gray
    Write-Host "  2. Tap file APK di device" -ForegroundColor Gray
    Write-Host "  3. Install" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Option 3 - Open folder:" -ForegroundColor White
    Write-Host "  explorer build\app\outputs\flutter-apk\" -ForegroundColor Gray
    Write-Host ""
    
    # Ask to install
    Write-Host "Do you want to install to connected device now? (y/n): " -NoNewline -ForegroundColor Yellow
    $response = Read-Host
    
    if ($response -eq "y") {
        Write-Host ""
        Write-Host "📲 Installing to device..." -ForegroundColor Yellow
        adb install -r $apkPath
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "✅ Installation complete!" -ForegroundColor Green
            Write-Host ""
            Write-Host "📱 Open the app on your device and test Google Drive login" -ForegroundColor Cyan
        } else {
            Write-Host ""
            Write-Host "❌ Installation failed!" -ForegroundColor Red
            Write-Host "Make sure device is connected: adb devices" -ForegroundColor Yellow
        }
    } else {
        Write-Host ""
        Write-Host "✅ Build complete! APK ready for distribution" -ForegroundColor Green
    }
} else {
    Write-Host "❌ APK file not found!" -ForegroundColor Red
    exit 1
}

Write-Host ""
