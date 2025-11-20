# Contributing to BalanceTrack AI 🤝

First off, thank you for considering contributing to BalanceTrack AI! It's people like you that make this app better for everyone.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Guidelines](#development-guidelines)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Testing](#testing)

---

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inspiring community for all. Please be respectful and constructive in all interactions.

### Expected Behavior

- ✅ Be respectful and inclusive
- ✅ Welcome newcomers
- ✅ Be patient and understanding
- ✅ Give constructive feedback
- ✅ Focus on what's best for the community

### Unacceptable Behavior

- ❌ Harassment or discrimination
- ❌ Trolling or insulting comments
- ❌ Personal or political attacks
- ❌ Publishing others' private information

---

## Getting Started

### Prerequisites

Before contributing, ensure you have:

- macOS Ventura or later
- Xcode 15.0 or later
- Swift 5.9+ knowledge
- SwiftUI experience
- Git installed and configured

### Fork and Clone

1. **Fork the repository** on GitHub
2. **Clone your fork**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/BalanceTrack-AI.git
   cd BalanceTrack-AI
   ```
3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/ORIGINAL_OWNER/BalanceTrack-AI.git
   ```

### Build the Project

1. Open Xcode:
   ```bash
   open BalanceTrackAI/BalanceTrackAI.xcodeproj
   ```
2. Select a simulator (iPhone 15 Pro)
3. Press `⌘ + B` to build
4. Press `⌘ + R` to run

---

## How to Contribute

### Reporting Bugs 🐛

**Before submitting a bug report:**
- Check the existing issues to avoid duplicates
- Collect information about the bug
- Test with the latest version

**Bug Report Template:**

```markdown
**Description**
A clear description of the bug.

**Steps to Reproduce**
1. Go to '...'
2. Click on '...'
3. Scroll down to '...'
4. See error

**Expected Behavior**
What you expected to happen.

**Actual Behavior**
What actually happened.

**Screenshots**
If applicable, add screenshots.

**Environment**
- iOS Version: [e.g., 18.0]
- Device: [e.g., iPhone 15 Pro]
- App Version: [e.g., 1.0]

**Additional Context**
Any other context about the problem.
```

### Suggesting Features 💡

**Feature Request Template:**

```markdown
**Feature Description**
A clear description of the feature.

**Problem it Solves**
What problem does this feature solve?

**Proposed Solution**
How should this feature work?

**Alternatives Considered**
Other solutions you've considered.

**Additional Context**
Mockups, examples, or references.
```

### Contributing Code 💻

1. **Find an issue** to work on (or create one)
2. **Comment** on the issue to claim it
3. **Create a branch**:
   ```bash
   git checkout -b feature/amazing-feature
   ```
4. **Make your changes**
5. **Test thoroughly**
6. **Commit** with a clear message
7. **Push** to your fork
8. **Open a Pull Request**

---

## Development Guidelines

### Project Structure

```
BalanceTrackAI/
├── Models/          # Data models
├── Views/           # UI components
├── Services/        # Business logic
├── Extensions/      # Helpers and extensions
└── Assets.xcassets/ # Images and colors
```

### Branch Naming

Use descriptive branch names:

- `feature/add-export-csv` - New features
- `fix/crash-on-delete` - Bug fixes
- `refactor/data-layer` - Code refactoring
- `docs/update-readme` - Documentation
- `test/add-unit-tests` - Tests

### Commit Messages

