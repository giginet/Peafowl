import Foundation

public struct 小三元: YakuProtocol {
    public let openedHan: Int? = 2
    public let concealedHan: Int = 2
    
    public let name = "小三元"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 小三元? {
        guard case .melded(let tokens) = form else {
            return nil
        }
        
        let eye = tokens.0
        let eyeDragon: Tile
        if eye.first.isDragon {
            eyeDragon = eye.first
        } else {
            return nil
        }
        
        let triplets = TileUtility.melds(from: tokens).filter { $0.isTriplets }
        let meldDragons = Set(triplets.compactMap { triplet -> Tile? in
            if triplet.first.isDragon && triplet.first != eyeDragon {
                return triplet.first
            }
            return nil
        })
        let dragons = meldDragons.inserted(eyeDragon)
        if dragons.contains(.blank) && dragons.contains(.fortune) && dragons.contains(.center) {
            return 小三元()
        }
        
        return nil
    }
}
