//
//  InsightsView.swift
//  BalanceTrackAI
//
//  AI-powered financial insights and recommendations
//

import SwiftUI

struct InsightsView: View {
    let insights: [FinancialInsight]

    @State private var selectedPriority: InsightPriority?
    @State private var showAnimation = false

    private var filteredInsights: [FinancialInsight] {
        if let priority = selectedPriority {
            return insights.filter { $0.priority == priority }
        }
        return insights
    }

    private var unreadInsightsCount: Int {
        insights.filter { !$0.isRead }.count
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.appGradient
                    .opacity(0.2)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    // Header card
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("AI Financial Insights")
                                .font(.title3)
                                .fontWeight(.bold)

                            Text("\(unreadInsightsCount) new insights")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 40))
                            .foregroundStyle(LinearGradient.animeGradient)
                    }
                    .padding()
                    .liquidGlass(cornerRadius: 20, opacity: 0.15)
                    .padding(.horizontal)
                    .scaleEffect(showAnimation ? 1 : 0.9)
                    .opacity(showAnimation ? 1 : 0)

                    // Priority filters
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            PriorityFilterButton(title: "All", isSelected: selectedPriority == nil) {
                                withAnimation { selectedPriority = nil }
                            }

                            ForEach(InsightPriority.allCases, id: \.self) { priority in
                                PriorityFilterButton(
                                    title: priority.rawValue,
                                    isSelected: selectedPriority == priority,
                                    color: priorityColor(for: priority)
                                ) {
                                    withAnimation { selectedPriority = priority }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Insights list
                    if filteredInsights.isEmpty {
                        VStack(spacing: 16) {
                            Spacer()

                            Image(systemName: "sparkles")
                                .font(.system(size: 60))
                                .foregroundStyle(LinearGradient.animeGradient)

                            Text("No insights yet")
                                .font(.title3)
                                .foregroundColor(.secondary)

                            Text("Add transactions to receive personalized financial advice")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(filteredInsights) { insight in
                                    DetailedInsightCard(insight: insight)
                                        .transition(.scaleAndFade)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Insights")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
                    showAnimation = true
                }
            }
        }
    }

    private func priorityColor(for priority: InsightPriority) -> Color {
        switch priority {
        case .low: return .gray
        case .medium: return .yellow
        case .high: return .orange
        case .urgent: return .red
        }
    }
}

struct PriorityFilterButton: View {
    let title: String
    let isSelected: Bool
    var color: Color = .animeAccent1
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .white : .secondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ?
                    LinearGradient(colors: [color, color.opacity(0.7)], startPoint: .leading, endPoint: .trailing) :
                    LinearGradient(colors: [Color.white.opacity(0.1)], startPoint: .leading, endPoint: .trailing)
                )
                .clipShape(Capsule())
        }
    }
}

struct DetailedInsightCard: View {
    let insight: FinancialInsight
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(priorityColor.opacity(0.2))
                        .frame(width: 50, height: 50)

                    Image(systemName: insight.type.icon)
                        .font(.title3)
                        .foregroundColor(priorityColor)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(insight.title)
                        .font(.headline)
                        .fontWeight(.bold)

                    HStack(spacing: 8) {
                        Label(insight.priority.rawValue, systemImage: "flag.fill")
                            .font(.caption)
                            .foregroundColor(priorityColor)

                        Text(insight.type.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                        .font(.title3)
                        .foregroundColor(.animeAccent1)
                }
            }

            // Message
            Text(insight.message)
                .font(.subheadline)
                .foregroundColor(.primary)
                .lineLimit(isExpanded ? nil : 3)

            // Impact score
            HStack {
                Text("Impact Score")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                Text("\(Int(insight.impactScore))/100")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.animeAccent2)
            }

            ProgressView(value: insight.impactScore, total: 100)
                .tint(.animeAccent2)

            // Action items (expanded)
            if isExpanded && !insight.actionItems.isEmpty {
                Divider()
                    .background(Color.white.opacity(0.2))

                VStack(alignment: .leading, spacing: 8) {
                    Text("Action Items")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.animeAccent1)

                    ForEach(insight.actionItems, id: \.self) { item in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.animeAccent3)
                                .font(.caption)

                            Text(item)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }

            // Date
            HStack {
                Spacer()
                Text(insight.dateGenerated.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption2)
                    .foregroundColor(.secondary.opacity(0.6))
            }
        }
        .padding()
        .animatedGlassCard(cornerRadius: 20)
    }

    private var priorityColor: Color {
        switch insight.priority {
        case .low: return .gray
        case .medium: return .yellow
        case .high: return .orange
        case .urgent: return .red
        }
    }
}

#Preview {
    InsightsView(insights: [
        FinancialInsight(
            title: "High Spending Alert",
            message: "Your entertainment spending has increased by 40% this month",
            type: .spendingWarning,
            priority: .high,
            actionItems: ["Review subscription services", "Set entertainment budget limit"],
            impactScore: 75
        )
    ])
}
