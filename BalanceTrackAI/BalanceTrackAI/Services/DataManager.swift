//
//  DataManager.swift
//  BalanceTrackAI
//
//  Manages data operations and bulk actions
//

import Foundation
import SwiftData

/// Manages data operations for the app
@Observable
class DataManager {
    static let shared = DataManager()

    private init() {}

    // MARK: - Sample Data

    /// Populates the database with sample data for testing
    func loadSampleData(context: ModelContext) {
        // Clear existing data
        clearAllData(context: context)

        // Add sample transactions
        for transaction in PreviewData.sampleTransactions {
            context.insert(transaction)
        }

        // Add sample insights
        for insight in PreviewData.sampleInsights {
            context.insert(insight)
        }

        try? context.save()
    }

    /// Generates random data for stress testing
    func generateRandomData(context: ModelContext, transactionCount: Int = 100) {
        let transactions = PreviewData.generateRandomTransactions(count: transactionCount)

        for transaction in transactions {
            context.insert(transaction)
        }

        // Generate insights based on transactions
        Task {
            let insights = await AIFinancialAdvisor.shared.generateInsights(from: transactions)
            for insight in insights {
                context.insert(insight)
            }
        }

        try? context.save()
    }

    // MARK: - Data Export

    /// Exports all transactions to CSV format
    func exportToCSV(transactions: [Transaction]) -> String {
        var csv = "Date,Type,Category,Title,Amount,Notes,Recurring\n"

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        for transaction in transactions.sorted(by: { $0.date > $1.date }) {
            let date = formatter.string(from: transaction.date)
            let type = transaction.type.rawValue
            let category = transaction.category.rawValue
            let title = transaction.title.replacingOccurrences(of: ",", with: ";")
            let amount = String(format: "%.2f", transaction.amount)
            let notes = transaction.notes.replacingOccurrences(of: ",", with: ";")
            let recurring = transaction.isRecurring ? "Yes" : "No"

            csv += "\(date),\(type),\(category),\(title),\(amount),\(notes),\(recurring)\n"
        }

        return csv
    }

    /// Exports financial summary to JSON
    func exportSummaryToJSON(summary: FinancialSummary) -> String? {
        let summaryDict: [String: Any] = [
            "period": summary.period.rawValue,
            "totalIncome": summary.totalIncome,
            "totalExpenses": summary.totalExpenses,
            "balance": summary.balance,
            "savingsRate": summary.savingsRate,
            "transactionCount": summary.transactionCount,
            "categoryBreakdown": summary.categoryBreakdown.mapKeys { $0.rawValue }
        ]

        if let jsonData = try? JSONSerialization.data(withJSONObject: summaryDict, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }

        return nil
    }

    // MARK: - Data Management

    /// Clears all data from the database
    func clearAllData(context: ModelContext) {
        // Delete all transactions
        let transactionDescriptor = FetchDescriptor<Transaction>()
        if let transactions = try? context.fetch(transactionDescriptor) {
            for transaction in transactions {
                context.delete(transaction)
            }
        }

        // Delete all insights
        let insightDescriptor = FetchDescriptor<FinancialInsight>()
        if let insights = try? context.fetch(insightDescriptor) {
            for insight in insights {
                context.delete(insight)
            }
        }

        try? context.save()
    }

    /// Deletes old transactions beyond a certain date
    func deleteOldTransactions(context: ModelContext, olderThan days: Int) {
        let calendar = Calendar.current
        guard let cutoffDate = calendar.date(byAdding: .day, value: -days, to: Date()) else { return }

        let descriptor = FetchDescriptor<Transaction>()
        if let transactions = try? context.fetch(descriptor) {
            let oldTransactions = transactions.filter { $0.date < cutoffDate }

            for transaction in oldTransactions {
                context.delete(transaction)
            }

            try? context.save()
        }
    }

    // MARK: - Statistics

    /// Calculates comprehensive statistics
    func calculateStatistics(transactions: [Transaction]) -> Statistics {
        let income = transactions.filter { $0.type == .income }
        let expenses = transactions.filter { $0.type == .expense }

        let totalIncome = income.reduce(0) { $0 + $1.amount }
        let totalExpenses = expenses.reduce(0) { $0 + $1.amount }

        let avgIncome = income.isEmpty ? 0 : totalIncome / Double(income.count)
        let avgExpense = expenses.isEmpty ? 0 : totalExpenses / Double(expenses.count)

        let largestIncome = income.max(by: { $0.amount < $1.amount })
        let largestExpense = expenses.max(by: { $0.amount < $1.amount })

        let categoryTotals = Dictionary(grouping: expenses) { $0.category }
            .mapValues { $0.reduce(0) { $0 + $1.amount } }

        let topCategory = categoryTotals.max(by: { $0.value < $1.value })

        return Statistics(
            totalIncome: totalIncome,
            totalExpenses: totalExpenses,
            balance: totalIncome - totalExpenses,
            averageIncome: avgIncome,
            averageExpense: avgExpense,
            largestIncome: largestIncome,
            largestExpense: largestExpense,
            topSpendingCategory: topCategory?.key,
            transactionCount: transactions.count
        )
    }
}

// MARK: - Supporting Types

struct Statistics {
    let totalIncome: Double
    let totalExpenses: Double
    let balance: Double
    let averageIncome: Double
    let averageExpense: Double
    let largestIncome: Transaction?
    let largestExpense: Transaction?
    let topSpendingCategory: TransactionCategory?
    let transactionCount: Int
}

// MARK: - Dictionary Extension

extension Dictionary {
    func mapKeys<T: Hashable>(_ transform: (Key) -> T) -> [T: Value] {
        var result: [T: Value] = [:]
        for (key, value) in self {
            result[transform(key)] = value
        }
        return result
    }
}
