import Foundation

public struct ドラ: YakuProtocol {
    private let count: Int
    public var openedHan: Int? {
        return count
    }
    public var closedHan: Int {
        return count
    }
    
    public let name = "ドラ"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> ドラ? {
        let doraCount = tiles.reduce(0) { previousCount, tile in
            return previousCount + context.dora.countIf(tile)
        }
        if doraCount == 0 {
            return nil
        }
        return ドラ(count: doraCount)
    }
}
