//
//  PreviewData.swift
//  BalanceTrackAI
//
//  Sample data for SwiftUI previews and development
//

import Foundation
import SwiftUI

/// Provides sample data for development and previews
struct PreviewData {

    // MARK: - Sample Transactions

    static var sampleTransactions: [Transaction] {
        let calendar = Calendar.current
        let now = Date()

        return [
            // Recent transactions
            Transaction(
                amount: 85.50,
                type: .expense,
                category: .food,
                title: "Grocery Shopping",
                notes: "Weekly groceries at Whole Foods",
                date: now,
                isRecurring: false
            ),

            Transaction(
                amount: 3500.00,
                type: .income,
                category: .salary,
                title: "Monthly Salary",
                notes: "Tech Company Inc.",
                date: calendar.date(byAdding: .day, value: -2, to: now)!,
                isRecurring: true,
                recurringFrequency: .monthly
            ),

            Transaction(
                amount: 45.00,
                type: .expense,
                category: .transport,
                title: "Uber to Office",
                notes: "Morning commute",
                date: calendar.date(byAdding: .day, value: -3, to: now)!,
                isRecurring: false
            ),

            Transaction(
                amount: 150.00,
                type: .expense,
                category: .shopping,
                title: "New Shoes",
                notes: "Nike running shoes",
                date: calendar.date(byAdding: .day, value: -5, to: now)!,
                isRecurring: false
            ),

            Transaction(
                amount: 12.99,
                type: .expense,
                category: .entertainment,
                title: "Netflix Subscription",
                notes: "Monthly streaming",
                date: calendar.date(byAdding: .day, value: -7, to: now)!,
                isRecurring: true,
                recurringFrequency: .monthly
            ),

            Transaction(
                amount: 500.00,
                type: .income,
                category: .freelance,
                title: "Website Design Project",
                notes: "Client: ABC Corp",
                date: calendar.date(byAdding: .day, value: -10, to: now)!,
                isRecurring: false
            ),

            Transaction(
                amount: 75.30,
                type: .expense,
                category: .bills,
                title: "Electric Bill",
                notes: "Monthly utilities",
                date: calendar.date(byAdding: .day, value: -12, to: now)!,
                isRecurring: true,
                recurringFrequency: .monthly
            ),

            Transaction(
                amount: 200.00,
                type: .expense,
                category: .health,
                title: "Dental Checkup",
                notes: "Regular cleaning",
                date: calendar.date(byAdding: .day, value: -15, to: now)!,
                isRecurring: false
            ),

            Transaction(
                amount: 50.00,
                type: .income,
                category: .gift,
                title: "Birthday Gift from Mom",
                notes: "Thank you!",
                date: calendar.date(byAdding: .day, value: -20, to: now)!,
                isRecurring: false
            ),

            Transaction(
                amount: 120.00,
                type: .expense,
                category: .education,
                title: "Online Course",
                notes: "Swift Programming Masterclass",
                date: calendar.date(byAdding: .day, value: -25, to: now)!,
                isRecurring: false
            ),

            // Older transactions for trend analysis
            Transaction(
                amount: 65.00,
                type: .expense,
                category: .food,
                title: "Restaurant Dinner",
                notes: "Italian place downtown",
                date: calendar.date(byAdding: .day, value: -30, to: now)!,
                isRecurring: false
            ),

            Transaction(
                amount: 3500.00,
                type: .income,
                category: .salary,
                title: "Monthly Salary",
                notes: "Tech Company Inc.",
                date: calendar.date(byAdding: .day, value: -32, to: now)!,
                isRecurring: true,
                recurringFrequency: .monthly
            ),

            Transaction(
                amount: 800.00,
                type: .expense,
                category: .travel,
                title: "Weekend Trip",
                notes: "San Francisco vacation",
                date: calendar.date(byAdding: .day, value: -45, to: now)!,
                isRecurring: false
            ),

            Transaction(
                amount: 250.00,
                type: .income,
                category: .investment,
                title: "Stock Dividends",
                notes: "Quarterly dividends",
                date: calendar.date(byAdding: .day, value: -60, to: now)!,
                isRecurring: false
            )
        ]
    }

    // MARK: - Sample Insights

