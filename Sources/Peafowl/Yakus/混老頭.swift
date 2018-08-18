import Foundation

public struct 混老頭: YakuProtocol {
    public let openedFan: Int? = 2
    public let concealedFan: Int = 2
    
    public let name = "混老頭"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 混老頭? {
        if tiles.allSatisfy({ $0.isTerminal || $0.isHonor }) && tiles.contains(where: { $0.isHonor }) {
            return 混老頭()
        }
        return nil
    }
}
