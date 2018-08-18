import Foundation

public struct 純全帯么九: YakuProtocol {
    public let openedFan: Int? = 2
    public let concealedFan: Int = 3
    
    public let name = "純チャン"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 純全帯么九? {
        guard case .melded(let tokens) = form else {
            return nil
        }
        
        func isTerminal(_ tile: Tile) -> Bool {
            return tile.isTerminal
        }
        
        if tokens.0.allSatisfy(isTerminal)
            && tokens.1.asArray.contains(where: isTerminal)
            && tokens.2.asArray.contains(where: isTerminal)
            && tokens.3.asArray.contains(where: isTerminal)
            && tokens.4.asArray.contains(where: isTerminal) {
            return 純全帯么九()
        }
        return nil
    }
}
