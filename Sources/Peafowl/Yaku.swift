import Foundation

/// 役
public protocol Yaku {
    associatedtype Form
    
    /// 翻
    var closedHan: Int { get }
    /// 喰い下がり翻
    var openedHan: Int? { get }
    var isYakuman: Bool { get }
    static func make(with tiles: Form, drawed: Tile) -> Self?
}

public extension Yaku {
    var openedHan: Int? {
        return 0
    }
    
    var isYakuman: Bool {
        return closedHan >= 13
    }
}

/// 和了形
public protocol OrdinaryFormedYaku: Yaku where Form == (PairToken, SetToken, SetToken, SetToken, SetToken) { }

/// 七対子形
public protocol SevenPairsFormedYaku: Yaku where Form == (PairToken, PairToken, PairToken, PairToken, PairToken, PairToken, PairToken) { }

/// 国士無双形
public protocol ThirteenOrphansFormedYaku: Yaku where Form == Hand { }
