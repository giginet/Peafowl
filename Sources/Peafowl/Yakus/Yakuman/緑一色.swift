import Foundation

public struct 緑一色: YakuProtocol {
    public let openedHan: Int? = 13
    public let concealedHan: Int = 13
    
    public let name = "緑一色"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 緑一色? {
        if tiles.allSatisfy({ $0.isGreen }) {
            return 緑一色()
        }
        return nil
    }
}
