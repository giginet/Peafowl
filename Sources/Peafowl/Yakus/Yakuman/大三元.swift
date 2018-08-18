import Foundation

public struct 大三元: YakuProtocol {
    public let openedFan: Int? = 2
    public let concealedFan: Int = 2
    
    public let name = "大三元"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 大三元? {
        guard case .melded(let tokens) = form else {
            return nil
        }
        
        let triplets = TileUtility.melds(from: tokens).filter { $0.isTriplets }
        func contains(_ honorTile: Tile, in melds: [MeldToken]) -> Bool {
            for meld in melds {
                if meld.isTriplets && meld.allSatisfy { $0 == honorTile } {
                    return true
                }
            }
            return false
        }
        if contains(.blank, in: triplets)
            && contains(.fortune, in: triplets)
            && contains(.center, in: triplets) {
            return 大三元()
        }
        
        return nil
    }
}
