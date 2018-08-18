import Foundation

public struct 四暗刻: YakuProtocol {
    public let openedHan: Int? = nil
    public let closedHan: Int = 13
    
    public let name = "四暗刻"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 四暗刻? {
        guard case .melded(let tokens) = form else {
            return nil
        }
        let melds = self.melds(from: tokens)
        if melds.countIf({ $0.isTriplets && $0.isConcealed }) == 4 {
            return 四暗刻()
        }
        return nil
    }
}
