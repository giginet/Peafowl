import Foundation

private extension Set where Element: YakuProtocol {
    var closedHan: Int {
        return reduce(0) { $0 + $1.concealedHan }
    }
}

public struct CalculationOptions {
    /// 青天井
    var ignoreLimits: Bool
    
    static let `default`: CalculationOptions = .init(ignoreLimits: false)
}

public struct Score: Comparable {
    public static func == (lhs: Score, rhs: Score) -> Bool {
        return lhs.yaku == rhs.yaku
    }
    
    public static func < (lhs: Score, rhs: Score) -> Bool {
        return lhs.basicScore < rhs.basicScore
    }
    
    public enum Rank {
        case mangan
        case haneman
        case baiman
        case sanbaiman
        case yakuman(Int)
    }
    
    var han: Int
    var fu: Int
    var yaku: Set<AnyYaku>
    var basicScore: Double
    var score: Int
    
    init(yaku: Set<AnyYaku>, fu: Int) {
        self.fu = fu
        self.yaku = yaku
        self.han = yaku.closedHan
        self.basicScore = calculateScore(from: fu, and: han)
        self.score = Int(basicScore) // TODO
    }
    
    var rank: Rank? {
        switch han {
        case 0..<5:
            return nil
        case 5:
            return .mangan
        case 6...7:
            return .haneman
        case 8...10:
            return .baiman
        case 10...12:
            return .sanbaiman
        default:
            return .yakuman(Int(floorf(Float(han) / 13.0)))
        }
    }
}

private func calculateScore(from fu: Int, and han: Int) -> Double {
    return Double(fu) * Double(pow(2, Double(2 + han)))
}

internal struct PointCulculator {
    private func ceilToNearest(_ base: Int, _ value: Int) -> Int {
        return Int(ceilf(Float(value) / Float(base)) * Float(base))
    }
    
    var enableCeiling: Bool
    
    func calculateMiniPoint(_ hand: Hand,
                            winningForm: WinningForm,
                            waitingForm: WaitingForm,
                            context: GameContext) -> Int? {
        switch winningForm {
        case .melded(let tokens):
            let basePoint = 20
            let triplets = TileUtility.melds(from: tokens).filter { $0.isTriplets }
            let eye = tokens.0
            let meldBonusPoints: Int = triplets.reduce(0) { (previousPoint, meld) -> Int in
                let baseMeldBonusPoint: Int
                if meld.isConcealed {
                    baseMeldBonusPoint = 4
                } else {
                    baseMeldBonusPoint = 2
                }
                if meld.first.isYaochu {
                    return previousPoint + baseMeldBonusPoint * 2
                } else {
                    return previousPoint + baseMeldBonusPoint
                }
            }
            let eyeBonusPoint = TileUtility.isValueHonor(eye.first, by: context) ? 2 : 0
            let waitingBonusPoint: Int
            switch waitingForm {
            case .middleTile, .singleSide, .singleTile:
                waitingBonusPoint = 2
            case .bothSides, .eitherOfMelds:
                waitingBonusPoint = 0
            }
            
            let concealedAndRobbedBonus = TileUtility.isConcealed(winningForm) && context.winningType == .rob ? 10 : 0
            let selfPickedBonus = context.winningType == .selfPick ? 2 : 0
            let rawPoint = basePoint + meldBonusPoints + eyeBonusPoint + waitingBonusPoint + concealedAndRobbedBonus + selfPickedBonus
            if enableCeiling {
                return ceilToNearest(10, rawPoint)
            } else {
                return rawPoint
            }
        case .sevenPairs:
            return 25
        case .thirteenOrphans:
            return 0
        }
    }
}

private let availableFormedYakuTypes = [
    AnyYakuType(海底摸月.self),
    AnyYakuType(清一色.self),
    AnyYakuType(対々和.self),
    AnyYakuType(ダブル立直.self),
    AnyYakuType(一気通貫.self),
    AnyYakuType(三暗刻.self),
    AnyYakuType(ドラ.self),
    AnyYakuType(一盃口.self),
    AnyYakuType(混全帯么九.self),
    AnyYakuType(嶺上開花.self),
    AnyYakuType(純全帯么九.self),
    AnyYakuType(門前清自摸和.self),
    AnyYakuType(立直.self),
    AnyYakuType(断ヤオ九.self),
    AnyYakuType(河底撈魚.self),
    AnyYakuType(三色同順.self),
    AnyYakuType(混老頭.self),
    AnyYakuType(役牌.self),
    AnyYakuType(一発.self),
    AnyYakuType(小三元.self),
    AnyYakuType(三色同刻.self),
    AnyYakuType(七対子.self),
    AnyYakuType(二盃口.self),
    AnyYakuType(平和.self),
    AnyYakuType(混一色.self),
    AnyYakuType(大四喜.self),
    AnyYakuType(清老頭.self),
    AnyYakuType(国士無双.self),
    AnyYakuType(字一色.self),
    AnyYakuType(緑一色.self),
    AnyYakuType(大三元.self),
    AnyYakuType(小四喜.self),
    AnyYakuType(四暗刻.self),
    AnyYakuType(九連宝燈.self),
    AnyYakuType(地和.self),
    AnyYakuType(天和.self),
]

public class ScoreCalculator {
    private let calculationOptions: CalculationOptions
    
    init(options: CalculationOptions) {
        calculationOptions = options
    }
    
    private let winningDetector = WinningDetector()
    
    func calculate(with hand: Hand, context: GameContext) -> [Score]? {
        guard hand.allTiles.count == 14 else {
            return nil
        }
        
        guard let forms = winningDetector.detectForms(hand.allTiles) else {
            return nil
        }
        
        func checkFormedYaku(hand: Hand, winningForm: WinningForm, picked: Tile) -> Set<AnyYaku> {
            let winningYaku: Set<AnyYaku> = Set(availableFormedYakuTypes.map { type in
                return type.make(with: hand.allTiles,
                                 form: winningForm,
                                 picked: picked,
                                 context: context)
                }.compactMap { $0 })
            return winningYaku
        }
        
        return forms.reduce([]) { (scores, form) -> [Score] in
            switch form {
            case .melded(let winningForm):
                let winningYaku = checkFormedYaku(hand: hand, winningForm: .melded(winningForm), picked: hand.picked)
                return [Score(yaku: winningYaku, fu: 0)]
            case .sevenPairs:
                let winningYaku: Set<AnyYaku>
                if let yaku = 七対子.make(with: hand.allTiles, form: .sevenPairs, picked: hand.picked, context: context) {
                    winningYaku = [AnyYaku(yaku)]
                } else {
                    winningYaku = []
                }
                let otherYaku = checkFormedYaku(hand: hand, winningForm: .sevenPairs, picked: hand.picked)
                return scores + [Score(yaku: winningYaku.union(otherYaku), fu: 25)]
            case .thirteenOrphans:
                let winningYaku: Set<AnyYaku>
                if let yaku = 国士無双.make(with: hand.allTiles, form: .thirteenOrphans, picked: hand.picked, context: context) {
                    winningYaku = [AnyYaku(yaku)]
                } else {
                    winningYaku = []
                }
                return scores + [Score(yaku: winningYaku, fu: 25)]
            }
        }
    }
}
