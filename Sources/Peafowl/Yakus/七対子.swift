import Foundation

public struct 七対子: SevenPairsFormedYaku {
    public let openedHan: Int? = nil
    public let closedHan: Int = 2
    
    public static func make(with tiles: (PairToken, PairToken, PairToken, PairToken, PairToken, PairToken, PairToken), drawed: Tile) -> 七対子? {
        if tiles.0.isHead
            && tiles.1.isHead
            && tiles.2.isHead
            && tiles.3.isHead
            && tiles.4.isHead
            && tiles.5.isHead
            && tiles.6.isHead {
            return 七対子()
        }
        return nil
    }
}
