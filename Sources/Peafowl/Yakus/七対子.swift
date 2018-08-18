import Foundation

public struct 七対子: YakuProtocol {
    public let openedFan: Int? = nil
    public let concealedFan: Int = 2

    public let name = "七対子"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 七対子? {
        switch form {
        case .sevenPairs:
            let eyes = Tokenizer.findEyes(from: tiles)
            if eyes.unique().count == 7 {
                return 七対子()
            }
        default:
            return nil
        }
        return nil
    }
}
