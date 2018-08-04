import Foundation

private func move<T: Token>(_ token: T, from tiles: inout [Tile], to tokens: inout [T]) {
    tiles.removeToken(token)
    tokens.append(token)
}

internal func findTripletMelds(from tiles: [Tile]) -> Set<MeldToken> {
    return Set(tiles.compactMap { tile in
        if tiles.count(tile) >= 3 {
            return MeldToken((tile, tile, tile))
        }
        return nil
    })
}

internal func findSequentialMelds(from tiles: [Tile]) -> Set<MeldToken> {
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

internal final class Tokenizer {
    private let hand: Hand
    
    init(hand: Hand) {
        self.hand = hand
    }
    
    func tokenize() -> [OrdinaryForm] {
        let eyes = Set(findEyes(from: hand.allTiles))
        let forms: [OrdinaryForm] = eyes.map { eye in
            var currentTiles = self.hand.allTiles
            currentTiles.removeToken(eye)
            let searchedMelds = searchMelds(remainingTiles: currentTiles,
                                            context: [],
                                            searchedMelds: Set())
            for melds in searchedMelds {
                if melds.count == 4 {
                    let form: OrdinaryForm = (eye, melds[0], melds[1], melds[2], melds[3])
                    return form
                }
            }
            return nil
            }.compactMap { $0 }
        return forms
    }
    
    private func searchMelds(remainingTiles: [Tile],
                             context: [MeldToken],
                             searchedMelds: Set<[MeldToken]>) -> Set<[MeldToken]> {
        let melds = findMelds(from: remainingTiles)
        var newSearchedMelds = searchedMelds
        // TODO Use reduce
        for meld in melds {
            var mutableRemainingTiles = remainingTiles
            mutableRemainingTiles.removeToken(meld)
            let newContext = context + [meld]
            if mutableRemainingTiles.isEmpty {
                newSearchedMelds.insert(newContext)
                return newSearchedMelds
            } else {
                let recursiveSearchedMelds = searchMelds(remainingTiles: mutableRemainingTiles,
                                                         context: newContext ,
                                                         searchedMelds: newSearchedMelds)
                newSearchedMelds = newSearchedMelds.union(recursiveSearchedMelds)
            }
        }
        return newSearchedMelds
    }
    
    func findMelds(from tiles: [Tile]) -> Set<MeldToken> {
        return findSequentialMelds(from: tiles).union(findTripletMelds(from: tiles))
    }
    
    func findEyes() -> [EyesToken] {
        return findEyes(from: hand.allTiles)
    }
    
    func findEyes(from tiles: [Tile]) -> [EyesToken] {
        var mutableTiles = tiles
        var results: [EyesToken] = []
        for tile in tiles {
            if mutableTiles.count(tile) >= 2 {
                guard let newPair = EyesToken((tile, tile)) else { continue }
                move(newPair, from: &mutableTiles, to: &results)
            }
        }
        return results
    }
}