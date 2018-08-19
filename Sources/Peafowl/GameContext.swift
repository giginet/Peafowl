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
    public var winningType: WinningType
    public var pickedSource: PickedSource
    /// 立直
    public var riichiStyle: RiichiStyle?
    /// 一発
    public var isOneShot: Bool
    /// 親
    public var isDealer: Bool
    /// 場風
    public var prevalentWind: Tile
    /// 自風
    public var seatWind: Tile
    /// ドラ
    public var dora: [Tile]
    
    public init(winningType: GameContext.WinningType = .selfPick,
                pickedSource: GameContext.PickedSource = .wall,
                riichiStyle: GameContext.RiichiStyle? = nil,
                isOneShot: Bool = false,
                isDealer: Bool = false,
                isClosed: Bool = false,
                prevalantWind: Tile = 東,
                seatWind: Tile = 東,
                dora: [Tile] = []) {
        self.winningType = winningType
        self.pickedSource = pickedSource
        self.riichiStyle = riichiStyle
        self.isOneShot = isOneShot
        self.isDealer = isDealer
        self.prevalentWind = prevalantWind
        self.seatWind = seatWind
        self.dora = dora
    }
}
