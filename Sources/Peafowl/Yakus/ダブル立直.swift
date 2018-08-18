import Foundation

public struct ダブル立直: YakuProtocol {
    public let openedFan: Int? = nil
    public let concealedFan: Int = 2
    
    public let name = "ダブル立直"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> ダブル立直? {
        if context.riichiStyle == .double {
            return ダブル立直()
        }
        return nil
    }
}
