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

extension Hand: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Tile

    public init(arrayLiteral elements: Hand.ArrayLiteralElement...) {
        guard let picked = elements.last else {
            fatalError("Could not make Hand from empty Array.")
        }
        self = .init(tiles: Array(elements.dropLast()), picked: picked)
    }
}
