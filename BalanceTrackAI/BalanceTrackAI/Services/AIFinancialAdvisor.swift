//
//  AIFinancialAdvisor.swift
//  BalanceTrackAI
//
//  Apple Intelligence integration for financial insights
//

import Foundation
import SwiftUI

@Observable
class AIFinancialAdvisor {
    static let shared = AIFinancialAdvisor()

    private init() {}

    // MARK: - AI Analysis Methods

    /// Analyzes transactions and generates personalized financial insights
    func generateInsights(from transactions: [Transaction]) async -> [FinancialInsight] {
        var insights: [FinancialInsight] = []

        // Calculate financial metrics
        let totalIncome = transactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
        let totalExpenses = transactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
        let balance = totalIncome - totalExpenses
        let savingsRate = totalIncome > 0 ? (balance / totalIncome) * 100 : 0

        // Analyze spending by category
        let categorySpending = analyzeCategorySpending(transactions)

        // Generate insights based on patterns
        insights.append(contentsOf: generateSavingsInsights(savingsRate: savingsRate, balance: balance))
        insights.append(contentsOf: generateSpendingInsights(categorySpending: categorySpending, totalIncome: totalIncome))
        insights.append(contentsOf: generateTrendInsights(transactions: transactions))

        return insights
    }

    /// Generates weekly financial summary
    func generateWeeklySummary(transactions: [Transaction]) -> FinancialSummary {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()

        let weekTransactions = transactions.filter { $0.date >= weekAgo }

        return generateSummary(from: weekTransactions, period: .weekly)
    }

    /// Generates monthly financial summary
    func generateMonthlySummary(transactions: [Transaction]) -> FinancialSummary {
        let calendar = Calendar.current
        let monthAgo = calendar.date(byAdding: .month, value: -1, to: Date()) ?? Date()

        let monthTransactions = transactions.filter { $0.date >= monthAgo }

        return generateSummary(from: monthTransactions, period: .monthly)
    }

    /// Generates yearly financial summary
    func generateYearlySummary(transactions: [Transaction]) -> FinancialSummary {
        let calendar = Calendar.current
        let yearAgo = calendar.date(byAdding: .year, value: -1, to: Date()) ?? Date()

        let yearTransactions = transactions.filter { $0.date >= yearAgo }

        return generateSummary(from: yearTransactions, period: .yearly)
    }

    // MARK: - Private Helper Methods

    private func generateSummary(from transactions: [Transaction], period: TimePeriod) -> FinancialSummary {
        let income = transactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
        let expenses = transactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
        let balance = income - expenses
        let savingsRate = income > 0 ? (balance / income) * 100 : 0

        let categoryBreakdown = analyzeCategorySpending(transactions)

        return FinancialSummary(
            period: period,
            totalIncome: income,
            totalExpenses: expenses,
            balance: balance,
            savingsRate: savingsRate,
            categoryBreakdown: categoryBreakdown,
            transactionCount: transactions.count
        )
    }

    private func analyzeCategorySpending(_ transactions: [Transaction]) -> [TransactionCategory: Double] {
        var categoryTotals: [TransactionCategory: Double] = [:]

        let expenses = transactions.filter { $0.type == .expense }

        for transaction in expenses {
            categoryTotals[transaction.category, default: 0] += transaction.amount
        }

        return categoryTotals
    }

    private func generateSavingsInsights(savingsRate: Double, balance: Double) -> [FinancialInsight] {
        var insights: [FinancialInsight] = []

        if savingsRate < 10 {
            insights.append(FinancialInsight(
                title: "Low Savings Rate Alert",
                message: "Your current savings rate is \(String(format: "%.1f", savingsRate))%. Financial experts recommend saving at least 20% of your income. Let's work on increasing your savings!",
                type: .spendingWarning,
                priority: .high,
                actionItems: [
                    "Review and reduce discretionary spending",
                    "Set up automatic savings transfers",
                    "Look for subscription services to cancel"
                ],
                impactScore: 85
            ))
        } else if savingsRate >= 20 {
            insights.append(FinancialInsight(
                title: "Excellent Savings Performance!",
                message: "Congratulations! You're saving \(String(format: "%.1f", savingsRate))% of your income. This is above the recommended 20% threshold. Keep up the great work!",
                type: .goalProgress,
                priority: .low,
                actionItems: [
                    "Consider investing surplus savings",
                    "Build emergency fund to 6 months expenses",
                    "Review long-term financial goals"
                ],
                impactScore: 95
            ))
        }

        if balance < 0 {
            insights.append(FinancialInsight(
                title: "Budget Deficit Detected",
                message: "Your expenses exceed your income by $\(String(format: "%.2f", abs(balance))). This is unsustainable and requires immediate attention.",
                type: .spendingWarning,
                priority: .urgent,
                actionItems: [
                    "Create a detailed budget plan",
                    "Identify and cut non-essential expenses",
                    "Explore additional income opportunities"
                ],
                impactScore: 100
            ))
        }

        return insights
    }

