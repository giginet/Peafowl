import Foundation

private func move<T: Token>(_ token: T, from tiles: inout [Tile], to tokens: inout [T]) {
    tiles.removeToken(token)
    tokens.append(token)
}

internal func findMelds(from tiles: [Tile]) -> [SetToken] {
    var result: [SetToken] = []
    var currentTiles = tiles
    for tile in tiles.unique() {
        if currentTiles.count(tile) >= 3 {
            guard let newMeld = SetToken(tiles: (tile, tile, tile)) else { continue }
            move(newMeld, from: &currentTiles, to: &result)
        }
    }
    return result
}

internal func findChows(from tiles: [Tile]) -> [SetToken] {
    var result: [SetToken] = []
    var currentTiles = tiles
    for tile in tiles.unique() {
        guard let previousTile = tile.previous, currentTiles.contains(previousTile) else {
            continue
        }
        guard let nextTile = tile.next, currentTiles.contains(nextTile) else {
            continue
        }
        guard let newChow = SetToken(tiles: (previousTile, tile, nextTile)) else {
            continue
        }
        move(newChow, from: &currentTiles, to: &result)
    }
    return result
}

internal final class Tokenizer {
    private let hand: Hand
    
    init(hand: Hand) {
        self.hand = hand
    }
    
    func tokenize() {
        let eyes = Set(findEyes(hand.allTiles))
        for eye in eyes {
            var mutableTiles = self.hand.allTiles
            mutableTiles.removeToken(eye)
        }
    }
    
    func findSets(_ tiles: [Tile]) -> [SetToken] {
        return findChows(from: tiles) + findMelds(from: tiles)
    }
    
    func findEyes() -> [PairToken] {
        return findEyes(hand.allTiles)
    }
    
    func findEyes(_ tiles: [Tile]) -> [PairToken] {
        var mutableTiles = tiles
        var results: [PairToken] = []
        for tile in Set(mutableTiles) {
            if tiles.count(tile) >= 2 {
                for _ in 0..<2 {
                    if let index = mutableTiles.firstIndex(of: tile) {
                        mutableTiles.remove(at: index)
                    }
                }
                guard let pair = PairToken(tiles: (tile, tile)) else { continue }
                results.append(pair)
            }
        }
        return results
    }
}
