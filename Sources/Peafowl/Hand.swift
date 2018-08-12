import Foundation

public struct Hand: Equatable {
    var tiles: [Tile]
    var picked: Tile?

    public var allTiles: [Tile] {
        if let picked = picked {
            return tiles + [picked]
        }
        return tiles
    }

    public var isValid: Bool {
        return picked != nil && tiles.count == 13
    }
}
