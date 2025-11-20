//
//  Transaction.swift
//  BalanceTrackAI
//
//  Data model for financial transactions
//

import Foundation
import SwiftData

@Model
final class Transaction {
    var id: UUID
    var amount: Double
    var type: TransactionType
    var category: TransactionCategory
    var title: String
    var notes: String
    var date: Date
    var isRecurring: Bool
    var recurringFrequency: RecurringFrequency?

    init(
        id: UUID = UUID(),
        amount: Double,
        type: TransactionType,
        category: TransactionCategory,
        title: String,
        notes: String = "",
        date: Date = Date(),
        isRecurring: Bool = false,
        recurringFrequency: RecurringFrequency? = nil
    ) {
        self.id = id
        self.amount = amount
        self.type = type
        self.category = category
        self.title = title
        self.notes = notes
        self.date = date
        self.isRecurring = isRecurring
        self.recurringFrequency = recurringFrequency
    }
}

enum TransactionType: String, Codable, CaseIterable {
    case income = "Income"
    case expense = "Expense"

    var icon: String {
        switch self {
        case .income: return "arrow.down.circle.fill"
        case .expense: return "arrow.up.circle.fill"
        }
    }

    var color: String {
        switch self {
        case .income: return "incomeGreen"
        case .expense: return "expenseRed"
        }
    }
}

enum TransactionCategory: String, Codable, CaseIterable {
    // Income categories
    case salary = "Salary"
    case freelance = "Freelance"
    case investment = "Investment"
    case gift = "Gift"
    case other = "Other"

    // Expense categories
    case food = "Food"
    case transport = "Transport"
    case shopping = "Shopping"
    case entertainment = "Entertainment"
    case bills = "Bills"
    case health = "Health"
    case education = "Education"
    case travel = "Travel"

    var icon: String {
        switch self {
        case .salary: return "dollarsign.circle.fill"
        case .freelance: return "laptopcomputer"
        case .investment: return "chart.line.uptrend.xyaxis"
        case .gift: return "gift.fill"
        case .food: return "fork.knife"
        case .transport: return "car.fill"
        case .shopping: return "cart.fill"
        case .entertainment: return "tv.fill"
        case .bills: return "doc.text.fill"
        case .health: return "heart.fill"
        case .education: return "book.fill"
        case .travel: return "airplane"
        case .other: return "ellipsis.circle.fill"
        }
    }
}

enum RecurringFrequency: String, Codable, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"
}
