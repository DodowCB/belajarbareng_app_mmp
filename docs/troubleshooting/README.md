# 🔧 Troubleshooting Guide

Common issues dan solusinya untuk BelajarBareng app development.

---

## 📚 Available Guides

### [handleThenable Fix](./HANDLETHENABLE_FIX.md)

**Issue**: Firebase authentication error pada web platform  
**Error Message**: `Try correcting the name to the name of an existing method, or defining a method named 'handleThenable'`

**Quick Fix:**

1. Update Firebase dependencies
2. Proper Firebase initialization
3. Enhanced error handling

**Status**: ✅ Solved

---

## 🐛 Common Issues & Solutions

### 1. Dependency Conflicts

**Problem:**

```bash
Error: Version solving failed.
```

**Solution:**

```bash
# Clean and reinstall
flutter clean
flutter pub get

# If still fails, try:
flutter pub upgrade
```

---

### 2. Hot Reload Not Working

**Problem:**
Changes not reflecting when pressing 'r'

**Solutions:**

```bash
# Try hot restart
Press 'R' in terminal

# Or rerun
flutter run -d <device>

# Enable hot reload explicitly
flutter run --hot
```

---

### 3. Platform Not Available

**Problem:**

```bash
Error: No devices found
```

**Solution:**

```bash
# Check available devices
flutter devices

# Enable web platform
flutter create --platforms=web .

# Enable windows platform
flutter create --platforms=windows .

# Enable all platforms
flutter create --platforms=web,windows,android,ios .
```

---

### 4. Import Errors

**Problem:**

```dart
Error: Not found: 'package:...'
```

**Solutions:**

**Check dependency in pubspec.yaml:**

```yaml
dependencies:
  package_name: ^version
```

**Run pub get:**

```bash
flutter pub get
```

**Fix import path:**

```dart
// Wrong
import 'package:wrong_name/file.dart';

// Correct
import 'package:belajarbareng_app_mmp/src/...';
```

---

### 5. Firebase Configuration Error

**Problem:**

```
Error: Firebase not initialized
```

**Solution:**

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure

# Select your Firebase project
# Choose platforms (web, android, ios, etc.)
```

**Manual fix:**

```dart
// In main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
```

---

### 6. API Key Not Working

**Problem:**
YouTube API or other API returns 403/401 errors

**Solutions:**

**Check API key is set:**

```dart
// lib/src/api/config/api_config.dart
class ApiConfig {
  static const String youtubeApiKey = 'YOUR_API_KEY_HERE';
}
```

**Verify API key in Cloud Console:**

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Check API key restrictions
3. Enable required APIs (YouTube Data API v3)
4. Check quota limits

**Test API key:**

```bash
# Test with curl
curl "https://www.googleapis.com/youtube/v3/search?part=snippet&q=test&key=YOUR_API_KEY"
```

---

### 7. Theme Not Updating

**Problem:**
Dark/Light mode toggle tidak berubah

**Solutions:**

**Check provider is watched:**

```dart
// Wrong
class MyWidget extends StatelessWidget {

// Correct
class MyWidget extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeModeProvider);
```

**Check MaterialApp uses provider:**

```dart
return MaterialApp(
  themeMode: ref.watch(themeModeProvider), // Must watch!
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
);
```

---

### 8. Build Errors on Web

**Problem:**

```
Error: Web renderer failed
```

**Solutions:**

```bash
# Use HTML renderer
flutter run -d chrome --web-renderer html

# Use CanvasKit renderer (better performance)
flutter run -d chrome --web-renderer canvaskit

# Auto-select
flutter run -d chrome --web-renderer auto
```

---

### 9. Null Safety Errors

**Problem:**

```dart
Error: The parameter 'value' can't have a value of 'null'
```

**Solutions:**

**Use null-aware operators:**

```dart
// Null-aware access
String? name = user?.name;

// Null assertion (use carefully!)
String name = user!.name;

// Null coalescing
String name = user?.name ?? 'Default Name';

