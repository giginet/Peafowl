import Foundation

public struct 海底摸月: YakuProtocol {
    public let openedHan: Int? = 1
    public let closedHan: Int = 1
    
    public let name = "海底摸月"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 海底摸月? {
        if context.winningType == .selfPick && context.pickedSource == .lastTile {
            return 海底摸月()
        }
        return nil
    }
}
