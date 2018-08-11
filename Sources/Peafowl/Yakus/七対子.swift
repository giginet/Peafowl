import Foundation

public struct 七対子: YakuProtocol {
    public let openedHan: Int? = nil
    public let closedHan: Int = 2
    
    public let name = "七対子"
    public static func make(with tiles: [Tile], form: WinningForm?, drawed: Tile) -> 七対子? {
        return nil
    }
}
