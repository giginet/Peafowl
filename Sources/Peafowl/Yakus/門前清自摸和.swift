import Foundation

public struct 門前清自摸和: YakuProtocol {
    public let openedFan: Int? = nil
    public let concealedFan: Int = 1
    
    public let name = "ツモ"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 門前清自摸和? {
        if context.winningType == .selfPick && TileUtility.isConcealed(form) {
            return 門前清自摸和()
        }
        return nil
    }
}
