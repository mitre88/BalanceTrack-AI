//
//  DashboardView.swift
//  BalanceTrackAI
//
//  Main dashboard with financial overview
//

import SwiftUI
import Charts

struct DashboardView: View {
    let transactions: [Transaction]
    let insights: [FinancialInsight]

    @State private var selectedPeriod: TimePeriod = .monthly
    @State private var showWelcomeAnimation = true

    private var summary: FinancialSummary {
        switch selectedPeriod {
        case .weekly:
            return AIFinancialAdvisor.shared.generateWeeklySummary(transactions: transactions)
        case .monthly:
            return AIFinancialAdvisor.shared.generateMonthlySummary(transactions: transactions)
        case .yearly:
            return AIFinancialAdvisor.shared.generateYearlySummary(transactions: transactions)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header with animated greeting
                    HeaderSection()
                        .opacity(showWelcomeAnimation ? 1 : 0)
                        .offset(y: showWelcomeAnimation ? 0 : -20)

                    // Period Selector
                    PeriodSelector(selectedPeriod: $selectedPeriod)
                        .padding(.horizontal)

                    // Balance Card
                    BalanceCard(summary: summary)
                        .padding(.horizontal)
                        .transition(.scaleAndFade)

                    // Quick Stats
                    QuickStatsView(summary: summary)
                        .padding(.horizontal)

                    // Recent Insights
                    if !insights.isEmpty {
                        RecentInsightsSection(insights: Array(insights.prefix(3)))
                            .padding(.horizontal)
                    }

                    // Spending by Category Chart
                    CategorySpendingChart(categoryBreakdown: summary.categoryBreakdown)
                        .padding(.horizontal)

                    // Recent Transactions
                    RecentTransactionsSection(transactions: Array(transactions.prefix(5)))
                        .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("BalanceTrack AI")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                showWelcomeAnimation = true
            }
        }
    }
}

// MARK: - Header Section
struct HeaderSection: View {
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 8) {
            Text("Financial Wellness")
                .font(.title3)
                .foregroundColor(.secondary)

            Text("Track • Analyze • Grow")
                .font(.caption)
                .foregroundStyle(LinearGradient.animeGradient)
                .fontWeight(.semibold)
        }
        .scaleEffect(isAnimating ? 1.0 : 0.9)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                isAnimating = true
            }
        }
    }
}

// MARK: - Period Selector
struct PeriodSelector: View {
    @Binding var selectedPeriod: TimePeriod

    var body: some View {
        HStack(spacing: 12) {
            ForEach([TimePeriod.weekly, .monthly, .yearly], id: \.self) { period in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedPeriod = period
                    }
                }) {
                    Text(period.rawValue)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(selectedPeriod == period ? .white : .secondary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            Group {
                                if selectedPeriod == period {
                                    LinearGradient.animeGradient
                                } else {
                                    LinearGradient(colors: [Color.white.opacity(0.1)], startPoint: .leading, endPoint: .trailing)
                                }
                            }
                        )
                        .clipShape(Capsule())
                }
            }
        }
        .liquidGlass(cornerRadius: 25, opacity: 0.1)
        .padding(4)
    }
}

// MARK: - Balance Card
struct BalanceCard: View {
    let summary: FinancialSummary
    @State private var animateBalance = false

    var body: some View {
        VStack(spacing: 16) {
            // Balance Amount
            VStack(spacing: 4) {
                Text("Current Balance")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("$\(summary.balance, specifier: "%.2f")")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: summary.balance >= 0 ? [.incomeGreen, .incomeGreen.opacity(0.7)] : [.expenseRed, .expenseRed.opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .scaleEffect(animateBalance ? 1.0 : 0.8)
            }

            Divider()
                .background(Color.white.opacity(0.2))

            // Income & Expenses
            HStack(spacing: 40) {
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(.incomeGreen)
                        Text("Income")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Text("$\(summary.totalIncome, specifier: "%.2f")")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.incomeGreen)
                }

                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(.expenseRed)
                        Text("Expenses")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Text("$\(summary.totalExpenses, specifier: "%.2f")")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.expenseRed)
                }
            }
        }
        .padding(24)
        .animatedGlassCard(cornerRadius: 28)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.2)) {
                animateBalance = true
            }
        }
    }
}

// MARK: - Quick Stats View
struct QuickStatsView: View {
    let summary: FinancialSummary

    var body: some View {
        HStack(spacing: 12) {
            StatCard(
                icon: "percent",
                title: "Savings Rate",
                value: "\(Int(summary.savingsRate))%",
                color: .incomeGreen
            )

            StatCard(
                icon: "chart.bar.fill",
                title: "Transactions",
                value: "\(summary.transactionCount)",
                color: .animeAccent2
            )
        }
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .liquidGlass(cornerRadius: 20, opacity: 0.12)
    }
}

// MARK: - Recent Insights Section
struct RecentInsightsSection: View {
    let insights: [FinancialInsight]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(.animeAccent1)
                Text("AI Insights")
                    .font(.headline)
                    .fontWeight(.bold)
            }

            ForEach(insights) { insight in
                InsightCard(insight: insight)
            }
        }
    }
}

struct InsightCard: View {
    let insight: FinancialInsight

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: insight.type.icon)
                .font(.title3)
                .foregroundColor(.animeAccent1)
                .frame(width: 40, height: 40)
                .background(Color.animeAccent1.opacity(0.2))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(insight.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text(insight.message)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding()
        .frostedGlass(cornerRadius: 16, tintColor: .animeAccent1)
    }
}

// MARK: - Category Spending Chart
struct CategorySpendingChart: View {
    let categoryBreakdown: [TransactionCategory: Double]

    private var chartData: [(category: String, amount: Double)] {
        categoryBreakdown
            .sorted { $0.value > $1.value }
            .prefix(5)
            .map { (category: $0.key.rawValue, amount: $0.value) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.pie.fill")
                    .foregroundColor(.animeAccent2)
                Text("Top Spending Categories")
                    .font(.headline)
                    .fontWeight(.bold)
            }

            if chartData.isEmpty {
                Text("No spending data yet")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                Chart {
                    ForEach(chartData, id: \.category) { item in
                        BarMark(
                            x: .value("Amount", item.amount),
                            y: .value("Category", item.category)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.animeAccent2, .animeAccent1],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(8)
                    }
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(position: .bottom)
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
            }
        }
        .padding()
        .liquidGlass(cornerRadius: 20, opacity: 0.12)
    }
}

// MARK: - Recent Transactions Section
struct RecentTransactionsSection: View {
    let transactions: [Transaction]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "clock.arrow.circlepath")
                    .foregroundColor(.animeAccent3)
                Text("Recent Transactions")
                    .font(.headline)
                    .fontWeight(.bold)
            }

            if transactions.isEmpty {
                Text("No transactions yet")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ForEach(transactions) { transaction in
                    TransactionRow(transaction: transaction)
                }
            }
        }
        .padding()
        .liquidGlass(cornerRadius: 20, opacity: 0.12)
    }
}

struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack {
            Image(systemName: transaction.category.icon)
                .font(.title3)
                .foregroundColor(transaction.type == .income ? .incomeGreen : .expenseRed)
                .frame(width: 40, height: 40)
                .background(
                    (transaction.type == .income ? Color.incomeGreen : Color.expenseRed).opacity(0.2)
                )
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.title)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Text(transaction.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text("\(transaction.type == .income ? "+" : "-")$\(transaction.amount, specifier: "%.2f")")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(transaction.type == .income ? .incomeGreen : .expenseRed)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    DashboardView(transactions: [], insights: [])
}
