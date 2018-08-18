import Foundation

public struct 清老頭: YakuProtocol {
    public let openedHan: Int? = 13
    public let closedHan: Int = 13
    
    public let name = "清老頭"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 清老頭? {
        if tiles.allSatisfy({ $0.isTerminal }) {
            return 清老頭()
        }
        return nil
    }
}