// Late initialization
late String name;
```

**Make variables nullable:**

```dart
String? optionalValue;
```

---

### 10. Widget Overflow Errors

**Problem:**

```
A RenderFlex overflowed by X pixels
```

**Solutions:**

**Use Flexible/Expanded:**

```dart
Row(
  children: [
    Flexible(child: Text('Long text...')),
    Expanded(child: Widget()),
  ],
)
```

**Use SingleChildScrollView:**

```dart
SingleChildScrollView(
  child: Column(children: [...]),
)
```

**Set constraints:**

```dart
ConstrainedBox(
  constraints: BoxConstraints(maxWidth: 300),
  child: Widget(),
)
```

---

### 11. State Not Persisting

**Problem:**
App state resets on hot reload

**Expected Behavior:**
This is normal! Hot reload creates new state.

**Solutions:**

**For persistent data:**

```dart
// Use SharedPreferences
final prefs = await SharedPreferences.getInstance();
await prefs.setString('theme', 'dark');

// Or use Hive/Drift for local storage
```

**For testing:**
Use dummy data or mock data during development

---

### 12. Performance Issues

**Problem:**
App laggy or slow

**Solutions:**

**Profile the app:**

```bash
flutter run --profile
# Open DevTools
```

**Common fixes:**

```dart
// Use const constructors
const Text('Static text')

// Avoid rebuilding entire tree
// Use Builder or extract widgets

// Use ListView.builder for long lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

---

## 🚨 Emergency Checklist

When nothing works:

```bash
# 1. Clean everything
flutter clean

# 2. Delete build folders
# Manually delete: build/, .dart_tool/

# 3. Get dependencies
flutter pub get

# 4. Verify Flutter
flutter doctor -v

# 5. Update Flutter
flutter upgrade

# 6. Rebuild
flutter run
```

---

## 📊 Debugging Tools

### Flutter DevTools

```bash
# Run app in debug mode
flutter run

# Press 'v' to open DevTools in browser
# Or manually: https://localhost:<port>
```

**Features:**

- Widget Inspector
- Performance view
- Network profiler
- Logging view
- Memory view

### VS Code Debugging

1. Set breakpoints in code (click left margin)
2. Press F5 or Run → Start Debugging
3. Use Debug Console for expressions

### Print Debugging

```dart
// Use debugPrint for production-safe logging
debugPrint('Value: $value');

// Use logger package for better logs
final logger = Logger();
logger.d('Debug message');
logger.e('Error message');
```

---

## 🔍 Where to Find Help

### Internal Resources

1. **Documentation**: Check `docs/` folder
2. **Code Comments**: Read existing code
3. **Git History**: See what changed

### External Resources

1. **Flutter Docs**: https://flutter.dev/docs
2. **Stack Overflow**: Search your error
3. **Flutter Discord**: https://discord.gg/flutter
4. **GitHub Issues**: Check flutter/flutter repo

---

## 📝 Reporting Issues

When reporting issues to team:

**Include:**

1. **Error message** (full stack trace)
2. **Steps to reproduce**
3. **Expected vs actual behavior**
4. **Platform** (web, android, ios, etc.)
5. **Flutter version** (`flutter --version`)
6. **Code snippet** (if relevant)

**Format:**

```markdown
## Issue: [Brief description]

**Platform**: Web/Windows/Android/iOS
**Flutter Version**: 3.9.0

**Steps to Reproduce:**

1. Open app
2. Click X
3. See error

**Expected**: Should do Y
**Actual**: Error Z occurs

**Error Message:**
```

[Paste error here]

```

**Code:**
[Paste relevant code]
```

---

## 🎯 Prevention Tips

### Before Coding

1. ✅ Read feature documentation
2. ✅ Understand architecture
3. ✅ Plan your changes
4. ✅ Check existing patterns

### While Coding

1. ✅ Test frequently
2. ✅ Use hot reload
3. ✅ Read error messages carefully
4. ✅ Add debug prints

### After Coding

1. ✅ Test on multiple platforms
2. ✅ Check for null safety
3. ✅ Run `flutter analyze`
4. ✅ Clean up debug code

---

## 📖 Related Documentation

- [Getting Started](../GETTING_STARTED.md) - Setup guide
- [Architecture](../architecture/README.md) - Project structure
- [Features](../features/README.md) - Feature documentation

---

**Last Updated**: November 3, 2025  
**Maintained by**: Development Team

Having an issue not listed here? Check the specific troubleshooting guides above or contact the team! 🚀
