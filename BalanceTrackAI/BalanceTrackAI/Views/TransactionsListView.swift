//
//  TransactionsListView.swift
//  BalanceTrackAI
//
//  Complete list of all transactions
//

import SwiftUI

struct TransactionsListView: View {
    let transactions: [Transaction]

    @State private var searchText = ""
    @State private var filterType: TransactionType?
    @State private var showAnimation = false

    private var filteredTransactions: [Transaction] {
        var filtered = transactions

        if !searchText.isEmpty {
            filtered = filtered.filter { transaction in
                transaction.title.localizedCaseInsensitiveContains(searchText) ||
                transaction.category.rawValue.localizedCaseInsensitiveContains(searchText) ||
                transaction.notes.localizedCaseInsensitiveContains(searchText)
            }
        }

        if let filterType = filterType {
            filtered = filtered.filter { $0.type == filterType }
        }

        return filtered
    }

    private var groupedTransactions: [(String, [Transaction])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredTransactions) { transaction -> String in
            let components = calendar.dateComponents([.year, .month, .day], from: transaction.date)
            let date = calendar.date(from: components) ?? transaction.date
            return date.formatted(date: .abbreviated, time: .omitted)
        }

        return grouped.sorted { $0.key > $1.key }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.appGradient
                    .opacity(0.2)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)

                        TextField("Search transactions...", text: $searchText)

                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .liquidGlass(cornerRadius: 16, opacity: 0.15)
                    .padding(.horizontal)

                    // Filter buttons
                    HStack(spacing: 12) {
                        FilterButton(title: "All", isSelected: filterType == nil) {
                            withAnimation { filterType = nil }
                        }

                        FilterButton(title: "Income", isSelected: filterType == .income) {
                            withAnimation { filterType = .income }
                        }

                        FilterButton(title: "Expenses", isSelected: filterType == .expense) {
                            withAnimation { filterType = .expense }
                        }

                        Spacer()
                    }
                    .padding(.horizontal)

                    // Transactions list
                    if filteredTransactions.isEmpty {
                        VStack(spacing: 16) {
                            Spacer()

                            Image(systemName: "tray")
                                .font(.system(size: 60))
                                .foregroundColor(.secondary.opacity(0.5))

                            Text("No transactions found")
                                .font(.title3)
                                .foregroundColor(.secondary)

                            Text("Add your first transaction to get started")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Spacer()
                        }
                    } else {
                        List {
                            ForEach(groupedTransactions, id: \.0) { date, transactions in
                                Section(header: Text(date).font(.headline).foregroundColor(.animeAccent1)) {
                                    ForEach(transactions) { transaction in
                                        TransactionDetailRow(transaction: transaction)
                                            .listRowBackground(Color.clear)
                                    }
                                }
                                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationTitle("Transactions")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
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
                    LinearGradient.animeGradient :
                    LinearGradient(colors: [Color.white.opacity(0.1)], startPoint: .leading, endPoint: .trailing)
                )
                .clipShape(Capsule())
        }
    }
}

struct TransactionDetailRow: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(
                        (transaction.type == .income ? Color.incomeGreen : Color.expenseRed).opacity(0.2)
                    )
                    .frame(width: 50, height: 50)

                Image(systemName: transaction.category.icon)
                    .font(.title3)
                    .foregroundColor(transaction.type == .income ? .incomeGreen : .expenseRed)
            }

            // Transaction details
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.headline)
                    .fontWeight(.semibold)

                HStack(spacing: 8) {
                    Text(transaction.category.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    if transaction.isRecurring {
                        HStack(spacing: 2) {
                            Image(systemName: "repeat")
                            Text(transaction.recurringFrequency?.rawValue ?? "")
                        }
                        .font(.caption)
                        .foregroundColor(.animeAccent2)
                    }
                }

                if !transaction.notes.isEmpty {
                    Text(transaction.notes)
                        .font(.caption)
                        .foregroundColor(.secondary.opacity(0.8))
                        .lineLimit(1)
                }
            }

            Spacer()

            // Amount
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(transaction.type == .income ? "+" : "-")$\(transaction.amount, specifier: "%.2f")")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(transaction.type == .income ? .incomeGreen : .expenseRed)

                Text(transaction.date.formatted(date: .omitted, time: .shortened))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .liquidGlass(cornerRadius: 16, opacity: 0.12)
    }
}

#Preview {
    TransactionsListView(transactions: [])
}
