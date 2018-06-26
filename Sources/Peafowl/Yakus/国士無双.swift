import Foundation

public struct 国士無双: ThirteenOrphansFormedYaku {
    public let openedHan: Int = 2
    public let closedHan: Int? = nil
    
    public func validate(with hand: Hand, drawed: Tile) -> Bool {
        let uniquedArray = Set<Tile>(hand.allTiles)
        if uniquedArray.count != 13 {
            return false
        }
        let expectedTiles: [Tile] = [.character(1), .character(9),
                                     .bamboo(1), .bamboo(9),
                                     .dots(1), .dots(9),
                                     .east, .south, .west, .north,
                                     .blank, .fortune, .center]
        for expectedTile in expectedTiles {
            if !uniquedArray.contains(expectedTile) {
                return false
            }
        }
        return true
    }
}
