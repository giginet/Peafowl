import Foundation

public struct 地和: YakuProtocol {
    public let openedFan: Int? = nil
    public let concealedFan: Int = 13
    
    public let name = "地和"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 地和? {
        if !context.isDealer && context.pickedSource == .firstTile {
            return 地和()
        }
        return nil
    }
}
