import Foundation

extension YakuProtocol {
    static func melds(from winningForm: MeldedWinningForm) -> [MeldToken] {
        return [winningForm.1, winningForm.2, winningForm.3, winningForm.4]
    }
    
    static func isValueHonor(_ tile: Tile, context: GameContext) -> Bool {
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
}
