import Foundation

public struct 小四喜: YakuProtocol {
    public let openedHan: Int? = 13
    public let concealedHan: Int = 13
    
    public let name = "小四喜"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 小四喜? {
        guard case .melded(let tokens) = form else {
            return nil
        }
        let eye = tokens.0
        let melds = TileUtility.melds(from: tokens)
        var winds = Set<Tile>()
        for meld in melds where meld.isTriplets && meld.first.isWind {
            winds.insert(meld.first)
        }
        if winds.count == 3 {
            if eye.first.isWind {
                winds.insert(eye.first)
                if winds.count == 4 {
                    return 小四喜()
                }
            }
        }
        
        return nil
    }
}
