import Foundation

public struct 字一色: YakuProtocol {
    public let openedHan: Int? = 13
    public let closedHan: Int = 13
    
    public let name = "字一色"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 字一色? {
        if tiles.allSatisfy({ $0.isHonor }) {
            return 字一色()
        }
        return nil
    }
}
