import Foundation

public struct 七対子: SevenPairFormedYaku {
    public let openedHan: Int = 2
    public let closedHan: Int? = nil
    
    public func validate(with tiles: (PairToken, PairToken, PairToken, PairToken, PairToken, PairToken, PairToken), drawed: Tile) -> Bool {
        return tiles.0.isHead
            && tiles.1.isHead
            && tiles.2.isHead
            && tiles.3.isHead
            && tiles.4.isHead
            && tiles.5.isHead
            && tiles.6.isHead
    }
}
