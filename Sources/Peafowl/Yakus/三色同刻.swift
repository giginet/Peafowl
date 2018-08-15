import Foundation

public struct 三色同刻: YakuProtocol {
    public let openedHan: Int? = 2
    public let closedHan: Int = 2
    
    public let name = "三色同刻"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 三色同刻? {
        guard case .ordinary(let tokens) = form else {
            return nil
        }
        let melds = [tokens.1, tokens.2, tokens.3, tokens.4]
        let tripletsMelds = melds.filter { $0.isTriplets }
        guard let character = tripletsMelds.first(where: { $0.isCharacter }) else { return nil }
        guard let bamboo = tripletsMelds.first(where: { $0.isBamboo }) else { return nil }
        guard let dots = tripletsMelds.first(where: { $0.isDots }) else { return nil }
        if character.asArray.first?.number == bamboo.asArray.first?.number
            && dots.asArray.first?.number == bamboo.asArray.first?.number {
            return 三色同刻()
        }
        return nil
    }
}
