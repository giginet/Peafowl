import Foundation

extension YakuProtocol {
    static func melds(from winningForm: MeldedWinningForm) -> [MeldToken] {
        return [winningForm.1, winningForm.2, winningForm.3, winningForm.4]
    }
    
    static func isValueHonor(_ tile: Tile, context: GameContext) -> Bool {
        return tile.isDragon || tile == context.prevalentWind || tile == context.seatWind
    }
}
