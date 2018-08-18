import Foundation

public struct 三暗刻: YakuProtocol {
    public let openedHan: Int? = 2
    public let concealedHan: Int = 2
    
    public let name = "三暗刻"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 三暗刻? {
        guard case .melded(let tokens) = form else {
            return nil
        }
        let melds = TileUtility.melds(from: tokens)
        if melds.countIf({ $0.isTriplets && $0.isConcealed }) == 3 {
            return 三暗刻()
        }
        return nil
    }
}
