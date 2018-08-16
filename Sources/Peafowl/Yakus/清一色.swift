import Foundation

public struct 清一色: YakuProtocol {
    public let openedHan: Int? = 5
    public let closedHan: Int = 6
    
    public let name = "清一色"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 清一色? {
        if tiles.allSatisfy({ $0.isCharacter })
            || tiles.allSatisfy({ $0.isBamboo })
            || tiles.allSatisfy({ $0.isDots }) {
            return 清一色()
        }
        return nil
    }
}
