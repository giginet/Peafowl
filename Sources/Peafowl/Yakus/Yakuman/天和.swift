import Foundation

public struct 天和: YakuProtocol {
    public let openedHan: Int? = nil
    public let concealedHan: Int = 13
    
    public let name = "天和"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 天和? {
        if context.isDealer && context.pickedSource == .firstTile {
            return 天和()
        }
        return nil
    }
}