    private func generateSpendingInsights(categorySpending: [TransactionCategory: Double], totalIncome: Double) -> [FinancialInsight] {
        var insights: [FinancialInsight] = []

        // Find highest spending category
        if let highestCategory = categorySpending.max(by: { $0.value < $1.value }) {
            let percentage = totalIncome > 0 ? (highestCategory.value / totalIncome) * 100 : 0

            if percentage > 30 {
                insights.append(FinancialInsight(
                    title: "High Spending in \(highestCategory.key.rawValue)",
                    message: "You're spending \(String(format: "%.1f", percentage))% of your income on \(highestCategory.key.rawValue.lowercased()). This category is consuming a large portion of your budget.",
                    type: .budgetTip,
                    priority: .medium,
                    actionItems: [
                        "Set a budget limit for \(highestCategory.key.rawValue)",
                        "Look for cost-effective alternatives",
                        "Track daily spending in this category"
                    ],
                    impactScore: 70
                ))
            }
        }

        return insights
    }

    private func generateTrendInsights(transactions: [Transaction]) -> [FinancialInsight] {
        var insights: [FinancialInsight] = []

        // Analyze recent trend (last 30 days vs previous 30 days)
        let calendar = Calendar.current
        let now = Date()
        let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: now) ?? now
        let sixtyDaysAgo = calendar.date(byAdding: .day, value: -60, to: now) ?? now

        let recentExpenses = transactions.filter { $0.type == .expense && $0.date >= thirtyDaysAgo }.reduce(0) { $0 + $1.amount }
        let previousExpenses = transactions.filter { $0.type == .expense && $0.date >= sixtyDaysAgo && $0.date < thirtyDaysAgo }.reduce(0) { $0 + $1.amount }

        if previousExpenses > 0 {
            let changePercentage = ((recentExpenses - previousExpenses) / previousExpenses) * 100

            if changePercentage > 15 {
                insights.append(FinancialInsight(
                    title: "Spending Increasing",
                    message: "Your spending has increased by \(String(format: "%.1f", changePercentage))% compared to last month. Let's identify what's causing this increase.",
                    type: .trend,
                    priority: .medium,
                    actionItems: [
                        "Review recent large purchases",
                        "Compare category spending month-over-month",
                        "Adjust budget if needed"
                    ],
                    impactScore: 75
                ))
            } else if changePercentage < -15 {
                insights.append(FinancialInsight(
                    title: "Great Progress on Spending!",
                    message: "You've reduced spending by \(String(format: "%.1f", abs(changePercentage)))% compared to last month. Excellent work!",
                    type: .trend,
                    priority: .low,
                    actionItems: [
                        "Identify what strategies worked",
                        "Continue successful habits",
                        "Redirect savings to financial goals"
                    ],
                    impactScore: 90
                ))
            }
        }

        return insights
    }
}

// MARK: - Supporting Types

enum TimePeriod: String {
    case weekly = "Week"
    case monthly = "Month"
    case yearly = "Year"
}

struct FinancialSummary {
    let period: TimePeriod
    let totalIncome: Double
    let totalExpenses: Double
    let balance: Double
    let savingsRate: Double
    let categoryBreakdown: [TransactionCategory: Double]
    let transactionCount: Int

    var topSpendingCategory: (category: TransactionCategory, amount: Double)? {
        categoryBreakdown.max(by: { $0.value < $1.value }).map { ($0.key, $0.value) }
    }
}
