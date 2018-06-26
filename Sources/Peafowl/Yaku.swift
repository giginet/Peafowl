import Foundation

/// 役
public protocol Yaku {
    associatedtype Form
    
    var openedHan: Int { get }
    var closedHan: Int? { get }
    func validate(with tiles: Form, drawed: Tile) -> Bool
}

public extension Yaku {
    var closedHan: Int? {
        return 0
    }
}

/// 和了形
public protocol OrdinaryFormedYaku: Yaku where Form == (PairToken, SetToken, SetToken, SetToken, SetToken) { }

/// 七対子形
public protocol SevenPairFormedYaku: Yaku where Form == (PairToken, PairToken, PairToken, PairToken, PairToken, PairToken, PairToken) { }

/// 国士無双形
public protocol ThirteenOrphansFormedYaku: Yaku where Form == Hand { }
