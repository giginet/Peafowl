import Foundation

public struct 一気通貫: YakuProtocol {
    public let openedHan: Int? = 1
    public let concealedHan: Int = 2
    
    public let name = "純チャン"
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 一気通貫? {
        guard case .melded(let tokens) = form else {
            return nil
        }
        
        let melds = TileUtility.melds(from: tokens)
        let firstSequence = melds.first { $0.isSequential && $0.first.number == 1 }
        let secondSequence = melds.first { $0.isSequential && $0.first.number == 4 }
        let thirdSequence = melds.first { $0.isSequential && $0.first.number == 7 }
        if firstSequence?.isCharacter == true && secondSequence?.isCharacter == true && thirdSequence?.isCharacter == true
        || firstSequence?.isBamboo == true && secondSequence?.isBamboo == true && thirdSequence?.isBamboo == true
            || firstSequence?.isDots == true && secondSequence?.isDots == true && thirdSequence?.isDots == true {
            return 一気通貫()
        }
        
        return nil
    }
}
