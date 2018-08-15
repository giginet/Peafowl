import Foundation

private extension Set where Element: YakuProtocol {
    var closedHan: Int {
        return reduce(0) { $0 + $1.closedHan }
    }
}

public enum WaitingForm {
    /// 両面待ち
    case bothSides
    /// 嵌張待ち
    case middleTile
    /// 辺張待ち
    case singleSide
    /// 単騎待ち
    case singleTile
    /// 双碰待ち
    case eitherOfMelds
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

public enum Rank {
    case mangan
    case haneman
    case baiman
    case sanbaiman
    case yakuman(Int)
}

private func calculateScore(from fu: Int, and han: Int) -> Double {
    return Double(fu) * Double(pow(2, Double(2 + han)))
}

private let availableFormedYakuTypes = [
    AnyYakuType(断ヤオ九.self),
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
