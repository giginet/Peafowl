import Foundation

/// 和了形
public typealias OrdinaryForm = (EyesToken, MeldToken, MeldToken, MeldToken, MeldToken)
public protocol OrdinaryFormedYaku: Yaku where Form == OrdinaryForm { }

/// 七対子形
public typealias SevenPairsForm = (EyesToken, EyesToken, EyesToken, EyesToken, EyesToken, EyesToken, EyesToken)
public protocol SevenPairsFormedYaku: Yaku where Form == SevenPairsForm { }

/// 国士無双形
public protocol ThirteenOrphansFormedYaku: Yaku where Form == Hand { }
