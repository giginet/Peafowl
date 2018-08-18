import Foundation

public struct 断ヤオ九: YakuProtocol {
    public let openedHan: Int? = 1 // FIXME
    public let closedHan: Int = 1
    
    public let name = "断ヤオ"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 断ヤオ九? {
        func isNotYaochu(tile: Tile) -> Bool {
            return !tile.isHonor && !tile.isTerminal
        }
        if tiles.allSatisfy(isNotYaochu) {
            return 断ヤオ九()
        }
        return nil
    }
}
