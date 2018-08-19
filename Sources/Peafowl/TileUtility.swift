import Foundation

struct TileUtility {
    static func melds(from winningForm: MeldedWinningForm) -> [MeldToken] {
        return [winningForm.1, winningForm.2, winningForm.3, winningForm.4]
    }

    static func isValueHonor(_ tile: Tile, by context: GameContext) -> Bool {
        return tile.isDragon || tile == context.prevalentWind || tile == context.seatWind
    }

    static func isConcealed(_ winningForm: WinningForm) -> Bool {
        switch winningForm {
        case .melded(let tokens):
            return melds(from: tokens).allSatisfy { $0.isConcealed }
        case .sevenPairs, .thirteenOrphans:
            return true
        }
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

    private static func move<T: Token>(_ token: T, from tiles: inout [Tile], to tokens: inout [T]) {
        tiles.remove(token)
        tokens.append(token)
    }
}
