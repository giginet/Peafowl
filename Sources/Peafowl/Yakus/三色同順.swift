import Foundation

public struct 三色同順: YakuProtocol {
    public let openedFan: Int? = nil
    public let concealedFan: Int = 2
    
    public let name = "三色同順"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 三色同順? {
        guard case .melded(let tokens) = form else {
            return nil
        }
        let melds = [tokens.1, tokens.2, tokens.3, tokens.4]
        let sequentialMelds = melds.filter { $0.isSequential }
        let character = sequentialMelds.first { $0.isCharacter }
        let bamboo = sequentialMelds.first { $0.isBamboo }
        let dots = sequentialMelds.first { $0.isDots }
        if character?.asArray.first?.number == bamboo?.asArray.first?.number
            && dots?.asArray.first?.number == bamboo?.asArray.first?.number {
            return 三色同順()
        }
        return nil
    }
}
