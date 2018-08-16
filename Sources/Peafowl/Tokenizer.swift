import Foundation

internal typealias TokenizedResult = (PairToken, [MeldToken])

internal struct Tokenizer {
    func tokenize(from tiles: [Tile]) -> [TokenizedResult] {
        let eyes = Set(Tokenizer.findEyes(from: tiles))
        let forms: [TokenizedResult] = eyes.map { eye in
            let currentTiles = tiles.removed(eye)
            let searchedMelds = searchMelds(remainingTiles: currentTiles)
            for melds in searchedMelds where melds.count == 4 {
                return (eye, melds)
            }
            return nil
            }.compactMap { $0 }
        return forms
    }

    private func searchMelds(remainingTiles: [Tile],
                             context: [MeldToken] = [],
                             searchedMelds: Set<[MeldToken]> = Set()) -> Set<[MeldToken]> {
        let melds = Tokenizer.findMelds(from: remainingTiles)
        return melds.reduce(into: Set<[MeldToken]>()) { searchedMelds, meld in
            let newRemainingTiles = remainingTiles.removed(meld)
            let newContext = context + [meld]
            if newContext.count == 4 {
                searchedMelds.insert(newContext)
            } else {
                let recursiveSearchedMelds = searchMelds(remainingTiles: newRemainingTiles,
                                                         context: newContext ,
                                                         searchedMelds: searchedMelds)
                searchedMelds.formUnion(recursiveSearchedMelds)
            }
        }
    }

    private static func move<T: Token>(_ token: T, from tiles: inout [Tile], to tokens: inout [T]) {
        tiles.remove(token)
        tokens.append(token)
    }

    internal static func findEyes(from tiles: [Tile]) -> [PairToken] {
        var mutableTiles = tiles
        var results: [PairToken] = []
        for tile in tiles {
            if mutableTiles.countIf(tile) >= 2 {
                guard let newPair = PairToken((tile, tile)) else { continue }
                move(newPair, from: &mutableTiles, to: &results)
            }
        }
        return results
    }

    internal static func findTripletMelds(from tiles: [Tile]) -> Set<MeldToken> {
        return Set(tiles.compactMap { tile in
            if tiles.countIf(tile) >= 3 {
                return MeldToken((tile, tile, tile))
            }
            return nil
        })
    }

    internal static func findSequentialMelds(from tiles: [Tile]) -> Set<MeldToken> {
        return Set(tiles.compactMap { tile in
            guard let previousTile = tile.previous, tiles.contains(previousTile) else {
                return nil
            }
            guard let nextTile = tile.next, tiles.contains(nextTile) else {
                return nil
            }
            return MeldToken((previousTile, tile, nextTile))
        })
    }

    internal static func findMelds(from tiles: [Tile]) -> Set<MeldToken> {
        return findSequentialMelds(from: tiles).union(findTripletMelds(from: tiles))
    }
    
    internal static func convertToWinningForm(from tokenizeResult: TokenizedResult) -> MeldedWinningForm? {
        if tokenizeResult.1.count == 4 {
            return (tokenizeResult.0, tokenizeResult.1[0], tokenizeResult.1[1], tokenizeResult.1[2], tokenizeResult.1[3])
        }
        return nil
    }
}
