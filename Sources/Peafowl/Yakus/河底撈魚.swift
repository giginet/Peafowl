import Foundation

public struct 河底撈魚: YakuProtocol {
    public let openedHan: Int? = 1
    public let concealedHan: Int = 1
    
    public let name = "河底撈魚"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 河底撈魚? {
        if context.winningType == .rob && context.pickedSource == .lastTile {
            return 河底撈魚()
        }
        return nil
    }
}
