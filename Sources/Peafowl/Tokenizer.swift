import Foundation

internal final class Tokenizer {
    private let hand: Hand
    
    init(hand: Hand) {
        self.hand = hand
    }
    
    func tokenize() {
    }
    
    func filterEyes() -> [PairToken] {
        var tiles = hand.allTiles
        var results: [PairToken] = []
        for tile in Set(tiles) {
            if tiles.count(tile) >= 2 {
                for _ in 0..<2 {
                    if let index = tiles.firstIndex(of: tile) {
                        tiles.remove(at: index)
                    }
                }
                guard let pair = PairToken(tiles: (tile, tile)) else { continue }
                results.append(pair)
            }
        }
        return results
    }
}
