import Foundation

public struct 断ヤオ九: YakuProtocol {
    public let openedHan: Int? = 1
    public let closedHan: Int = 1

    public let name = "断ヤオ九"
    public static func make(with tiles: [Tile], form: WinningForm?, drawed: Tile, context: GameContext) -> 断ヤオ九? {
        func isNotYaochu(tile: Tile) -> Bool {
            return !tile.isHonor && !tile.isTerminal
        }
        guard let form = form else {
            return nil
        }
        if form.1.consistOnly(of: isNotYaochu)
            && form.2.consistOnly(of: isNotYaochu)
            && form.3.consistOnly(of: isNotYaochu)
            && form.4.consistOnly(of: isNotYaochu) {
            return 断ヤオ九()
        }
        return nil
    }
}
