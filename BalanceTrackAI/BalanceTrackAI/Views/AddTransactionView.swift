//
//  AddTransactionView.swift
//  BalanceTrackAI
//
//  View for adding new transactions
//

import SwiftUI
import SwiftData

struct AddTransactionView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool

    @State private var amount: String = ""
    @State private var selectedType: TransactionType = .expense
    @State private var selectedCategory: TransactionCategory = .food
    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var date: Date = Date()
    @State private var isRecurring: Bool = false
    @State private var recurringFrequency: RecurringFrequency = .monthly

    @State private var showAnimation = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient.appGradient
                    .opacity(0.3)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Amount Input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Amount")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            HStack {
                                Text("$")
                                    .font(.title)
                                    .foregroundColor(.primary)

                                TextField("0.00", text: $amount)
                                    .font(.system(size: 48, weight: .bold, design: .rounded))
                                    .keyboardType(.decimalPad)
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: selectedType == .income ? [.incomeGreen] : [.expenseRed],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            }
                        }
                        .padding()
                        .liquidGlass(cornerRadius: 20, opacity: 0.15)
                        .scaleEffect(showAnimation ? 1 : 0.9)

                        // Type Selector
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Type")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            HStack(spacing: 12) {
                                ForEach(TransactionType.allCases, id: \.self) { type in
                                    Button(action: {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            selectedType = type
                                            // Update default category based on type
                                            if type == .income {
                                                selectedCategory = .salary
                                            } else {
                                                selectedCategory = .food
                                            }
                                        }
                                    }) {
                                        HStack {
                                            Image(systemName: type.icon)
                                            Text(type.rawValue)
                                                .fontWeight(.semibold)
                                        }
                                        .foregroundColor(selectedType == type ? .white : .secondary)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            selectedType == type ?
                                            (type == .income ? LinearGradient.incomeGradient : LinearGradient.expenseGradient) :
                                            LinearGradient(colors: [Color.white.opacity(0.1)], startPoint: .leading, endPoint: .trailing)
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                    }
                                }
                            }
                        }
                        .padding()
                        .liquidGlass(cornerRadius: 20, opacity: 0.15)
                        .opacity(showAnimation ? 1 : 0)

                        // Category Selector
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 12) {
                                ForEach(relevantCategories, id: \.self) { category in
                                    Button(action: {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            selectedCategory = category
                                        }
                                    }) {
                                        VStack(spacing: 6) {
                                            Image(systemName: category.icon)
                                                .font(.title3)
                                            Text(category.rawValue)
                                                .font(.caption)
                                                .lineLimit(1)
                                        }
                                        .foregroundColor(selectedCategory == category ? .white : .secondary)
                                        .padding(.vertical, 12)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            selectedCategory == category ?
                                            LinearGradient.animeGradient :
                                            LinearGradient(colors: [Color.white.opacity(0.08)], startPoint: .leading, endPoint: .trailing)
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                }
                            }
                        }
                        .padding()
                        .liquidGlass(cornerRadius: 20, opacity: 0.15)
                        .opacity(showAnimation ? 1 : 0)

                        // Title & Notes
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Title")
                                    .font(.headline)
                                    .foregroundColor(.secondary)

                                TextField("e.g., Grocery shopping", text: $title)
                                    .padding()
                                    .background(Color.white.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notes (Optional)")
                                    .font(.headline)
                                    .foregroundColor(.secondary)

                                TextField("Add details...", text: $notes, axis: .vertical)
                                    .lineLimit(3...6)
                                    .padding()
                                    .background(Color.white.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        .padding()
                        .liquidGlass(cornerRadius: 20, opacity: 0.15)
                        .opacity(showAnimation ? 1 : 0)

                        // Date & Recurring
                        VStack(alignment: .leading, spacing: 16) {
                            DatePicker("Date", selection: $date, displayedComponents: [.date])
                                .accentColor(.animeAccent1)

                            Toggle("Recurring Transaction", isOn: $isRecurring)
                                .tint(.animeAccent1)

                            if isRecurring {
                                Picker("Frequency", selection: $recurringFrequency) {
                                    ForEach(RecurringFrequency.allCases, id: \.self) { frequency in
                                        Text(frequency.rawValue).tag(frequency)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                        }
                        .padding()
                        .liquidGlass(cornerRadius: 20, opacity: 0.15)
                        .opacity(showAnimation ? 1 : 0)

                        // Save Button
                        Button(action: saveTransaction) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title3)
                                Text("Save Transaction")
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient.animeGradient)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .animeAccent1.opacity(0.4), radius: 12, x: 0, y: 6)
                        }
                        .padding(.horizontal)
                        .disabled(amount.isEmpty || title.isEmpty)
                        .opacity(amount.isEmpty || title.isEmpty ? 0.5 : 1.0)
                        .scaleEffect(showAnimation ? 1 : 0.9)
                    }
                    .padding()
                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            isPresented = false
                        }
                    }
                    .foregroundColor(.animeAccent1)
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
                    showAnimation = true
                }
            }
        }
    }

    private var relevantCategories: [TransactionCategory] {
        if selectedType == .income {
            return [.salary, .freelance, .investment, .gift, .other]
        } else {
            return [.food, .transport, .shopping, .entertainment, .bills, .health, .education, .travel, .other]
        }
    }

    private func saveTransaction() {
        guard let amountValue = Double(amount), !title.isEmpty else { return }

        let newTransaction = Transaction(
            amount: amountValue,
            type: selectedType,
            category: selectedCategory,
            title: title,
            notes: notes,
            date: date,
            isRecurring: isRecurring,
            recurringFrequency: isRecurring ? recurringFrequency : nil
        )

        modelContext.insert(newTransaction)

        // Generate insights after adding transaction
        Task {
            let allTransactions = try? modelContext.fetch(FetchDescriptor<Transaction>())
            if let transactions = allTransactions {
                let newInsights = await AIFinancialAdvisor.shared.generateInsights(from: transactions)
                for insight in newInsights {
                    modelContext.insert(insight)
                }
            }
        }

        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            isPresented = false
        }
    }
}

#Preview {
    AddTransactionView(isPresented: .constant(true))
        .modelContainer(for: [Transaction.self], inMemory: true)
}