Follow the Conventional Commits specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code style (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

**Examples:**

```bash
feat(analytics): add monthly comparison chart

Add a new chart showing 6-month spending comparison with
bar chart visualization.

Closes #45
```

```bash
fix(dashboard): resolve crash when no transactions

Fixed null pointer exception when accessing empty transaction
array on first launch.

Fixes #67
```

---

## Coding Standards

### Swift Style Guide

Follow [Swift.org API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)

**Key Points:**

1. **Naming**
   ```swift
   // ✅ Good
   func calculateTotalExpenses(for transactions: [Transaction]) -> Double

   // ❌ Bad
   func calcExp(trans: [Transaction]) -> Double
   ```

2. **Spacing**
   ```swift
   // ✅ Good
   if condition {
       doSomething()
   }

   // ❌ Bad
   if condition{
       doSomething()
   }
   ```

3. **Formatting**
   - Use 4 spaces for indentation
   - Maximum line length: 120 characters
   - Add blank lines between functions

4. **Comments**
   ```swift
   /// Calculates the total expenses for a given period
   /// - Parameter transactions: Array of transactions to analyze
   /// - Returns: Total expense amount
   func calculateTotalExpenses(for transactions: [Transaction]) -> Double {
       // Implementation
   }
   ```

### SwiftUI Best Practices

1. **Keep Views Small**
   ```swift
   // ✅ Good - Extract subviews
   struct DashboardView: View {
       var body: some View {
           ScrollView {
               HeaderView()
               BalanceCard()
               StatisticsView()
           }
       }
   }

   // ❌ Bad - Everything in one view
   struct DashboardView: View {
       var body: some View {
           // 500+ lines of UI code
       }
   }
   ```

2. **Use @State Correctly**
   ```swift
   // ✅ Good - Simple local state
   @State private var isExpanded = false

   // ❌ Bad - Complex data in @State
   @State private var allTransactions: [Transaction] = []
   ```

3. **Prefer ViewModifiers**
   ```swift
   // ✅ Good - Reusable modifier
   .liquidGlass(cornerRadius: 20)

   // ❌ Bad - Repeated code
   .background(...)
   .overlay(...)
   .clipShape(...)
   ```

### Code Organization

1. **File Structure**
   ```swift
   // MARK: - Type Declaration

   struct MyView: View {
       // MARK: - Properties

       @State private var value: String = ""

       // MARK: - Body

       var body: some View {
           // UI code
       }

       // MARK: - Private Methods

       private func handleAction() {
           // Logic
       }
   }

   // MARK: - Preview

   #Preview {
       MyView()
   }
   ```

2. **Import Order**
   ```swift
   // System frameworks first
   import Foundation
   import SwiftUI
   import SwiftData

   // Third-party frameworks
   import SomePackage

   // Local imports
   import Models
   ```

---

## Testing

### Unit Tests

Add unit tests for business logic:

```swift
import XCTest
@testable import BalanceTrackAI

final class AIFinancialAdvisorTests: XCTestCase {

    func testSavingsRateCalculation() {
        // Given
        let transactions = [
            Transaction(amount: 1000, type: .income, category: .salary, title: "Salary"),
            Transaction(amount: 200, type: .expense, category: .food, title: "Groceries")
        ]

        // When
        let summary = AIFinancialAdvisor.shared.generateMonthlySummary(transactions: transactions)

        // Then
        XCTAssertEqual(summary.savingsRate, 80.0, accuracy: 0.1)
    }
}
```

### UI Tests

Test critical user flows:

```swift
func testAddTransaction() {
    let app = XCUIApplication()
    app.launch()

    // Tap add button
    app.buttons["add_transaction"].tap()

    // Fill form
    app.textFields["amount"].tap()
    app.textFields["amount"].typeText("50.00")

    // Save
    app.buttons["save"].tap()

    // Verify
    XCTAssertTrue(app.staticTexts["$50.00"].exists)
}
```

### Manual Testing Checklist

Before submitting PR:

- [ ] Test on iPhone simulator (multiple sizes)
- [ ] Test on iPad simulator
- [ ] Test in dark mode
- [ ] Test with VoiceOver (accessibility)
- [ ] Test all edge cases
- [ ] No compiler warnings
- [ ] No crashes or memory leaks

---

## Pull Request Process

### Before Submitting

1. **Update from upstream**:
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Run tests**:
   ```bash
   ⌘ + U in Xcode
   ```

3. **Check code style**:
   - No warnings
   - Consistent formatting
   - Comments where needed

4. **Update documentation**:
   - Update README if needed
   - Add inline documentation
   - Update CHANGELOG.md

### PR Template

```markdown
## Description
Brief description of changes.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
How has this been tested?

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-reviewed code
- [ ] Commented complex code
- [ ] Updated documentation
- [ ] No new warnings
- [ ] Added tests
- [ ] All tests pass
- [ ] Verified on device

## Screenshots (if applicable)
Add screenshots or videos.

## Related Issues
Closes #XX
```

### Review Process

1. **Automated checks** will run
2. **Maintainers** will review
3. **Address feedback** if requested
4. **Approval** from at least one maintainer
5. **Merge** by maintainer

---

## Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Credited in the app (future feature)

---

## Questions?

- 📧 Email: contribute@balancetrack.ai
- 💬 Discussions: GitHub Discussions
- 🐛 Issues: GitHub Issues

---

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing to BalanceTrack AI!** 🎉

Every contribution, no matter how small, makes a difference!
