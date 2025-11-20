//
//  ColorExtensions.swift
//  BalanceTrackAI
//
//  Custom color palette for the app
//

import SwiftUI

extension Color {
    // MARK: - Brand Colors
    static let brandPrimary = Color("BrandPrimary", bundle: nil)
    static let brandSecondary = Color("BrandSecondary", bundle: nil)

    // MARK: - Transaction Colors
    static let incomeGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let expenseRed = Color(red: 1.0, green: 0.3, blue: 0.3)

    // MARK: - Gradient Colors
    static let gradientPurple = Color(red: 0.5, green: 0.3, blue: 0.9)
    static let gradientBlue = Color(red: 0.2, green: 0.5, blue: 1.0)
    static let gradientPink = Color(red: 1.0, green: 0.3, blue: 0.6)
    static let gradientOrange = Color(red: 1.0, green: 0.5, blue: 0.2)

    // MARK: - Background Colors
    static let appBackground = Color(red: 0.05, green: 0.05, blue: 0.15)
    static let cardBackground = Color(white: 0.15, opacity: 0.6)

    // MARK: - Anime-Style Colors
    static let animeAccent1 = Color(red: 1.0, green: 0.4, blue: 0.7)
    static let animeAccent2 = Color(red: 0.4, green: 0.8, blue: 1.0)
    static let animeAccent3 = Color(red: 0.6, green: 1.0, blue: 0.4)
}

// MARK: - Gradient Presets
extension LinearGradient {
    static let incomeGradient = LinearGradient(
        colors: [Color.incomeGreen, Color.incomeGreen.opacity(0.7)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let expenseGradient = LinearGradient(
        colors: [Color.expenseRed, Color.expenseRed.opacity(0.7)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let appGradient = LinearGradient(
        colors: [Color.gradientPurple, Color.gradientBlue, Color.gradientPink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let animeGradient = LinearGradient(
        colors: [Color.animeAccent1, Color.animeAccent2, Color.animeAccent3],
        startPoint: .leading,
        endPoint: .trailing
    )
}
