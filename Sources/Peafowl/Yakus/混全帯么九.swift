import Foundation

public struct 混全帯么九: YakuProtocol {
    public let openedHan: Int? = 1
    public let closedHan: Int = 2
    
    public let name = "チャンタ"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 混全帯么九? {
        guard case .ordinary(let tokens) = form else {
            return nil
        }
        
        func isYaochu(_ tile: Tile) -> Bool {
            return tile.isTerminal || tile.isHonor
        }
        
        if tokens.0.consistOnly(of: isYaochu)
            && tokens.1.asArray.contains(where: isYaochu)
            && tokens.2.asArray.contains(where: isYaochu)
            && tokens.3.asArray.contains(where: isYaochu)
            && tokens.4.asArray.contains(where: isYaochu) {
            // If there are no honor tiles, it will be 純チャン.
            if tiles.contains(where: { $0.isHonor }) == false {
                return nil
            }
            return 混全帯么九()
        }
        return nil
    }
}
