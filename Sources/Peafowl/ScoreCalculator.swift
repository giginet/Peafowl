import Foundation

public struct GameContext {
    public enum WinningType {
        case selfPick
        case rob
    }
    public enum PickedSource {
        case regular
        case lastTile
        case deadWall
    }
    let winningType: WinningType
    let pickedSource: PickedSource
    let isOneShot: Bool
    let isDealer: Bool
}

public struct CalculationSetting {
    var ignoreLimits: Bool
}

public struct Score {
    var han: Int
    var fu: Int
    var yaku: Set<AnyYaku>
    var score: Int
}

public struct ScoreCalculator {
}
