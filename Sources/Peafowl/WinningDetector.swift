import Foundation

internal struct WinningDetector {
    internal enum WinningForm {
        case ordinary([TokenizedResult])
        case sevenPairs
        case thirteenOrphans
    }
    
    func detectForms(_ tiles: [Tile]) -> [WinningForm]? {
        guard tiles.count == 14 else {
            return nil
        }
        
        if isThirteenOrphansForm(tiles) {
            return [.thirteenOrphans]
        }
        
        var results: [WinningForm] = []
        if isSevenPairsWinningForm(tiles) {
            results.append(.sevenPairs)
        }
        
        let tokenizer = Tokenizer()
        let tokenizedResults = tokenizer.tokenize(from: tiles)
        if !tokenizedResults.isEmpty {
            results.append(.ordinary(tokenizedResults))
        }
        if results.isEmpty {
            return nil
        }
        return results
    }
    
    private func isSevenPairsWinningForm(_ tiles: [Tile]) -> Bool {
        let eyes = Tokenizer.findEyes(from: tiles)
        return eyes.count == 7
    }
    
    private func isThirteenOrphansForm(_ tiles: [Tile]) -> Bool {
        let eyes = Tokenizer.findEyes(from: tiles)
        return eyes.count == 1 && Set(tiles).count == 13
    }
}
