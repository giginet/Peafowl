import Foundation

internal typealias TokenizedResult = (PairToken, [MeldToken])

private func consistsOfSameElements<Element: Equatable>(between lhs: [Element], and rhs: [Element]) -> Bool {
    let contained = lhs.compactMap { element in
        return rhs.contains(element) ? element : nil
    }
    return contained == lhs
}

private func contains<Element: Equatable>(_ element: [Element], in collection: [[Element]]) -> Bool {
    return collection.contains { consistsOfSameElements(between: element, and: $0) }
}

internal struct Tokenizer {
    func tokenize(from tiles: [Tile]) -> [TokenizedResult] {
        let eyes = Set(Tokenizer.findEyes(from: tiles))
        let forms: [TokenizedResult] = eyes.reduce(into: []) { results, eye in
            let currentTiles = tiles.removed(eye)
            let searchedMelds = searchMelds(remainingTiles: currentTiles)
            for melds in searchedMelds where melds.count == 4 {
                results.append((eye, melds))
            }
            }.compactMap { $0 }
        return forms
    }

    private func searchMelds(remainingTiles: [Tile],
                             stack: [MeldToken] = [],
                             searchedMelds: Set<[MeldToken]> = Set()) -> Set<[MeldToken]> {
        let melds = Tokenizer.findMelds(from: remainingTiles)
        return melds.reduce(into: searchedMelds) { searchedMelds, meld in
            let newRemainingTiles = remainingTiles.removed(meld)
            let newStack = stack + [meld]
            if newStack.count == 4 && !contains(newStack, in: Array(searchedMelds)) {
                searchedMelds.insert(newStack)
            } else {
                let recursiveSearchedMelds = searchMelds(remainingTiles: newRemainingTiles,
                                                         stack: newStack ,
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
