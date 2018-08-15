import Foundation

public struct 二盃口: YakuProtocol {
    public let openedHan: Int? = nil
    public let closedHan: Int = 3
    
    public let name = "二盃口"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 二盃口? {
        guard case .melded(let tokens) = form else {
            return nil
        }
        let melds = [tokens.1, tokens.2, tokens.3, tokens.4]
        let duplicatedSequentialMelds = Set(melds.compactMap { meld -> MeldToken? in
            if meld.isSequential && melds.count(meld) == 2 {
                return meld
            }
            return nil
        })
        if duplicatedSequentialMelds.count == 2 {
            return 二盃口()
        }
        return nil
    }
}
