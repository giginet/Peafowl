import Foundation

public struct Hand: Equatable {
    public var tiles: [Tile]
    public var picked: Tile
    
    public init(tiles: [Tile], picked: Tile) {
        self.tiles = tiles
        self.picked = picked
    }

    public var allTiles: [Tile] {
        return tiles + [picked]
    }
}
