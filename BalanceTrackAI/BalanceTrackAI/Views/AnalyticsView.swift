//
//  AnalyticsView.swift
//  BalanceTrackAI
//
//  Advanced analytics and visualizations
//

import SwiftUI
import Charts

struct AnalyticsView: View {
    let transactions: [Transaction]

    @State private var selectedPeriod: AnalyticsPeriod = .monthly
    @State private var showAnimation = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.appGradient
                    .opacity(0.2)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Period selector
                        AnalyticsPeriodSelector(selectedPeriod: $selectedPeriod)
                            .padding(.horizontal)

                        // Income vs Expenses Chart
                        IncomeExpenseChart(transactions: transactions, period: selectedPeriod)
                            .padding(.horizontal)

                        // Trend Chart
                        TrendLineChart(transactions: transactions, period: selectedPeriod)
                            .padding(.horizontal)

                        // Category Breakdown
                        CategoryPieChart(transactions: transactions)
                            .padding(.horizontal)

                        // Monthly Comparison
                        MonthlyComparisonChart(transactions: transactions)
                            .padding(.horizontal)

                        // Statistics Cards
                        StatisticsCardsView(transactions: transactions)
                            .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Analytics")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Analytics Period
enum AnalyticsPeriod: String, CaseIterable {
    case weekly = "Week"
    case monthly = "Month"
    case quarterly = "Quarter"
    case yearly = "Year"

    var days: Int {
        switch self {
        case .weekly: return 7
        case .monthly: return 30
        case .quarterly: return 90
        case .yearly: return 365
        }
    }
}

// MARK: - Period Selector
struct AnalyticsPeriodSelector: View {
    @Binding var selectedPeriod: AnalyticsPeriod

    var body: some View {
        HStack(spacing: 8) {
            ForEach(AnalyticsPeriod.allCases, id: \.self) { period in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedPeriod = period
                    }
                }) {
                    Text(period.rawValue)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(selectedPeriod == period ? .white : .secondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            selectedPeriod == period ?
                            LinearGradient.animeGradient :
                            LinearGradient(colors: [Color.white.opacity(0.1)], startPoint: .leading, endPoint: .trailing)
                        )
                        .clipShape(Capsule())
                }
            }
        }
        .liquidGlass(cornerRadius: 25, opacity: 0.1)
        .padding(4)
    }
}

// MARK: - Income vs Expense Chart
struct IncomeExpenseChart: View {
    let transactions: [Transaction]
    let period: AnalyticsPeriod

    private var chartData: [(date: Date, income: Double, expense: Double)] {
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -period.days, to: endDate) ?? endDate

        let periodTransactions = transactions.filter { $0.date >= startDate && $0.date <= endDate }

        // Group by day/week/month based on period
        let grouping: Calendar.Component = period == .yearly ? .month : .day
        let grouped = Dictionary(grouping: periodTransactions) { transaction -> Date in
            let components = calendar.dateComponents([.year, .month, .day], from: transaction.date)
            return calendar.date(from: components) ?? transaction.date
        }

        return grouped.map { date, trans in
            let income = trans.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
            let expense = trans.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
            return (date: date, income: income, expense: expense)
        }.sorted { $0.date < $1.date }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.bar.xaxis")
                    .foregroundColor(.animeAccent1)
                Text("Income vs Expenses")
                    .font(.headline)
                    .fontWeight(.bold)
            }

            if chartData.isEmpty {
                Text("No data for this period")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
            } else {
                Chart {
                    ForEach(chartData, id: \.date) { item in
                        BarMark(
                            x: .value("Date", item.date, unit: .day),
                            y: .value("Income", item.income)
                        )
                        .foregroundStyle(Color.incomeGreen.gradient)
                        .position(by: .value("Type", "Income"))

                        BarMark(
                            x: .value("Date", item.date, unit: .day),
                            y: .value("Expense", item.expense)
                        )
                        .foregroundStyle(Color.expenseRed.gradient)
                        .position(by: .value("Type", "Expense"))
                    }
                }
                .frame(height: 250)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: max(1, period.days / 7))) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: .dateTime.month().day())
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartLegend(position: .top)
            }
        }
        .padding()
        .animatedGlassCard(cornerRadius: 20)
    }
}

// MARK: - Trend Line Chart
struct TrendLineChart: View {
    let transactions: [Transaction]
    let period: AnalyticsPeriod

    private var balanceData: [(date: Date, balance: Double)] {
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -period.days, to: endDate) ?? endDate

        let periodTransactions = transactions.filter { $0.date >= startDate && $0.date <= endDate }
            .sorted { $0.date < $1.date }

        var runningBalance = 0.0
        var data: [(Date, Double)] = []

        for transaction in periodTransactions {
            if transaction.type == .income {
                runningBalance += transaction.amount
            } else {
                runningBalance -= transaction.amount
            }
            data.append((transaction.date, runningBalance))
        }

        return data
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "waveform.path.ecg")
                    .foregroundColor(.animeAccent2)
                Text("Balance Trend")
                    .font(.headline)
                    .fontWeight(.bold)
            }

            if balanceData.isEmpty {
                Text("No data for this period")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
            } else {
                Chart {
                    ForEach(balanceData, id: \.date) { item in
                        LineMark(
                            x: .value("Date", item.date),
                            y: .value("Balance", item.balance)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.animeAccent2, .animeAccent1],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))

                        AreaMark(
                            x: .value("Date", item.date),
                            y: .value("Balance", item.balance)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.animeAccent2.opacity(0.3), .animeAccent2.opacity(0.05)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                }
                .frame(height: 250)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: max(1, period.days / 7))) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: .dateTime.month().day())
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
            }
        }
        .padding()
        .animatedGlassCard(cornerRadius: 20)
    }
}

