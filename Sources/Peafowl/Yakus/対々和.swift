import Foundation

public struct 対々和: YakuProtocol {
    public let openedFan: Int? = nil
    public let concealedFan: Int = 2
    
    public let name = "対々和"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 対々和? {
        guard case .melded(let tokens) = form else {
            return nil
        }
        let melds = TileUtility.melds(from: tokens)
        if melds.countIf({ $0.isTriplets }) == 4 && !TileUtility.isConcealed(form) {
            return 対々和()
        }
        return nil
    }
}
