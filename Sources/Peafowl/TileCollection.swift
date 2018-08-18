import Foundation

public protocol TileCollection {
    func allSatisfy(_ predicate: (Tile) throws -> Bool) rethrows -> Bool
    func contains(_ tile: Tile) -> Bool
}

extension Array: TileCollection where Element == Tile {
}
