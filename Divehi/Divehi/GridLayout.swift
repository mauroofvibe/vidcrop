import CoreGraphics

/// Fits every tile on screen at once (no scrolling) and lays them out
/// right-to-left, the reading direction of Thaana.
///
/// No ScrollView on purpose: scroll views hold back touches ~150 ms to see if
/// you are scrolling, and a toddler's swipe would move the page instead of
/// playing a letter.
struct GridLayout {
    let count: Int
    let gap: CGFloat
    let columns: Int
    let rows: Int
    let tile: CGSize
    let origin: CGPoint

    init(count: Int, in size: CGSize, gap: CGFloat) {
        self.count = count
        self.gap = gap

        var best: (cols: Int, rows: Int, tile: CGSize, score: CGFloat) = (1, count, .zero, -1)
        for cols in 3...8 {
            let rows = Int((Double(count) / Double(cols)).rounded(.up))
            let maxW = (size.width - CGFloat(cols - 1) * gap) / CGFloat(cols)
            let maxH = (size.height - CGFloat(rows - 1) * gap) / CGFloat(rows)
            guard maxW > 0, maxH > 0 else { continue }
            // Keep tiles roughly card-shaped: not too tall, not too wide.
            let w = min(maxW, maxH * 1.6)
            let h = min(maxH, w * 1.1)
            let score = min(w, h)
            if score > best.score { best = (cols, rows, CGSize(width: w, height: h), score) }
        }

        columns = best.cols
        rows = best.rows
        tile = best.tile
        let totalW = CGFloat(columns) * tile.width + CGFloat(columns - 1) * gap
        let totalH = CGFloat(rows) * tile.height + CGFloat(rows - 1) * gap
        origin = CGPoint(x: (size.width - totalW) / 2, y: (size.height - totalH) / 2)
    }

    func frame(_ index: Int) -> CGRect {
        let row = index / columns
        let col = index % columns
        let x = origin.x + CGFloat(columns - 1 - col) * (tile.width + gap)   // right-to-left
        let y = origin.y + CGFloat(row) * (tile.height + gap)
        return CGRect(origin: CGPoint(x: x, y: y), size: tile)
    }

    /// Tile under a finger. The gaps between tiles count as the nearest tile,
    /// so a slightly-off tap still plays something.
    func index(at point: CGPoint) -> Int? {
        for i in 0..<count where frame(i).insetBy(dx: -gap / 2, dy: -gap / 2).contains(point) {
            return i
        }
        return nil
    }
}
