import Foundation

struct Letter: Identifiable, Hashable {
    let id: Int          // 0-based position in the alphabet
    let glyph: String    // Thaana character
    let name: String     // traditional letter name
    let sound: String    // short romanised sound shown under the glyph
    var soundFile: String { String(format: "letter_%02d", id + 1) }
}

extension Letter {
    /// The 24 base letters of Thaana in traditional order.
    /// Sound files letter_01 ... letter_24 follow this same order.
    static let thaana: [Letter] = [
        ("ހ", "haa", "h"),
        ("ށ", "shaviyani", "sh"),
        ("ނ", "noonu", "n"),
        ("ރ", "raa", "r"),
        ("ބ", "baa", "b"),
        ("ޅ", "lhaviyani", "lh"),
        ("ކ", "kaafu", "k"),
        ("އ", "alifu", "a"),
        ("ވ", "vaavu", "v"),
        ("މ", "meemu", "m"),
        ("ފ", "faafu", "f"),
        ("ދ", "dhaalu", "dh"),
        ("ތ", "thaa", "th"),
        ("ލ", "laamu", "l"),
        ("ގ", "gaafu", "g"),
        ("ޏ", "gnaviyani", "gn"),
        ("ސ", "seenu", "s"),
        ("ޑ", "daviyani", "d"),
        ("ޒ", "zaviyani", "z"),
        ("ޓ", "taviyani", "t"),
        ("ޔ", "yaa", "y"),
        ("ޕ", "paviyani", "p"),
        ("ޖ", "javiyani", "j"),
        ("ޗ", "chaviyani", "ch"),
    ].enumerated().map { Letter(id: $0.offset, glyph: $0.element.0, name: $0.element.1, sound: $0.element.2) }
}
