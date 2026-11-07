import SwiftUI

struct ContentView: View {
    @State private var model = AlphabetModel()
    @State private var askReset = false

    var body: some View {
        VStack(spacing: 12) {
            // Parents: hold the title for 3 seconds to reset progress.
            Text("ތާނަ")
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(Color(white: 0.25))
                .onLongPressGesture(minimumDuration: 3) { askReset = true }

            GeometryReader { geo in
                let layout = GridLayout(count: model.letters.count, in: geo.size,
                                        gap: min(geo.size.width, geo.size.height) * 0.025)
                ZStack {
                    ForEach(model.letters) { letter in
                        let f = layout.frame(letter.id)
                        LetterTile(letter: letter,
                                   pressed: model.isPressed(letter.id),
                                   progress: model.progress(letter.id),
                                   size: f.size)
                            .position(x: f.midX, y: f.midY)
                    }
                    .allowsHitTesting(false)

                    TouchSurface(tileAt: { layout.index(at: $0) },
                                 onDown: { model.down($0) },
                                 onUp: { model.up($0) })
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Color.white.ignoresSafeArea())
        .confirmationDialog("Reset progress for all letters?", isPresented: $askReset) {
            Button("Reset", role: .destructive) { model.resetProgress() }
        }
    }
}

#Preview {
    ContentView()
}
