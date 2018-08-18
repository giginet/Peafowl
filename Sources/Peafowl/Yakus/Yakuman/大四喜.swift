import Foundation

public struct 大四喜: YakuProtocol {
    public let openedFan: Int? = 13
    public let concealedFan: Int = 13

    public let name = "大四喜"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 大四喜? {
        guard case .melded(let tokens) = form else {
            return nil
        }
        let melds = TileUtility.melds(from: tokens)
        let winds = Set(melds.compactMap { meld -> Tile? in
            if meld.isTriplets && meld.first.isWind {
                return meld.first
            }
            return nil
        })
        if winds.count == 4 {
            return 大四喜()
        }

        return nil
    }
}
