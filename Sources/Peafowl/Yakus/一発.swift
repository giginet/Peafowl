import Foundation

public struct 一発: YakuProtocol {
    public let openedFan: Int? = nil
    public let concealedFan: Int = 1

    public let name = "一発"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 一発? {
        if context.riichiStyle != nil && context.isOneShot {
            return 一発()
        }
        return nil
    }
}
