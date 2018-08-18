import Foundation

public struct ドラ: YakuProtocol {
    private let count: Int
    public var openedFan: Int? {
        return count
    }
    public var concealedFan: Int {
        return count
    }

    internal init(_ count: Int) {
        self.count = count
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(count)
    }
    public let name = "ドラ"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> ドラ? {
        let doraCount = tiles.reduce(0) { previousCount, tile in
            return previousCount + context.dora.countIf(tile)
        }
        if doraCount == 0 {
            return nil
        }
        return ドラ(doraCount)
    }
}
