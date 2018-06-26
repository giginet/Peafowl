import Foundation

public struct 断ヤオ九: OrdinaryFormedYaku {
    public let openedHan: Int = 1
    public let closedHan: Int? = 1
    
    public func validate(with tiles: (PairToken, SetToken, SetToken, SetToken, SetToken), drawed: Tile) -> Bool {
        if !tiles.0.isHead {
            return false
        }
        func isNotYaochu(tile: Tile) -> Bool {
            return !tile.isHonor && !tile.isTerminal
        }
        return tiles.1.consistOnly(of: isNotYaochu)
            && tiles.2.consistOnly(of: isNotYaochu)
            && tiles.3.consistOnly(of: isNotYaochu)
            && tiles.4.consistOnly(of: isNotYaochu)
    }
}