// MARK: - Category Pie Chart
struct CategoryPieChart: View {
    let transactions: [Transaction]

    private var categoryData: [(category: String, amount: Double, color: Color)] {
        let expenses = transactions.filter { $0.type == .expense }
        let grouped = Dictionary(grouping: expenses) { $0.category }

        let colors: [Color] = [.animeAccent1, .animeAccent2, .animeAccent3, .incomeGreen, .expenseRed, .gradientPurple, .gradientOrange]

        return grouped.map { category, trans in
            let total = trans.reduce(0) { $0 + $1.amount }
            let colorIndex = abs(category.hashValue) % colors.count
            return (category: category.rawValue, amount: total, color: colors[colorIndex])
        }.sorted { $0.amount > $1.amount }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.pie.fill")
                    .foregroundColor(.animeAccent3)
                Text("Spending by Category")
                    .font(.headline)
                    .fontWeight(.bold)
            }

            if categoryData.isEmpty {
                Text("No expense data available")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                Chart {
                    ForEach(categoryData, id: \.category) { item in
                        SectorMark(
                            angle: .value("Amount", item.amount),
                            innerRadius: .ratio(0.5),
                            angularInset: 2
                        )
                        .foregroundStyle(item.color.gradient)
                        .annotation(position: .overlay) {
                            if item.amount > categoryData.map({ $0.amount }).reduce(0, +) * 0.1 {
                                Text(item.category)
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .frame(height: 250)

                // Legend
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 8) {
                    ForEach(categoryData, id: \.category) { item in
                        HStack(spacing: 6) {
                            Circle()
                                .fill(item.color)
                                .frame(width: 10, height: 10)

                            Text(item.category)
                                .font(.caption)
                                .lineLimit(1)

                            Spacer()

                            Text("$\(item.amount, specifier: "%.0f")")
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
        }
        .padding()
        .animatedGlassCard(cornerRadius: 20)
    }
}

// MARK: - Monthly Comparison Chart
struct MonthlyComparisonChart: View {
    let transactions: [Transaction]

    private var monthlyData: [(month: String, income: Double, expense: Double)] {
        let calendar = Calendar.current
        let sixMonthsAgo = calendar.date(byAdding: .month, value: -6, to: Date()) ?? Date()

        let recentTransactions = transactions.filter { $0.date >= sixMonthsAgo }

        let grouped = Dictionary(grouping: recentTransactions) { transaction -> String in
            let components = calendar.dateComponents([.year, .month], from: transaction.date)
            let date = calendar.date(from: components) ?? transaction.date
            return date.formatted(.dateTime.month(.abbreviated))
        }

        return grouped.map { month, trans in
            let income = trans.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
            let expense = trans.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
            return (month: month, income: income, expense: expense)
        }.sorted { $0.month < $1.month }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.animeAccent1)
                Text("6-Month Comparison")
                    .font(.headline)
                    .fontWeight(.bold)
            }

            if monthlyData.isEmpty {
                Text("No data for comparison")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
            } else {
                Chart {
                    ForEach(monthlyData, id: \.month) { item in
                        BarMark(
                            x: .value("Month", item.month),
                            y: .value("Amount", item.income - item.expense)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: item.income - item.expense >= 0 ? [.incomeGreen, .incomeGreen.opacity(0.7)] : [.expenseRed, .expenseRed.opacity(0.7)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .cornerRadius(8)
                    }
                }
                .frame(height: 200)
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
            }
        }
        .padding()
        .animatedGlassCard(cornerRadius: 20)
    }
}

// MARK: - Statistics Cards
struct StatisticsCardsView: View {
    let transactions: [Transaction]

    private var averageDaily: Double {
        guard !transactions.isEmpty else { return 0 }
        let expenses = transactions.filter { $0.type == .expense }
        let total = expenses.reduce(0) { $0 + $1.amount }
        return total / Double(max(1, Calendar.current.dateComponents([.day], from: expenses.last?.date ?? Date(), to: Date()).day ?? 1))
    }

    private var largestExpense: Transaction? {
        transactions.filter { $0.type == .expense }.max(by: { $0.amount < $1.amount })
    }

    private var mostFrequentCategory: TransactionCategory? {
        let expenses = transactions.filter { $0.type == .expense }
        let grouped = Dictionary(grouping: expenses) { $0.category }
        return grouped.max(by: { $0.value.count < $1.value.count })?.key
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "chart.bar.doc.horizontal")
                    .foregroundColor(.animeAccent2)
                Text("Quick Statistics")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                SmallStatCard(
                    title: "Avg Daily",
                    value: "$\(averageDaily, specifier: "%.2f")",
                    icon: "calendar.day.timeline.left",
                    color: .animeAccent1
                )

                if let largest = largestExpense {
                    SmallStatCard(
                        title: "Largest",
                        value: "$\(largest.amount, specifier: "%.2f")",
                        icon: "arrow.up.right.circle.fill",
                        color: .expenseRed
                    )
                }

                if let category = mostFrequentCategory {
                    SmallStatCard(
                        title: "Top Category",
                        value: category.rawValue,
                        icon: category.icon,
                        color: .animeAccent3
                    )
                }

                SmallStatCard(
                    title: "Total Trans.",
                    value: "\(transactions.count)",
                    icon: "list.number",
                    color: .animeAccent2
                )
            }
        }
        .padding()
        .liquidGlass(cornerRadius: 20, opacity: 0.12)
    }
}

struct SmallStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .frostedGlass(cornerRadius: 12, tintColor: color)
    }
}

#Preview {
    AnalyticsView(transactions: [])
}
