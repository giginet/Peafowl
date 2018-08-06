import Foundation

public struct 断ヤオ九: OrdinaryFormedYaku {
    public let openedHan: Int? = 1
    public let closedHan: Int = 1
    
    public let name = "断ヤオ九"
    public static func make(with tiles: (EyesToken, MeldToken, MeldToken, MeldToken, MeldToken), drawed: Tile) -> 断ヤオ九? {
        func isNotYaochu(tile: Tile) -> Bool {
            return !tile.isHonor && !tile.isTerminal
        }
        if tiles.1.consistOnly(of: isNotYaochu)
            && tiles.2.consistOnly(of: isNotYaochu)
            && tiles.3.consistOnly(of: isNotYaochu)
            && tiles.4.consistOnly(of: isNotYaochu) {
            return 断ヤオ九()
        }
        return nil
    }
}
