import Foundation

public struct 三色同順: YakuProtocol {
    public let openedHan: Int? = nil
    public let closedHan: Int = 1
    
    public let name = "三色同順"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 三色同順? {
        guard case .ordinary(let tokens) = form else {
            return nil
        }
        let melds = [tokens.1, tokens.2, tokens.3, tokens.4]
        let sequentialMelds = melds.filter { $0.isSequential }
        let hasCharacter = sequentialMelds.first { $0.isCharacter() } != nil
        let hasBamboo = sequentialMelds.first { $0.isBamboo() } != nil
        let hasDots = sequentialMelds.first { $0.isDots() } != nil
        if hasCharacter && hasBamboo && hasDots {
            return 三色同順()
        }
        return nil
    }
}
