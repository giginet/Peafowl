import Foundation

public struct 七対子: SevenPairsFormedYaku {
    public let openedHan: Int? = nil
    public let closedHan: Int = 2
    
    public static func make(with tiles: (PairToken, PairToken, PairToken, PairToken, PairToken, PairToken, PairToken), drawed: Tile) -> 七対子? {
        if tiles.0.isEyes
            && tiles.1.isEyes
            && tiles.2.isEyes
            && tiles.3.isEyes
            && tiles.4.isEyes
            && tiles.5.isEyes
            && tiles.6.isEyes {
            return 七対子()
        }
        return nil
    }
}
