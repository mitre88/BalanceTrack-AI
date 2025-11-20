//
//  ContentView.swift
//  BalanceTrackAI
//
//  Main navigation and content view
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
    @Query(sort: \FinancialInsight.dateGenerated, order: .reverse) private var insights: [FinancialInsight]

    @State private var selectedTab = 0
    @State private var showAddTransaction = false

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color.appBackground,
                    Color.appBackground.opacity(0.9),
                    Color.gradientPurple.opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Main content
            TabView(selection: $selectedTab) {
                DashboardView(transactions: transactions, insights: insights)
                    .tabItem {
                        Label("Dashboard", systemImage: "chart.line.uptrend.xyaxis")
                    }
                    .tag(0)

                TransactionsListView(transactions: transactions)
                    .tabItem {
                        Label("Transactions", systemImage: "list.bullet.rectangle")
                    }
                    .tag(1)

                InsightsView(insights: insights)
                    .tabItem {
                        Label("Insights", systemImage: "brain.head.profile")
                    }
                    .tag(2)

                AnalyticsView(transactions: transactions)
                    .tabItem {
                        Label("Analytics", systemImage: "chart.bar.fill")
                    }
                    .tag(3)
            }
            .accentColor(.animeAccent1)

            // Floating Add Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                            showAddTransaction.toggle()
                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 64, height: 64)
                            .background(
                                LinearGradient.animeGradient
                            )
                            .clipShape(Circle())
                            .shadow(color: Color.animeAccent1.opacity(0.5), radius: 15, x: 0, y: 8)
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 80)
                    .scaleEffect(showAddTransaction ? 0.9 : 1.0)
                    .rotationEffect(.degrees(showAddTransaction ? 45 : 0))
                }
            }
        }
        .sheet(isPresented: $showAddTransaction) {
            AddTransactionView(isPresented: $showAddTransaction)
                .environment(\.modelContext, modelContext)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Transaction.self, FinancialInsight.self], inMemory: true)
}
