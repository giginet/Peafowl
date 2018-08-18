import Foundation

public struct 九連宝燈: YakuProtocol {
    public let openedFan: Int? = nil
    public let concealedFan: Int = 13

    public let name = "九連宝燈"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 九連宝燈? {
        guard case .melded(let tokens) = form else {
            return nil
        }
        let melds = TileUtility.melds(from: tokens)
        func isValid(_ conditions: (Tile) -> Bool) -> Bool {
            if tiles.countIf({ conditions($0) && $0.number == 1 }) != 3 {
                return false
            }
            if tiles.countIf({ conditions($0) && $0.number == 9 }) != 3 {
                return false
            }
            let containsSingles = Set<Tile>(tiles.compactMap { tile in
                if conditions(tile) {
                    return tile
                }
                return nil
            })

            return containsSingles.count == 9
        }
        if isValid({ $0.isCharacter }) || isValid({ $0.isBamboo }) || isValid({ $0.isDots }) {
            return 九連宝燈()
        }
        return nil
    }
}
