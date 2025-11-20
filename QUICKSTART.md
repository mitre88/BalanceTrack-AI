# BalanceTrack AI - Quick Start Guide 🚀

Get up and running with BalanceTrack AI in 5 minutes!

## Prerequisites

Before you begin, ensure you have:
- ✅ Mac with macOS Ventura or later
- ✅ Xcode 15.0 or later installed
- ✅ Apple Developer account (for device testing)
- ✅ iPhone/iPad with iOS 18+ or Simulator

## Step 1: Clone the Repository

```bash
git clone https://github.com/yourusername/BalanceTrack-AI.git
cd BalanceTrack-AI
```

## Step 2: Open in Xcode

```bash
open BalanceTrackAI/BalanceTrackAI.xcodeproj
```

Or:
1. Launch Xcode
2. File → Open
3. Navigate to `BalanceTrackAI.xcodeproj`
4. Click "Open"

## Step 3: Select Your Target

1. Click on the device selector in the toolbar
2. Choose either:
   - **iPhone Simulator** (e.g., iPhone 15 Pro)
   - **Your Physical Device** (must be connected via USB)

## Step 4: Build and Run

Press `⌘ + R` or click the "Play" button in the toolbar.

Wait for:
- ✅ Dependencies to resolve
- ✅ Project to build
- ✅ App to launch

**Expected time**: 30-60 seconds for first build

## Step 5: Explore the App

### First Launch
1. App opens to the **Dashboard**
2. No data yet - that's normal!

### Add Your First Transaction
1. Tap the **floating + button** (bottom right)
2. Enter an amount (e.g., "50.00")
3. Select **Expense** or **Income**
4. Choose a category (e.g., "Food")
5. Add a title (e.g., "Grocery Shopping")
6. Tap **Save Transaction**

### View AI Insights
1. Add 3-5 more transactions
2. Navigate to **Insights tab**
3. See AI-generated recommendations
4. Tap an insight to expand details

### Explore Analytics
1. Navigate to **Analytics tab**
2. Try different time periods
3. View interactive charts
4. Check spending statistics

## Troubleshooting

### Build Fails
```
Error: "Swift Compiler Error"
```
**Solution**:
- Clean build folder: `⌘ + Shift + K`
- Rebuild: `⌘ + B`

### Simulator Issues
```
Error: "Simulator failed to boot"
```
**Solution**:
- Xcode → Window → Devices and Simulators
- Right-click simulator → Delete
- Create new simulator

### Code Signing Error
```
Error: "Signing requires a development team"
```
**Solution**:
1. Select project in navigator
2. Select target "BalanceTrackAI"
3. Signing & Capabilities tab
4. Select your Team

### SwiftData Issues
```
Error: "Cannot create ModelContainer"
```
**Solution**:
- This is normal on first run
- App will create database automatically
- Restart the app if needed

## Running on Physical Device

### Setup
1. Connect iPhone/iPad via USB
2. Trust computer on device
3. Select device in Xcode
4. Build and run (`⌘ + R`)

### First Install
- Device may ask to "Trust Developer"
- Go to Settings → General → VPN & Device Management
- Trust your developer certificate

## Project Structure Overview

```
BalanceTrackAI/
├── BalanceTrackAIApp.swift    ← App entry point
├── ContentView.swift           ← Main navigation
├── Models/                     ← Data models
├── Views/                      ← UI screens
├── Services/                   ← Business logic
└── Extensions/                 ← UI helpers
```

## Key Files to Explore

1. **DashboardView.swift** - Main screen with balance and insights
2. **AIFinancialAdvisor.swift** - AI insights generation
3. **LiquidGlassModifier.swift** - UI effects and animations
4. **Transaction.swift** - Core data model

## Next Steps

### Customize the App
- Edit colors in `ColorExtensions.swift`
- Adjust AI thresholds in `AIFinancialAdvisor.swift`
- Modify animations in `LiquidGlassModifier.swift`

### Add Features
- Implement export functionality
- Add widgets
- Create Siri shortcuts
- Build Apple Watch companion

### Prepare for App Store
1. Read `APP_STORE.md`
2. Create app icons (see `ICON_DESIGN.md`)
3. Take screenshots
4. Write app description
5. Submit for review

## Helpful Xcode Shortcuts

| Shortcut | Action |
|----------|--------|
| `⌘ + R` | Build and Run |
| `⌘ + .` | Stop Running |
| `⌘ + B` | Build |
| `⌘ + Shift + K` | Clean Build |
| `⌘ + Shift + O` | Open Quickly |
| `⌘ + /` | Comment/Uncomment |
| `⌘ + Option + [` | Move Line Up |
| `⌘ + Option + ]` | Move Line Down |

## Testing Checklist

Before making changes, test:
- [ ] Add income transaction
- [ ] Add expense transaction
- [ ] View dashboard
- [ ] Check insights
- [ ] Explore analytics
- [ ] Test dark mode
- [ ] Try different devices

## Getting Help

### Documentation
- 📚 Full README: `README.md`
- 🎨 Icon Guide: `ICON_DESIGN.md`
- 🏪 App Store Guide: `APP_STORE.md`

### Resources
- 🔗 Apple Developer Docs: https://developer.apple.com
- 🔗 SwiftUI Tutorials: https://developer.apple.com/tutorials/swiftui
- 🔗 Swift Forums: https://forums.swift.org

### Common Questions

**Q: How do I change the app name?**
A: Edit `Info.plist` → `CFBundleDisplayName`

**Q: How do I add a new category?**
A: Edit `Transaction.swift` → `TransactionCategory` enum

**Q: How do I customize colors?**
A: Edit `ColorExtensions.swift`

**Q: Where is data stored?**
A: SwiftData stores in app's Documents folder automatically

## Performance Tips

### For Faster Builds
1. Use Simulator instead of device during development
2. Enable "Build Active Architecture Only" in Debug mode
3. Close other apps to free up RAM

### For Better Performance
1. Test on real device for accurate performance
2. Use Instruments to profile
3. Monitor memory usage in Debug Navigator

## What's Next?

Now that you have the app running:

1. ✅ Explore the codebase
2. ✅ Read the full documentation
3. ✅ Customize to your needs
4. ✅ Add your own features
5. ✅ Share your improvements!

---

## 🎉 Congratulations!

You've successfully set up BalanceTrack AI!

Happy coding! 💰✨

---

**Need more help?** Check out the [full README](README.md) or [open an issue](https://github.com/yourusername/BalanceTrack-AI/issues).
