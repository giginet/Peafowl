import Foundation

private extension Set where Element: YakuProtocol {
    var concealedFan: Int {
        return reduce(0) { $0 + $1.concealedFan }
    }
}

private func calculateScore(from miniPoint: Int, and fan: Int, isDealer: Bool) -> Int {
    let baseScore = Double(miniPoint) * 4 * Double(pow(2, Double(2 + fan)))
    let multiplier = isDealer ? 1.5 : 1.0
    return Int(baseScore * multiplier)
}

private func ceilToNearest(_ base: Int, _ value: Int) -> Int {
    return Int(ceilf(Float(value) / Float(base)) * Float(base))
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

    public enum Rank: Equatable {
        case mangan
        case haneman
        case baiman
        case sanbaiman
        case yakuman(Int)

        var score: Int {
            switch self {
            case .mangan: return 8000
            case .haneman: return 12000
            case .baiman: return 16000
            case .sanbaiman: return 24000
            case .yakuman(let n): return 32000 * n
            }
        }
    }

    var fan: Int
    var miniPoint: Int
    var yaku: Set<AnyYaku>
    var basicScore: Int
    var value: Int {
        return rank?.score ?? Int(basicScore)
    }

    init(yaku: Set<AnyYaku>, miniPoint: Int, isDealer: Bool) {
        self.miniPoint = miniPoint
        self.yaku = yaku
        self.fan = yaku.concealedFan
        self.basicScore = ceilToNearest(100, calculateScore(from: miniPoint, and: fan, isDealer: isDealer))
    }

    var rank: Rank? {
        switch (fan, basicScore) {
        case (0..<5, 0..<8000):
            return nil
        case (_, 8000..<12000):
            return .mangan
        case (6...7, _):
            return .haneman
        case (8...10, _):
            return .baiman
        case (10...12, _):
            return .sanbaiman
        default:
            return .yakuman(Int(floorf(Float(fan) / 13.0)))
        }
    }
}

internal struct PointCulculator {
    var enableCeiling: Bool

    func calculateMiniPoint(_ hand: Hand,
                            winningForm: WinningForm,
                            waitingForm: WaitingForm,
                            context: GameContext) -> Int {
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

private let availableYakuTypes = [
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
    // TODO Currently not working 😛
    private let calculationOptions: CalculationOptions

    init(options: CalculationOptions) {
        calculationOptions = options
    }

    private let winningDetector = WinningDetector()
    private let waitingFormDetector = WaitingFormDetector()
    private let pointCalculator = PointCulculator(enableCeiling: true)

    public func calculate(with hand: Hand, context: GameContext) -> Score? {
        let scores = calculateAllAvailableScores(with: hand, context: context)
        guard let canonicalizedScores = scores?.compactMap({ canonicalizeScore($0, context: context) }) else {
            return nil
        }
        return canonicalizedScores.maxElement()
    }

    private func canonicalizeScore(_ score: Score, context: GameContext) -> Score? {
        if score.yaku.isEmpty {
            return nil
        }
        // A score only contains Dora is not allowed
        if let onlyYaku = score.yaku.first, score.yaku.count == 1 && onlyYaku.type(of: ドラ.self) {
            return nil
        }
        // Reject all other yaku when a score contains Yakuman
        let containsYakuman = score.yaku.contains { $0.isYakuman }
        if containsYakuman {
            let newYaku = score.yaku.filter { $0.isYakuman }
            let newScore = Score(yaku: newYaku, miniPoint: score.miniPoint, isDealer: context.isDealer)
            return newScore
        }
        // TODO When a hand is opened, Reject all concealed only yaku.
        return score
    }

    internal func calculateAllAvailableScores(with hand: Hand, context: GameContext) -> [Score]? {
        guard hand.allTiles.count == 14 else {
            return nil
        }

        guard let forms = winningDetector.detectForms(hand.allTiles) else {
            return nil
        }

        func checkFormedYaku(hand: Hand, winningForm: WinningForm, picked: Tile) -> Set<AnyYaku> {
            let winningYaku: Set<AnyYaku> = Set(availableYakuTypes.map { type in
                return type.make(with: hand.allTiles,
                                 form: winningForm,
                                 picked: picked,
                                 context: context)
                }.compactMap { $0 })
            return winningYaku
        }

        return forms.reduce([]) { (scores, form) -> [Score] in
            switch form {
            case .melded(let tokens):
                let winningForm: WinningForm = .melded(tokens)
                let winningYaku = checkFormedYaku(hand: hand, winningForm: winningForm, picked: hand.picked)
                let waitingForms = waitingFormDetector.detect(from: winningForm, picked: hand.picked)
                let miniPoints = waitingForms.map { waitingForm in
                    pointCalculator.calculateMiniPoint(hand,
                                                       winningForm: winningForm,
                                                       waitingForm: waitingForm,
                                                       context: context)
                }
                let newScores = miniPoints.map { Score(yaku: winningYaku, miniPoint: $0, isDealer: context.isDealer) }
                return scores + newScores
            case .sevenPairs:
                let winningYaku: Set<AnyYaku>
                if let yaku = 七対子.make(with: hand.allTiles, form: .sevenPairs, picked: hand.picked, context: context) {
                    winningYaku = [AnyYaku(yaku)]
                } else {
                    winningYaku = []
                }
                let otherYaku = checkFormedYaku(hand: hand, winningForm: .sevenPairs, picked: hand.picked)
                return scores + [Score(yaku: winningYaku.union(otherYaku), miniPoint: 25, isDealer: context.isDealer)]
            case .thirteenOrphans:
                let winningYaku: Set<AnyYaku>
                if let yaku = 国士無双.make(with: hand.allTiles, form: .thirteenOrphans, picked: hand.picked, context: context) {
                    winningYaku = [AnyYaku(yaku)]
                } else {
                    winningYaku = []
                }
                return scores + [Score(yaku: winningYaku, miniPoint: 0, isDealer: context.isDealer)]
            }
        }
    }
}
