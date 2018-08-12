import Foundation

public struct 国士無双: YakuProtocol {
    public var closedHan: Int {
        if isWaitingHead {
            return 26
        } else {
            return 13
        }
    }
    public let name = "国士無双"
    public let openedHan: Int? = nil
    public let isWaitingHead: Bool

    internal init(isWaitingHead: Bool) {
        self.isWaitingHead = isWaitingHead
    }

    public static func make(with tiles: [Tile], form: OrdinaryWinningForm?, picked: Tile, context: GameContext) -> 国士無双? {
        let uniquedArray = Set<Tile>(tiles)
        if uniquedArray.count != 13 {
            return nil
        }
        let expectedTiles: [Tile] = [.character(1)!, .character(9)!,
                                     .bamboo(1)!, .bamboo(9)!,
                                     .dots(1)!, .dots(9)!,
                                     .east, .south, .west, .north,
                                     .blank, .fortune, .center,]
        for expectedTile in expectedTiles {
            if !uniquedArray.contains(expectedTile) {
                return nil
            }
        }
        return 国士無双(isWaitingHead: true)
    }
}
