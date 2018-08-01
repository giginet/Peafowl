import Foundation

extension Array where Element == Tile {
    @discardableResult
    mutating func removeToken<T: Token>(_ token: T) -> [Element] {
        var removedTiles: [Tile] = []
        for tile in token.asArray {
            if let removedTile = removeFirst(tile) {
                removedTiles.append(removedTile)
            }
        }
        return removedTiles
    }
}
