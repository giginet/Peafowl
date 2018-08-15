import Foundation

public struct 純全帯么九: YakuProtocol {
    public let openedHan: Int? = 1
    public let closedHan: Int = 2
    
    public let name = "チャンタ"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 純全帯么九? {
        guard case .ordinary(let tokens) = form else {
            return nil
        }
        
        func isTerminal(_ tile: Tile) -> Bool {
            return tile.isTerminal
        }
        
        if tokens.0.consistOnly(of: isTerminal)
            && tokens.1.asArray.contains(where: isTerminal)
            && tokens.2.asArray.contains(where: isTerminal)
            && tokens.3.asArray.contains(where: isTerminal)
            && tokens.4.asArray.contains(where: isTerminal) {
            return 純全帯么九()
        }
        return nil
    }
}
