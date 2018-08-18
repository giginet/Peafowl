import Foundation

public struct 嶺上開花: YakuProtocol {
    public let openedFan: Int? = 1
    public let concealedFan: Int = 1
    
    public let name = "嶺上開花"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 嶺上開花? {
        if context.winningType == .selfPick && context.pickedSource == .deadWall {
            return 嶺上開花()
        }
        return nil
    }
}
