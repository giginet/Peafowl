import Foundation

public struct 混一色: YakuProtocol {
    public let openedFan: Int? = 2
    public let concealedFan: Int = 3
    
    public let name = "混一色"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 混一色? {
        if tiles.allSatisfy({ $0.isCharacter })
            || tiles.allSatisfy({ $0.isBamboo })
            || tiles.allSatisfy({ $0.isDots }) {
            return nil
        } else if tiles.allSatisfy({ $0.isCharacter || $0.isHonor })
            || tiles.allSatisfy({ $0.isBamboo || $0.isHonor })
            || tiles.allSatisfy({ $0.isDots || $0.isHonor }) {
            return 混一色()
        }
        return nil
    }
}
