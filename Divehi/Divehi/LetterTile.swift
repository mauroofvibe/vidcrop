import SwiftUI

struct LetterTile: View {
    let letter: Letter
    let pressed: Bool
    let progress: Double
    let size: CGSize

    private let accent = Color(red: 0.11, green: 0.69, blue: 0.965)
    private let edge = Color(white: 0.89)
    private let label = Color(white: 0.66)

    var body: some View {
        let depth = max(4, size.height * 0.04)
        let radius = size.height * 0.12
        let faceHeight = size.height - depth

        ZStack(alignment: .top) {
            // The "3D" bottom edge, Duolingo style.
            RoundedRectangle(cornerRadius: radius)
                .fill(pressed ? accent.opacity(0.6) : edge)

            VStack(spacing: faceHeight * 0.03) {
                Text(letter.glyph)
                    .font(.system(size: faceHeight * 0.36, weight: .medium))
                    .foregroundStyle(pressed ? accent : Color(white: 0.2))
                Text(letter.sound)
                    .font(.system(size: faceHeight * 0.13, weight: .regular, design: .rounded))
                    .foregroundStyle(pressed ? accent : label)
                ProgressBar(value: progress)
                    .frame(height: max(6, faceHeight * 0.06))
                    .padding(.horizontal, size.width * 0.11)
                    .padding(.top, faceHeight * 0.02)
            }
            .frame(width: size.width, height: faceHeight)
            .background(
                RoundedRectangle(cornerRadius: radius)
                    .fill(pressed ? accent.opacity(0.12) : .white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .strokeBorder(pressed ? accent : edge, lineWidth: 2.5)
            )
            .offset(y: pressed ? depth : 0)
        }
        .frame(width: size.width, height: size.height)
        // Press shows instantly; only the release is animated.
        .animation(pressed ? nil : .spring(response: 0.18, dampingFraction: 0.6), value: pressed)
    }
}

struct ProgressBar: View {
    let value: Double

    var body: some View {
        GeometryReader { g in
            ZStack(alignment: .leading) {
                Capsule().fill(Color(white: 0.9))
                Capsule()
                    .fill(value >= 1 ? Color(red: 1.0, green: 0.78, blue: 0.0)
                                     : Color(red: 0.35, green: 0.8, blue: 0.0))
                    .frame(width: g.size.width * value)
            }
            // Bars fill from the right, matching the reading direction.
            .environment(\.layoutDirection, .rightToLeft)
        }
        .animation(.easeOut(duration: 0.25), value: value)
    }
}
