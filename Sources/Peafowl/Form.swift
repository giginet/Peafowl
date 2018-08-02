import Foundation

/// 和了形
public protocol OrdinaryFormedYaku: Yaku where Form == (EyesToken, MeldToken, MeldToken, MeldToken, MeldToken) { }

/// 七対子形
public protocol SevenPairsFormedYaku: Yaku where Form == (EyesToken, EyesToken, EyesToken, EyesToken, EyesToken, EyesToken, EyesToken) { }

/// 国士無双形
public protocol ThirteenOrphansFormedYaku: Yaku where Form == Hand { }
