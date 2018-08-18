import Foundation

public struct 国士無双: YakuProtocol {
    public var concealedFan: Int {
        if isWaitingEye {
            return 26
        } else {
            return 13
        }
    }
    public var name: String {
        if isWaitingEye {
            return "国士無双単騎待ち"
        } else {
            return "国士無双"
        }
    }
    public let openedFan: Int? = nil
    public let isWaitingEye: Bool

    internal init(isWaitingEye: Bool) {
        self.isWaitingEye = isWaitingEye
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(isWaitingEye)
    }
    public static func make(with tiles: [Tile], form: WinningForm, picked: Tile, context: GameContext) -> 国士無双? {
        switch form {
        case .thirteenOrphans: break
        default:
            return nil
        }

        let validTiles: Set<Tile> = Set(tiles.compactMap { ($0.isHonor || $0.isTerminal) ? $0 : nil })
        if validTiles.count == 13 {
            let isWaitingEye = tiles.countIf(picked) == 2
            return 国士無双(isWaitingEye: isWaitingEye)
        }
        return nil
    }
}
