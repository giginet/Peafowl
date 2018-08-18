import Foundation

public struct 断ヤオ九: YakuProtocol {
    public let openedFan: Int? = 1 // FIXME
    public let concealedFan: Int = 1

    public let name = "断ヤオ"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 断ヤオ九? {
        if tiles.allSatisfy({ !$0.isYaochu }) {
            return 断ヤオ九()
        }
        return nil
    }
}
