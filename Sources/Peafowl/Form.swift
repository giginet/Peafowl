import Foundation

/// 和了形
public protocol OrdinaryFormedYaku: Yaku where Form == (PairToken, SetToken, SetToken, SetToken, SetToken) { }

/// 七対子形
public protocol SevenPairsFormedYaku: Yaku where Form == (PairToken, PairToken, PairToken, PairToken, PairToken, PairToken, PairToken) { }

/// 国士無双形
public protocol ThirteenOrphansFormedYaku: Yaku where Form == Hand { }
