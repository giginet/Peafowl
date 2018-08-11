import Foundation

public struct 七対子: SevenPairsFormedYaku {
    public let openedHan: Int? = nil
    public let closedHan: Int = 2
    
    public let name = "七対子"
    public static func make(with tiles: (PairToken, PairToken, PairToken, PairToken, PairToken, PairToken, PairToken), drawed: Tile) -> 七対子? {
        return nil
    }
}
