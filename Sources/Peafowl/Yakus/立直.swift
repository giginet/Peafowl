import Foundation

public struct 立直: YakuProtocol {
    public let openedFan: Int? = nil
    public let concealedFan: Int = 1
    
    public let name = "立直"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 立直? {
        if context.riichiStyle == .single {
            return 立直()
        }
        return nil
    }
}
