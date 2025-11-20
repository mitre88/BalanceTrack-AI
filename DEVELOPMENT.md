# Development Guide 👨‍💻

Complete guide for developers working on BalanceTrack AI.

---

## Table of Contents

- [Environment Setup](#environment-setup)
- [Project Architecture](#project-architecture)
- [Development Workflow](#development-workflow)
- [Debugging Tips](#debugging-tips)
- [Performance Optimization](#performance-optimization)
- [Common Tasks](#common-tasks)
- [Troubleshooting](#troubleshooting)

---

## Environment Setup

### Required Tools

1. **macOS Ventura or later**
2. **Xcode 15.0+**
   - Download from Mac App Store
   - Or download from [developer.apple.com](https://developer.apple.com/download/)

3. **Swift 5.9+** (comes with Xcode)

4. **Git** (comes with Xcode Command Line Tools)
   ```bash
   xcode-select --install
   ```

### Optional Tools

- **SF Symbols App** - For icon exploration
- **Figma** - For UI design
- **Instruments** - Performance profiling (comes with Xcode)
- **Postman** - API testing (future features)

### Xcode Configuration

#### Recommended Settings

1. **Editor → Font & Colors**
   - Choose your preferred theme
   - Recommended: Default (Dark) or Presentation

2. **Behaviors**
   - Configure for testing, running, debugging
   - Set up automatic console clearing

3. **Key Bindings**
   - Customize shortcuts if needed
   - Recommended defaults work well

4. **Source Control**
   - Configure Git author info
   - Enable automatic push/pull

### Project Setup

```bash
# Clone repository
git clone https://github.com/yourusername/BalanceTrack-AI.git
cd BalanceTrack-AI

# Open in Xcode
open BalanceTrackAI/BalanceTrackAI.xcodeproj

# Or use command line
xed BalanceTrackAI/BalanceTrackAI.xcodeproj
```

---

## Project Architecture

### MVVM Pattern

```
┌─────────────┐
│    View     │  ← SwiftUI Views
│  (UI Layer) │
└──────┬──────┘
       │
       │ Observes
       │
┌──────▼──────┐
│  ViewModel  │  ← @Observable classes
│ (Logic Layer)│
└──────┬──────┘
       │
       │ Uses
       │
┌──────▼──────┐
│    Model    │  ← SwiftData models
│ (Data Layer) │
└─────────────┘
```

### Layer Responsibilities

**View Layer** (`Views/`)
- Render UI
- Handle user interactions
- Observe state changes
- NO business logic

**ViewModel Layer** (Observable classes in `Services/`)
- Business logic
- State management
- Data transformation
- API calls (future)

**Model Layer** (`Models/`)
- Data structures
- SwiftData entities
- Relationships
- Validation rules

### Directory Structure

```
BalanceTrackAI/
│
├── BalanceTrackAIApp.swift    # App entry point, scene configuration
├── ContentView.swift           # Main tab navigation
│
├── Models/                     # 🗃️ Data Layer
│   ├── Transaction.swift       # Core transaction model
│   └── FinancialInsight.swift  # AI insight model
│
├── Views/                      # 🎨 UI Layer
│   ├── DashboardView.swift     # Home screen (balance, insights)
│   ├── AddTransactionView.swift # Transaction entry form
│   ├── TransactionsListView.swift # Full transaction list
│   ├── InsightsView.swift      # AI recommendations view
│   └── AnalyticsView.swift     # Charts and statistics
│
├── Services/                   # 💼 Business Logic
│   ├── AIFinancialAdvisor.swift # AI insights engine
│   ├── PreviewData.swift       # Sample data for development
│   └── DataManager.swift       # Data operations helper
│
├── Extensions/                 # 🔧 Helpers
│   ├── LiquidGlassModifier.swift # UI effects & modifiers
│   ├── ColorExtensions.swift   # Color system & themes
│   └── ViewExtensions.swift    # View helpers & utilities
│
├── Assets.xcassets/            # 🎭 Assets
│   ├── AppIcon.appiconset/     # App icon (all sizes)
│   ├── BrandPrimary.colorset/  # Brand colors
│   └── BrandSecondary.colorset/
│
└── Info.plist                  # App configuration
```

### Key Components

#### Transaction Model
```swift
@Model
final class Transaction {
    var id: UUID
    var amount: Double
    var type: TransactionType        // income or expense
    var category: TransactionCategory // food, transport, etc.
    var title: String
    var notes: String
    var date: Date
    var isRecurring: Bool
    var recurringFrequency: RecurringFrequency?
}
```

#### AI Financial Advisor
```swift
@Observable
class AIFinancialAdvisor {
    func generateInsights(from: [Transaction]) -> [FinancialInsight]
    func generateWeeklySummary(transactions:) -> FinancialSummary
    func generateMonthlySummary(transactions:) -> FinancialSummary
    func generateYearlySummary(transactions:) -> FinancialSummary
}
```

---

## Development Workflow

### Daily Workflow

1. **Start of Day**
   ```bash
   # Pull latest changes
   git pull origin main

   # Create feature branch
   git checkout -b feature/new-feature

   # Open Xcode
   open BalanceTrackAI/BalanceTrackAI.xcodeproj
   ```

2. **During Development**
   - Use SwiftUI previews for rapid iteration
   - Build frequently (`⌘ + B`)
   - Run on simulator (`⌘ + R`)
   - Test on real device periodically

3. **End of Day**
   ```bash
   # Commit work
   git add .
   git commit -m "feat: add new feature"

   # Push to remote
   git push origin feature/new-feature
   ```

### Feature Development

#### 1. Planning
- Read the feature requirement
- Identify affected components
- Plan data model changes
- Sketch UI if needed

#### 2. Implementation
```
1. Update data models (if needed)
2. Create/update services
3. Build UI components
4. Add animations/effects
5. Test thoroughly
6. Document code
```

#### 3. Testing
- Manual testing on simulator
- Test on real device
- Test edge cases
- Verify accessibility
- Check performance

#### 4. Review
- Self-review code
- Check for warnings
- Run all tests
- Update documentation

### Code Review Checklist

- [ ] Code follows style guide
- [ ] No compiler warnings
- [ ] SwiftUI previews work
- [ ] Accessibility labels added
- [ ] Dark mode tested
- [ ] Comments for complex logic
- [ ] No force unwraps
- [ ] Error handling implemented
- [ ] Performance considered
- [ ] Documentation updated

---

## Debugging Tips

### Xcode Debugger

**Breakpoints**
```swift
// Add breakpoint (click line number)
func calculateTotal() {
    let total = transactions.reduce(0) { $0 + $1.amount } // ← Click here
    return total
}
```

**Conditional Breakpoints**
```
Right-click breakpoint → Edit Breakpoint
Condition: total > 1000
Action: Log message "Total exceeds threshold"
```

**LLDB Commands**
```lldb
(lldb) po transaction          # Print object
(lldb) p transaction.amount    # Print value
(lldb) e transaction.amount = 100  # Change value
(lldb) bt                      # Stack trace
```

### SwiftUI Debugging

**View Hierarchy**
```
Debug → View Debugging → Capture View Hierarchy
```

**State Inspection**
```swift
struct MyView: View {
    @State private var count = 0

    var body: some View {
        Text("\(count)")
            .onTapGesture {
                print("🐛 Count before: \(count)")
                count += 1
                print("🐛 Count after: \(count)")
            }
    }
}
```

**Preview Debugging**
```swift
#Preview("With Data") {
    DashboardView(transactions: PreviewData.sampleTransactions)
        .modelContainer(ModelContainer.preview)
        .onAppear {
            print("🐛 Preview loaded with \(PreviewData.sampleTransactions.count) transactions")
        }
}
```

### Common Issues

**Issue: SwiftUI Preview Not Working**
```swift
// Solution 1: Clean build folder
⌘ + Shift + K

// Solution 2: Restart Xcode
⌘ + Q, then reopen

// Solution 3: Delete derived data
rm -rf ~/Library/Developer/Xcode/DerivedData
```

**Issue: SwiftData Not Saving**
```swift
// Ensure you call save()
modelContext.insert(transaction)
try? modelContext.save()  // ← Don't forget this!
```

**Issue: Memory Leak**
```
Use Instruments:
Product → Profile → Leaks
Run app and monitor for leaks
```

---

## Performance Optimization

### SwiftUI Performance

**1. Lazy Loading**
```swift
// ✅ Good - Lazy loading
ScrollView {
    LazyVStack {
        ForEach(transactions) { transaction in
            TransactionRow(transaction: transaction)
        }
    }
}

// ❌ Bad - Eager loading
ScrollView {
    VStack {
        ForEach(transactions) { transaction in
            TransactionRow(transaction: transaction)
        }
    }
}
```

**2. View Identity**
```swift
// ✅ Good - Stable ID
ForEach(transactions) { transaction in
    TransactionRow(transaction: transaction)
}

// ❌ Bad - Index-based
ForEach(transactions.indices, id: \.self) { index in
    TransactionRow(transaction: transactions[index])
}
```

**3. Expensive Computations**
```swift
// ✅ Good - Computed once
let totalExpenses = transactions
    .filter { $0.type == .expense }
    .reduce(0) { $0 + $1.amount }

// ❌ Bad - Computed every render
var body: some View {
    Text("Total: \(transactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount })")
}
```

### Profiling

**Instruments Tools**

1. **Time Profiler**
   ```
   Product → Profile → Time Profiler
   - Find slow functions
   - Optimize hot paths
   ```

2. **Allocations**
   ```
   Product → Profile → Allocations
   - Track memory usage
   - Find leaks
   ```

3. **Energy Log**
   ```
   Product → Profile → Energy Log
   - Monitor battery impact
   - Optimize energy usage
   ```

### Best Practices

- Use `@State` for local state
- Use `@Observable` for shared state
- Avoid force unwrapping (`!`)
- Use `guard` for early returns
- Minimize view updates
- Cache expensive calculations
- Use lazy collections
- Profile before optimizing

---

## Common Tasks

### Adding a New View

1. **Create File**
   ```
   File → New → File → SwiftUI View
   Name: MyNewView.swift
   Location: BalanceTrackAI/Views/
   ```

2. **Implement View**
   ```swift
   import SwiftUI

   struct MyNewView: View {
       var body: some View {
           Text("Hello, World!")
       }
   }

   #Preview {
       MyNewView()
   }
   ```

3. **Add to Navigation**
   ```swift
   // In ContentView.swift
   MyNewView()
       .tabItem {
           Label("My View", systemImage: "star")
       }
       .tag(4)
   ```

### Adding a New Category

1. **Update Enum**
   ```swift
   // In Transaction.swift
   enum TransactionCategory: String, Codable, CaseIterable {
       // Existing cases...
       case myNewCategory = "My Category"

       var icon: String {
           switch self {
           case .myNewCategory: return "icon.name"
           // Other cases...
           }
       }
   }
   ```

2. **Update UI**
   ```swift
   // AddTransactionView will automatically show new category
   ```

### Adding a New Color

1. **Add to Assets**
   ```
   Assets.xcassets → New Color Set
   Name: MyCustomColor
   Set colors for Light/Dark appearance
   ```

2. **Add Extension**
   ```swift
   // In ColorExtensions.swift
   extension Color {
       static let myCustomColor = Color("MyCustomColor")
   }
   ```

3. **Use in Code**
   ```swift
   Text("Hello")
       .foregroundColor(.myCustomColor)
   ```

### Modifying AI Logic

```swift
// In AIFinancialAdvisor.swift

private func generateSavingsInsights(...) -> [FinancialInsight] {
    // Change threshold
    if savingsRate < 15 {  // Changed from 10
        // Generate insight
    }

    // Add new insight type
    if balance > 5000 {
        insights.append(FinancialInsight(
            title: "Large Balance Alert",
            message: "Consider investing...",
            type: .investmentAdvice,
            priority: .medium
        ))
    }

    return insights
}
```

---

## Troubleshooting

### Build Errors

**Error: "Cannot find type in scope"**
```
Solution: Check import statements and file targets
```

**Error: "Ambiguous use of operator"**
```
Solution: Add explicit types to resolve ambiguity
let value: Double = transaction.amount
```

**Error: "SwiftData schema mismatch"**
```
Solution: Delete app from simulator and rebuild
```

### Runtime Errors

**Crash: "NSInvalidArgumentException"**
```
Check for nil values and optional unwrapping
Use guard/if let instead of force unwrap
```

**Crash: "Index out of range"**
```
Validate array indices before accessing
Use .first, .last instead of subscripting
```

### Performance Issues

**Slow scrolling**
```
- Use LazyVStack/LazyHStack
- Simplify view hierarchy
- Profile with Instruments
```

**High memory usage**
```
- Check for retain cycles
- Use weak self in closures
- Release resources when done
```

---

## Resources

### Apple Documentation

- [SwiftUI](https://developer.apple.com/documentation/swiftui)
- [SwiftData](https://developer.apple.com/documentation/swiftdata)
- [Swift](https://docs.swift.org)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines)

### Tutorials

- [100 Days of SwiftUI](https://www.hackingwithswift.com/100/swiftui)
- [Stanford CS193p](https://cs193p.sites.stanford.edu)
- [Apple SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)

### Community

- [Swift Forums](https://forums.swift.org)
- [r/iOSProgramming](https://reddit.com/r/iOSProgramming)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/swiftui)

---

## Getting Help

If you're stuck:

1. Check this guide
2. Search existing issues on GitHub
3. Ask in GitHub Discussions
4. Reach out to maintainers

---

**Happy Developing!** 🚀
