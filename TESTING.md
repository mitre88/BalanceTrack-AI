# Testing Guide 🧪

Comprehensive testing guide for BalanceTrack AI.

---

## Table of Contents

- [Testing Philosophy](#testing-philosophy)
- [Manual Testing](#manual-testing)
- [Unit Testing](#unit-testing)
- [UI Testing](#ui-testing)
- [Performance Testing](#performance-testing)
- [Accessibility Testing](#accessibility-testing)
- [Test Data](#test-data)

---

## Testing Philosophy

### Our Approach

**Quality over Speed**
- Thorough testing before release
- Test on real devices
- Consider edge cases
- User experience first

**Test Pyramid**
```
        /\
       /  \      E2E Tests (Few)
      /----\
     /      \    Integration Tests (Some)
    /--------\
   /          \  Unit Tests (Many)
  /____________\
```

### When to Test

- ✅ After implementing a feature
- ✅ Before creating a pull request
- ✅ After fixing a bug
- ✅ Before each release
- ✅ When changing core logic

---

## Manual Testing

### Pre-Release Checklist

#### Core Functionality
- [ ] Launch app successfully
- [ ] Add income transaction
- [ ] Add expense transaction
- [ ] Edit transaction
- [ ] Delete transaction
- [ ] View transaction details
- [ ] Search transactions
- [ ] Filter by type (income/expense)
- [ ] Navigate between tabs
- [ ] View AI insights
- [ ] View analytics charts
- [ ] Switch time periods

#### Edge Cases
- [ ] Add transaction with $0 amount
- [ ] Add transaction with very large amount (999,999,999)
- [ ] Add transaction with long title (100+ chars)
- [ ] Add transaction with special characters
- [ ] Add transaction with future date
- [ ] Add transaction with past date (2+ years ago)
- [ ] View empty state (no transactions)
- [ ] View with 1000+ transactions
- [ ] Rapid tapping on buttons
- [ ] Background/foreground app transitions

#### UI/UX
- [ ] All animations play smoothly
- [ ] No visual glitches
- [ ] Proper spacing and alignment
- [ ] Text truncation works correctly
- [ ] Images load properly
- [ ] Colors match design
- [ ] Transitions are smooth

#### Device Sizes
- [ ] iPhone SE (3rd gen) - Small
- [ ] iPhone 15 Pro - Medium
- [ ] iPhone 15 Pro Max - Large
- [ ] iPad mini - Tablet
- [ ] iPad Pro 12.9" - Large tablet

#### Orientations
- [ ] Portrait mode
- [ ] Landscape mode (iPhone)
- [ ] iPad multitasking

#### iOS Versions
- [ ] iOS 18.0
- [ ] iOS 18.1
- [ ] Latest beta (if available)

#### System Settings
- [ ] Light mode
- [ ] Dark mode
- [ ] Increased contrast
- [ ] Large text sizes
- [ ] Reduced motion
- [ ] Right-to-left languages (future)

### Test Scenarios

#### Scenario 1: New User Experience

**Steps:**
1. Install and launch app
2. Observe empty state
3. Tap floating + button
4. Fill transaction form
5. Save transaction
6. Return to dashboard
7. Verify transaction appears

**Expected:**
- Empty state shows helpful message
- Form is intuitive
- Save succeeds
- Dashboard updates immediately
- No crashes or errors

#### Scenario 2: Power User

**Steps:**
1. Add 50+ transactions
2. Navigate through all tabs
3. Use search function
4. Apply filters
5. View different time periods
6. Check insights
7. Review analytics

**Expected:**
- Smooth performance
- No lag or stuttering
- Accurate calculations
- Meaningful insights
- Charts render correctly

#### Scenario 3: Financial Insights

**Steps:**
1. Add mix of income/expenses
2. Navigate to Insights tab
3. Review all insights
4. Tap to expand insight details
5. Read action items

**Expected:**
- Insights are relevant
- Calculations are correct
- Language is clear
- Impact scores make sense
- Action items are helpful

---

## Unit Testing

### Setup

Create test target if not exists:
```
File → New → Target → Unit Testing Bundle
Name: BalanceTrackAITests
```

### Writing Tests

#### Test Structure

```swift
import XCTest
@testable import BalanceTrackAI

final class MyFeatureTests: XCTestCase {

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        // Setup code
    }

    override func tearDown() {
        // Cleanup code
        super.tearDown()
    }

    // MARK: - Tests

    func testSomething() {
        // Given - Setup test data
        let input = 100.0

        // When - Execute code under test
        let result = calculateSomething(input)

        // Then - Assert expectations
        XCTAssertEqual(result, 200.0)
    }
}
```

### Example Tests

#### Testing AI Financial Advisor

```swift
final class AIFinancialAdvisorTests: XCTestCase {

    var advisor: AIFinancialAdvisor!

    override func setUp() {
        super.setUp()
        advisor = AIFinancialAdvisor.shared
    }

    func testSavingsRateCalculation() {
        // Given
        let transactions = [
            Transaction(amount: 1000, type: .income, category: .salary, title: "Salary"),
            Transaction(amount: 800, type: .expense, category: .food, title: "Expenses")
        ]

        // When
        let summary = advisor.generateMonthlySummary(transactions: transactions)

        // Then
        XCTAssertEqual(summary.savingsRate, 20.0, accuracy: 0.1)
        XCTAssertEqual(summary.balance, 200.0)
    }

    func testHighSpendingInsight() async {
        // Given
        let transactions = [
            Transaction(amount: 5000, type: .income, category: .salary, title: "Salary"),
            Transaction(amount: 2000, type: .expense, category: .shopping, title: "Shopping")
        ]

        // When
        let insights = await advisor.generateInsights(from: transactions)

        // Then
        XCTAssertFalse(insights.isEmpty)
        let hasSpendingWarning = insights.contains { $0.type == .spendingWarning }
        XCTAssertTrue(hasSpendingWarning)
    }

    func testTrendDetection() {
        // Test increasing spending trend
        let oldTransactions = [
            Transaction(amount: 100, type: .expense, category: .food,
                       title: "Food", date: Date().addingTimeInterval(-60*60*24*45))
        ]

        let newTransactions = oldTransactions + [
            Transaction(amount: 200, type: .expense, category: .food,
                       title: "Food", date: Date().addingTimeInterval(-60*60*24*15))
        ]

        // Assertions for trend detection
    }
}
```

#### Testing Data Manager

```swift
final class DataManagerTests: XCTestCase {

    func testCSVExport() {
        // Given
        let transactions = [
            Transaction(amount: 50.0, type: .expense, category: .food,
                       title: "Groceries", date: Date())
        ]

        // When
        let csv = DataManager.shared.exportToCSV(transactions: transactions)

        // Then
        XCTAssertTrue(csv.contains("Groceries"))
        XCTAssertTrue(csv.contains("50.00"))
        XCTAssertTrue(csv.contains("Food"))
    }

    func testStatisticsCalculation() {
        // Given
        let transactions = PreviewData.sampleTransactions

        // When
        let stats = DataManager.shared.calculateStatistics(transactions: transactions)

        // Then
        XCTAssertGreaterThan(stats.totalIncome, 0)
        XCTAssertGreaterThan(stats.totalExpenses, 0)
        XCTAssertNotNil(stats.largestExpense)
    }
}
```

### Running Tests

**All Tests**
```
⌘ + U
```

**Single Test**
```
Click diamond next to test method
```

**Test Class**
```
Click diamond next to class name
```

### Test Coverage

Enable code coverage:
```
Edit Scheme → Test → Options → Code Coverage ✓
```

View coverage:
```
⌘ + 9 (Report Navigator) → Coverage
```

**Target**: 70%+ code coverage

---

## UI Testing

### Setup

Create UI test target:
```
File → New → Target → UI Testing Bundle
```

### Writing UI Tests

```swift
import XCTest

final class BalanceTrackAIUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAddTransaction() {
        // Tap add button
        app.buttons["add_transaction"].tap()

        // Fill form
        let amountField = app.textFields["amount"]
        amountField.tap()
        amountField.typeText("50.00")

        let titleField = app.textFields["title"]
        titleField.tap()
        titleField.typeText("Test Transaction")

        // Select type
        app.buttons["expense"].tap()

        // Select category
        app.buttons["food"].tap()

        // Save
        app.buttons["save"].tap()

        // Verify
        XCTAssertTrue(app.staticTexts["Test Transaction"].exists)
    }

    func testTabNavigation() {
        // Test all tabs
        app.tabBars.buttons["Dashboard"].tap()
        XCTAssertTrue(app.navigationBars["BalanceTrack AI"].exists)

        app.tabBars.buttons["Transactions"].tap()
        XCTAssertTrue(app.navigationBars["Transactions"].exists)

        app.tabBars.buttons["Insights"].tap()
        XCTAssertTrue(app.navigationBars["Insights"].exists)

        app.tabBars.buttons["Analytics"].tap()
        XCTAssertTrue(app.navigationBars["Analytics"].exists)
    }

    func testSearch() {
        // Navigate to transactions
        app.tabBars.buttons["Transactions"].tap()

        // Enter search
        let searchField = app.searchFields.firstMatch
        searchField.tap()
        searchField.typeText("Grocery")

        // Verify filtered results
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'Grocery'")).count > 0)
    }
}
```

### Accessibility Identifiers

Add to views for easier testing:

```swift
Button("Save") {
    saveTransaction()
}
.accessibilityIdentifier("save_button")

TextField("Amount", text: $amount)
    .accessibilityIdentifier("amount_field")
```

---

## Performance Testing

### Measuring Performance

```swift
func testDashboardPerformance() {
    measure {
        // Code to measure
        let transactions = PreviewData.generateRandomTransactions(count: 1000)
        let summary = AIFinancialAdvisor.shared.generateMonthlySummary(transactions: transactions)
    }
}
```

### Performance Targets

| Operation | Target | Max |
|-----------|--------|-----|
| App Launch | < 1s | 2s |
| Add Transaction | < 0.1s | 0.5s |
| Load Dashboard | < 0.5s | 1s |
| Generate Insights | < 1s | 3s |
| Render Chart | < 0.2s | 0.5s |

### Profiling

Use Instruments:
```
Product → Profile → Time Profiler
```

---

## Accessibility Testing

### VoiceOver Testing

1. Enable VoiceOver
   ```
   Settings → Accessibility → VoiceOver → On
   ```

2. Test navigation
   - Swipe right to move forward
   - Swipe left to move backward
   - Double tap to activate

3. Verify labels
   - All interactive elements have labels
   - Labels are descriptive
   - Order makes sense

### Dynamic Type

Test with different text sizes:
```
Settings → Accessibility → Display & Text Size → Larger Text
```

Verify:
- Text scales properly
- No text truncation
- Layout adjusts correctly

### Reduced Motion

Test with reduced motion:
```
Settings → Accessibility → Motion → Reduce Motion
```

Verify:
- Animations are simplified
- No motion-based functionality breaks

---

## Test Data

### Using Sample Data

```swift
// In development/testing
let transactions = PreviewData.sampleTransactions
let insights = PreviewData.sampleInsights

// Generate random data
let randomTransactions = PreviewData.generateRandomTransactions(count: 100)
```

### Clearing Test Data

```swift
// In app during development
DataManager.shared.clearAllData(context: modelContext)
```

### Reset App

Delete and reinstall:
```bash
# Delete from simulator
xcrun simctl uninstall booted com.balancetrack.ai

# Reinstall
⌘ + R in Xcode
```

---

## Continuous Testing

### Pre-Commit
- Run affected tests
- Fix any failures
- Verify no regressions

### Pre-Push
- Run all unit tests
- Run smoke UI tests
- Check test coverage

### Pre-Release
- Full test suite
- Manual testing checklist
- Device testing
- Performance testing
- Accessibility audit

---

## Bug Report Template

When you find a bug:

```markdown
**Description**
Clear description of the bug

**Steps to Reproduce**
1. Step one
2. Step two
3. Step three

**Expected Behavior**
What should happen

**Actual Behavior**
What actually happens

**Environment**
- iOS Version:
- Device:
- App Version:

**Screenshots/Videos**
Attach if applicable

**Additional Context**
Any other relevant information
```

---

## Resources

- [XCTest Documentation](https://developer.apple.com/documentation/xctest)
- [WWDC Testing Videos](https://developer.apple.com/videos/frameworks/testing)
- [iOS Testing Guide](https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/testing_with_xcode/)

---

**Remember**: Good tests make confident developers! 🎯