    static var sampleInsights: [FinancialInsight] {
        [
            FinancialInsight(
                title: "Great Savings Performance!",
                message: "You're saving 25% of your income this month, which is above the recommended 20% threshold. Keep up the excellent work!",
                type: .savingOpportunity,
                priority: .low,
                actionItems: [
                    "Consider investing surplus savings",
                    "Build emergency fund to 6 months expenses",
                    "Review long-term financial goals"
                ],
                impactScore: 85
            ),

            FinancialInsight(
                title: "High Entertainment Spending",
                message: "Your entertainment spending has increased by 40% compared to last month. Consider setting a budget limit.",
                type: .spendingWarning,
                priority: .medium,
                actionItems: [
                    "Review streaming subscriptions",
                    "Set a monthly entertainment budget of $150",
                    "Look for free entertainment alternatives"
                ],
                impactScore: 70
            ),

            FinancialInsight(
                title: "Recurring Expense Opportunity",
                message: "You have 5 recurring expenses totaling $250/month. Review these regularly to ensure they're all necessary.",
                type: .budgetTip,
                priority: .low,
                actionItems: [
                    "Cancel unused subscriptions",
                    "Negotiate better rates for services",
                    "Consider annual payments for discounts"
                ],
                impactScore: 60
            ),

            FinancialInsight(
                title: "Positive Spending Trend",
                message: "Excellent! You've reduced overall spending by 15% this month. Your discipline is paying off.",
                type: .trend,
                priority: .low,
                actionItems: [
                    "Continue current spending habits",
                    "Identify what strategies worked",
                    "Redirect savings to emergency fund"
                ],
                impactScore: 90
            ),

            FinancialInsight(
                title: "Investment Opportunity",
                message: "You have a healthy savings rate. Consider diversifying into investment accounts for long-term growth.",
                type: .investmentAdvice,
                priority: .medium,
                actionItems: [
                    "Research index funds and ETFs",
                    "Open a brokerage account",
                    "Start with 10% of savings in low-risk investments"
                ],
                impactScore: 75
            )
        ]
    }

    // MARK: - Helper Methods

    /// Generates random transactions for testing
    static func generateRandomTransactions(count: Int) -> [Transaction] {
        var transactions: [Transaction] = []
        let calendar = Calendar.current
        let now = Date()

        let expenseCategories: [TransactionCategory] = [.food, .transport, .shopping, .entertainment, .bills, .health, .education, .travel]
        let incomeCategories: [TransactionCategory] = [.salary, .freelance, .investment, .gift]

        let expenseTitles = [
            "Grocery Shopping", "Coffee", "Gas", "Uber", "Restaurant",
            "Online Shopping", "Movie Tickets", "Internet Bill", "Gym",
            "Book Purchase", "Lunch", "Dinner", "Parking"
        ]

        let incomeTitles = [
            "Salary", "Freelance Project", "Side Hustle", "Gift Money",
            "Bonus", "Commission", "Dividends"
        ]

        for i in 0..<count {
            let isIncome = Bool.random()
            let type: TransactionType = isIncome ? .income : .expense

            let category = isIncome
                ? incomeCategories.randomElement()!
                : expenseCategories.randomElement()!

            let title = isIncome
                ? incomeTitles.randomElement()!
                : expenseTitles.randomElement()!

            let amount = isIncome
                ? Double.random(in: 50...5000)
                : Double.random(in: 5...500)

            let daysAgo = Int.random(in: 0...90)
            let date = calendar.date(byAdding: .day, value: -daysAgo, to: now)!

            transactions.append(Transaction(
                amount: amount,
                type: type,
                category: category,
                title: title,
                notes: "",
                date: date,
                isRecurring: Bool.random() && isIncome
            ))
        }

        return transactions.sorted { $0.date > $1.date }
    }

    /// Creates a mock financial summary
    static func mockSummary(period: TimePeriod) -> FinancialSummary {
        FinancialSummary(
            period: period,
            totalIncome: 4250.00,
            totalExpenses: 3180.50,
            balance: 1069.50,
            savingsRate: 25.2,
            categoryBreakdown: [
                .food: 450.80,
                .transport: 320.00,
                .shopping: 580.00,
                .entertainment: 250.00,
                .bills: 680.70,
                .health: 400.00,
                .education: 120.00,
                .travel: 379.00
            ],
            transactionCount: 47
        )
    }
}

// MARK: - Preview Helpers

#if DEBUG
extension ModelContainer {
    /// Creates an in-memory container with sample data for previews
    static var preview: ModelContainer {
        let schema = Schema([Transaction.self, FinancialInsight.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)

        let container = try! ModelContainer(for: schema, configurations: [configuration])

        // Add sample data
        for transaction in PreviewData.sampleTransactions {
            container.mainContext.insert(transaction)
        }

        for insight in PreviewData.sampleInsights {
            container.mainContext.insert(insight)
        }

        return container
    }
}
#endif
