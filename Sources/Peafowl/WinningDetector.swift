import Foundation

/// 通常和了形
public typealias MeldedWinningForm = (PairToken, MeldToken, MeldToken, MeldToken, MeldToken)
/// 七対子系
public typealias SevenPairsForm = (PairToken, PairToken, PairToken, PairToken, PairToken, PairToken, PairToken)
/// 国士無双系
public typealias ThirteenOrphansForm = (PairToken, Tile, Tile, Tile, Tile, Tile, Tile, Tile, Tile, Tile, Tile, Tile, Tile)

public enum WinningForm {
    case melded(MeldedWinningForm)
    case sevenPairs(SevenPairsForm)
    case thirteenOrphans(ThirteenOrphansForm)
}

internal struct WinningDetector {
    func detectForms(_ tiles: [Tile]) -> [WinningForm]? {
        guard tiles.count == 14 else {
            return nil
        }

        if let form = detectThirteenOrphansForm(tiles) {
            return [.thirteenOrphans(form)]
        }

        var results: [WinningForm] = []
        if let form = detectSevenPairsForm(tiles) {
            results.append(.sevenPairs(form))
        }

        let tokenizer = Tokenizer()
        let tokenizedResults = tokenizer.tokenize(from: tiles)
        let meldedForms = tokenizedResults.compactMap { (tokenizedResult) -> WinningForm? in
            if let meldedWinningForm = TileUtility.convertToWinningForm(from: tokenizedResult) {
                return .melded(meldedWinningForm)
            }
            return nil
        }
        results += meldedForms
        if results.isEmpty {
            return nil
        }
        return results
    }

    private func detectSevenPairsForm(_ tiles: [Tile]) -> SevenPairsForm? {
        let eyes = TileUtility.findEyes(from: tiles)
        if eyes.count == 7 {
            return (eyes[0], eyes[1], eyes[2], eyes[3], eyes[4], eyes[5], eyes[6])
        }
        return nil
    }

    private func detectThirteenOrphansForm(_ tiles: [Tile]) -> ThirteenOrphansForm? {
        let eyes = TileUtility.findEyes(from: tiles)
        guard let eye = eyes.first else {
            return nil
        }
        let remainingTiles = tiles.unique().removed(eye)
        if eyes.count == 1 && remainingTiles.count == 12 {
            return (eye, remainingTiles[0], remainingTiles[1], remainingTiles[2],
                    remainingTiles[3], remainingTiles[4], remainingTiles[5],
                    remainingTiles[6], remainingTiles[7], remainingTiles[8],
                    remainingTiles[9], remainingTiles[10], remainingTiles[11])
        }
        return nil
    }
}
