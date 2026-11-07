import Foundation
import Observation

@Observable
final class AlphabetModel {
    let letters = Letter.thaana

    /// Number of fingers currently on each tile (drives the pressed look).
    private(set) var pressCount: [Int]
    /// Lifetime taps per letter (drives the progress bar).
    private(set) var taps: [Int]

    /// Taps needed to fill a letter's progress bar.
    static let tapsToFill = 5
    private static let storeKey = "letterTaps"

    init() {
        let n = Letter.thaana.count
        pressCount = Array(repeating: 0, count: n)
        let saved = UserDefaults.standard.array(forKey: Self.storeKey) as? [Int] ?? []
        taps = saved.count == n ? saved : Array(repeating: 0, count: n)
        SoundPlayer.shared.prepare(letters.map(\.soundFile))
    }

    func down(_ index: Int) {
        // Sound first: this is the part the child notices.
        SoundPlayer.shared.play(letters[index].soundFile)
        pressCount[index] += 1
        taps[index] += 1
        UserDefaults.standard.set(taps, forKey: Self.storeKey)
    }

    func up(_ index: Int) {
        pressCount[index] = max(0, pressCount[index] - 1)
    }

    func isPressed(_ index: Int) -> Bool { pressCount[index] > 0 }

    func progress(_ index: Int) -> Double {
        min(1, Double(taps[index]) / Double(Self.tapsToFill))
    }

    func resetProgress() {
        taps = Array(repeating: 0, count: letters.count)
        UserDefaults.standard.set(taps, forKey: Self.storeKey)
    }
}
