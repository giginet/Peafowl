import Foundation

extension Array where Element == Tile {
    @discardableResult
    mutating func remove<T: Token>(_ token: T) -> [Element] {
        var removedTiles: [Tile] = []
        for tile in token.asArray {
            if let removedTile = removeFirst(tile) {
                removedTiles.append(removedTile)
            }
        }
        return removedTiles
    }
    
    func removed<T: Token>(_ token: T) -> [Element] {
        var mutableSelf = self
        mutableSelf.remove(token)
        return mutableSelf
    }
}
