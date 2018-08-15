import Foundation

public protocol TileCollection {
    func consistOnly(of filter: (Tile) -> Bool) -> Bool
}

extension Array: TileCollection where Element == Tile {
    public func consistOnly(of condition: (Tile) -> Bool) -> Bool {
        return filter(condition).count == count
    }
}
