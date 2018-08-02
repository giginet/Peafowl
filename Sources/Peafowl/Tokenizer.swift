import Foundation

internal func findMelds(from tiles: [Tile]) -> [SetToken] {
    var result: [SetToken] = []
    var currentTiles = tiles
    for tile in tiles.unique() {
        if currentTiles.count(tile) >= 3 {
            guard let newMelds = SetToken(tiles: (tile, tile, tile)) else { continue }
            result.append(newMelds)
            currentTiles.removeToken(newMelds)
        }
    }
    return result
}

internal final class Tokenizer {
    private let hand: Hand
    
    init(hand: Hand) {
        self.hand = hand
    }
    
    func tokenize() {
        let eyes = Set(filterEyes(hand.allTiles))
        for eye in eyes {
            var mutableTiles = self.hand.allTiles
            mutableTiles.removeToken(eye)
        }
    }
    
    func filterSets(_ tiles: [Tile]) -> [SetToken] {
        var mutableTiles = tiles
        var results: [SetToken] = []
        return results
    }
    
    func filterEyes() -> [PairToken] {
        return filterEyes(hand.allTiles)
    }
    
    func filterEyes(_ tiles: [Tile]) -> [PairToken] {
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
