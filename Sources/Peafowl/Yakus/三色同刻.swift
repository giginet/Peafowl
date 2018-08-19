import Foundation

public struct 三色同刻: YakuProtocol {
    public let openedFan: Int? = 2
    public let concealedFan: Int = 2

    public let name = "三色同刻"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 三色同刻? {
        guard case .melded(let tokens) = form else {
            return nil
        }
        let melds = TileUtility.melds(from: tokens)
        let tripletsMelds = melds.filter { $0.isTriplets }
        
        for meld in tripletsMelds {
            if tripletsMelds.contains(where: { $0.first.number == meld.first.number && $0.isCharacter })
                && tripletsMelds.contains(where: { $0.first.number == meld.first.number && $0.isBamboo })
                && tripletsMelds.contains(where: { $0.first.number == meld.first.number && $0.isDots }) {
                return 三色同刻()
            }
        }
        return nil
    }
}
