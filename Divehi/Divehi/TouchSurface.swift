import SwiftUI
import UIKit

/// A transparent multi-touch layer laid over the whole grid.
///
/// Why not SwiftUI Buttons: a Button fires on finger *lift*, and is cancelled
/// when a second finger lands or the finger drags. Toddlers do both constantly.
/// This view fires on finger *down*, tracks every finger independently, and
/// also fires when a finger slides onto a new tile.
struct TouchSurface: UIViewRepresentable {
    var tileAt: (CGPoint) -> Int?
    var onDown: (Int) -> Void
    var onUp: (Int) -> Void

    func makeUIView(context: Context) -> TouchSurfaceView {
        let view = TouchSurfaceView()
        update(view)
        return view
    }

    func updateUIView(_ view: TouchSurfaceView, context: Context) {
        update(view)
    }

    private func update(_ view: TouchSurfaceView) {
        view.tileAt = tileAt
        view.onDown = onDown
        view.onUp = onUp
    }
}

final class TouchSurfaceView: UIView {
    var tileAt: (CGPoint) -> Int? = { _ in nil }
    var onDown: (Int) -> Void = { _ in }
    var onUp: (Int) -> Void = { _ in }

    /// Which tile each live finger is currently on.
    private var active: [ObjectIdentifier: Int] = [:]

    override init(frame: CGRect) {
        super.init(frame: frame)
        isMultipleTouchEnabled = true
        isExclusiveTouch = false
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) { fatalError() }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { move(touch) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { move(touch) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { lift(touch) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { lift(touch) }
    }

    private func move(_ touch: UITouch) {
        let key = ObjectIdentifier(touch)
        let tile = tileAt(touch.location(in: self))
        guard tile != active[key] else { return }
        if let old = active[key] { onUp(old) }
        active[key] = tile
        if let tile { onDown(tile) }
    }

    private func lift(_ touch: UITouch) {
        if let old = active.removeValue(forKey: ObjectIdentifier(touch)) { onUp(old) }
    }
}
