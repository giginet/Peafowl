import Foundation

public struct 一発: YakuProtocol {
    public let openedHan: Int? = nil
    public let closedHan: Int = 1
    
    public let name = "一発"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 一発? {
        if context.isRiichi && context.isOneShot {
            return 一発()
        }
        return nil
    }
}
