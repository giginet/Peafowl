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
        let hasCharacter = tripletsMelds.first { $0.isCharacter() } != nil
        let hasBamboo = tripletsMelds.first { $0.isBamboo() } != nil
        let hasDots = tripletsMelds.first { $0.isDots() } != nil
        if hasCharacter && hasBamboo && hasDots {
            return 三色同刻()
        }
        return nil
    }
}
