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
        let eyes = Set(TileUtility.findEyes(from: tiles))
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
        let melds = TileUtility.findMelds(from: remainingTiles)
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
}
