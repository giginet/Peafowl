import Foundation

public struct Hand: Equatable {
    var drawed: Tile?
    var tiles: [Tile]
    
    public var allTiles: [Tile] {
        if let drawed = drawed {
            return tiles + [drawed]
        }
        return tiles
    }
    
    public var isValid: Bool {
        return drawed != nil && tiles.count == 13
    }
}
