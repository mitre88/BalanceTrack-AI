//
//  LiquidGlassModifier.swift
//  BalanceTrackAI
//
//  Liquid glass effect modifiers inspired by modern iOS design
//

import SwiftUI

// MARK: - Liquid Glass Modifier
struct LiquidGlassModifier: ViewModifier {
    var cornerRadius: CGFloat = 20
    var opacity: Double = 0.15

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // Gradient background
                    LinearGradient(
                        colors: [
                            Color.white.opacity(opacity),
                            Color.white.opacity(opacity * 0.5)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    // Glass effect
                    Color.white.opacity(0.05)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.6),
                                Color.white.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Animated Glass Card Modifier
struct AnimatedGlassCard: ViewModifier {
    @State private var isAnimating = false
    var cornerRadius: CGFloat = 24

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // Animated gradient
                    LinearGradient(
                        colors: [
                            Color.blue.opacity(0.15),
                            Color.purple.opacity(0.15),
                            Color.pink.opacity(0.15)
                        ],
                        startPoint: isAnimating ? .topLeading : .bottomLeading,
                        endPoint: isAnimating ? .bottomTrailing : .topTrailing
                    )
                    .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: isAnimating)

                    // Glass layer
                    Color.white.opacity(0.08)
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.7),
                                Color.white.opacity(0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
            .onAppear {
                isAnimating = true
            }
    }
}

// MARK: - Frosted Glass Modifier
struct FrostedGlass: ViewModifier {
    var cornerRadius: CGFloat = 16
    var tintColor: Color = .white

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    tintColor.opacity(0.1)

                    Color.white.opacity(0.05)
                }
                .blur(radius: 8)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Sketch Style Modifier (Pencil Drawing Effect)
struct SketchStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: 2,
                            lineCap: .round,
                            lineJoin: .round,
                            dash: [0.5, 0.5]
                        )
                    )
                    .foregroundColor(.primary.opacity(0.3))
            )
    }
}

// MARK: - View Extensions
extension View {
    func liquidGlass(cornerRadius: CGFloat = 20, opacity: Double = 0.15) -> some View {
        self.modifier(LiquidGlassModifier(cornerRadius: cornerRadius, opacity: opacity))
    }

    func animatedGlassCard(cornerRadius: CGFloat = 24) -> some View {
        self.modifier(AnimatedGlassCard(cornerRadius: cornerRadius))
    }

    func frostedGlass(cornerRadius: CGFloat = 16, tintColor: Color = .white) -> some View {
        self.modifier(FrostedGlass(cornerRadius: cornerRadius, tintColor: tintColor))
    }

    func sketchStyle() -> some View {
        self.modifier(SketchStyle())
    }
}

// MARK: - Anime-Style Transition Extensions
extension AnyTransition {
    static var slideAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
    }

    static var scaleAndFade: AnyTransition {
        .scale(scale: 0.8).combined(with: .opacity)
    }

    static var bounceIn: AnyTransition {
        .modifier(
            active: BounceModifier(scale: 0.5),
            identity: BounceModifier(scale: 1.0)
        )
    }
}

struct BounceModifier: ViewModifier {
    let scale: CGFloat

    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .opacity(scale > 0.7 ? 1 : 0)
    }
}
