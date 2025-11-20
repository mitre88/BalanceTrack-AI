//
//  FinancialInsight.swift
//  BalanceTrackAI
//
//  AI-generated financial insights model
//

import Foundation
import SwiftData

@Model
final class FinancialInsight {
    var id: UUID
    var title: String
    var message: String
    var type: InsightType
    var priority: InsightPriority
    var dateGenerated: Date
    var isRead: Bool
    var actionItems: [String]
    var impactScore: Double // 0-100

    init(
        id: UUID = UUID(),
        title: String,
        message: String,
        type: InsightType,
        priority: InsightPriority,
        dateGenerated: Date = Date(),
        isRead: Bool = false,
        actionItems: [String] = [],
        impactScore: Double = 50.0
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.type = type
        self.priority = priority
        self.dateGenerated = dateGenerated
        self.isRead = isRead
        self.actionItems = actionItems
        self.impactScore = impactScore
    }
}

enum InsightType: String, Codable, CaseIterable {
    case savingOpportunity = "Saving Opportunity"
    case spendingWarning = "Spending Warning"
    case budgetTip = "Budget Tip"
    case investmentAdvice = "Investment Advice"
    case goalProgress = "Goal Progress"
    case trend = "Trend Analysis"

    var icon: String {
        switch self {
        case .savingOpportunity: return "piggybank.fill"
        case .spendingWarning: return "exclamationmark.triangle.fill"
        case .budgetTip: return "lightbulb.fill"
        case .investmentAdvice: return "chart.bar.fill"
        case .goalProgress: return "flag.fill"
        case .trend: return "waveform.path.ecg"
        }
    }
}

enum InsightPriority: String, Codable, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case urgent = "Urgent"

    var color: String {
        switch self {
        case .low: return "gray"
        case .medium: return "yellow"
        case .high: return "orange"
        case .urgent: return "red"
        }
    }
}
