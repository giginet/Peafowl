import Foundation

public struct GameContext {
    public enum WinningType {
        /// 自摸
        case selfPick
        /// ロン
        case rob
    }
    public enum PickedSource {
        case firstTile
        /// 山
        case wall
        /// 海底、河底
        case lastTile
        /// 嶺上牌
        case deadWall
    }
    public enum RiichiStyle {
        case single
        case double
    }
    let winningType: WinningType
    let pickedSource: PickedSource
    /// 立直
    let riichiStyle: RiichiStyle?
    /// 一発
    let isOneShot: Bool
    /// 親
    let isDealer: Bool
    /// 場風
    let prevalentWind: Tile
    /// 自風
    let seatWind: Tile
    /// ドラ
    let dora: [Tile]
}
