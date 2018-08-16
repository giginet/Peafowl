import Foundation

public protocol TileCollection {
    func allSatisfy(_ predicate: (Tile) throws -> Bool) rethrows -> Bool
}

extension Array: TileCollection where Element == Tile {
}
