import Foundation

public struct Hand: Equatable {
    var tiles: [Tile]
    var picked: Tile

    public var allTiles: [Tile] {
        return tiles + [picked]
    }
}
