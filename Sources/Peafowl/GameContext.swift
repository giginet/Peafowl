import Foundation

public struct GameContext {
    public enum WinningType {
        /// 自摸
        case selfPick
        /// ロン
        case rob
    }
    public enum PickedSource {
        /// 山
        case wall
        /// 海底、河底
        case lastTile
        /// 嶺上牌
        case deadWall
    }
    let winningType: WinningType
    let pickedSource: PickedSource
    /// 立直
    let isRiichi: Bool
    /// 一発
    let isOneShot: Bool
    /// 親
    let isDealer: Bool
    /// 門前
    let isClosed: Bool
}
