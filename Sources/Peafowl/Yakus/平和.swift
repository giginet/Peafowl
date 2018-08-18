import Foundation

public struct 平和: YakuProtocol {
    public let openedFan: Int? = nil
    public let concealedFan: Int = 1
    
    public let name = "平和"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 平和? {
        guard case .melded(let tokens) = form else {
            return nil
        }
        let eye = tokens.0
        let melds = TileUtility.melds(from: tokens)
        if melds.contains(where: { $0.isTriplets }) {
            return nil
        }
        if TileUtility.isValueHonor(eye.first, by: context) {
            return nil
        }
        for meld in melds where meld.detectWaitingForm(with: picked) == .bothSides {
            return 平和()
        }
        return nil
    }
}
