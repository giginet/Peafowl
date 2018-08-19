import Foundation

public struct 三色同順: YakuProtocol {
    public let openedFan: Int? = nil
    public let concealedFan: Int = 2

    public let name = "三色同順"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 三色同順? {
        guard case .melded(let tokens) = form else {
            return nil
        }
        let melds = TileUtility.melds(from: tokens)
        let sequentialMelds = melds.filter { $0.isSequential }

        for meld in sequentialMelds {
            if sequentialMelds.contains(where: { $0.first.number == meld.first.number && $0.isCharacter })
            && sequentialMelds.contains(where: { $0.first.number == meld.first.number && $0.isBamboo })
                && sequentialMelds.contains(where: { $0.first.number == meld.first.number && $0.isDots }) {
                return 三色同順()
            }
        }
        return nil
    }
}
