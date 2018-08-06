import Foundation

public struct Hand: Equatable {
    var tiles: [Tile]
    var drawed: Tile?
    
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
