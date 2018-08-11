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

public struct GameContext {
    public enum WinningType {
        /// 自摸
        case selfPick
        /// ロン
        case rob
    }
    public enum PickedSource {
        /// 山
        case wall
        /// 海底、河底
        case lastTile
        /// 嶺上牌
        case deadWall
    }
    let winningType: WinningType
    let pickedSource: PickedSource
    /// 一発
    let isOneShot: Bool
    /// 親
    let isDealer: Bool
}

public struct CalculationOptions {
    /// 青天井
    var ignoreLimits: Bool
}

public struct Score: Comparable {
    public static func < (lhs: Score, rhs: Score) -> Bool {
        return lhs.basicScore < rhs.basicScore
    }
    
    var han: Int {
        return yaku.reduce(0) { $0 + $1.closedHan }
    }
    var fu: Int
    var yaku: Set<AnyYaku>
    var basicScore: Double
    var score: Int
    
    init(yaku: Set<AnyYaku>, fu: Int, options: CalculationOptions) {
        self.fu = fu
        self.yaku = yaku
        self.basicScore = calculateScore(from: fu, and: yaku.closedHan)
        self.score = Int(basicScore) // TODO
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

public class ScoreCalculator {
    private let calculationOptions: CalculationOptions
    
    init(options: CalculationOptions) {
        calculationOptions = options
    }
    
    private let winningDetector = WinningDetector()
    
    func calculate(with hand: Hand, context: GameContext) -> [Score]? {
        guard let drawed = hand.drawed else {
            return []
        }
        guard hand.allTiles.count == 14 else {
            return []
        }
        
        guard let forms = winningDetector.detectForms(hand.allTiles) else {
            return nil
        }
        return forms.reduce([]) { scores, form in
            var winningYaku: Set<AnyYaku> = []
            switch form {
            case .ordinary(let ordinaryForms):
                break
            case .sevenPairs:
                if let yaku = 七対子.make(with: hand.allTiles, form: nil, drawed: drawed) {
                    winningYaku.insert(AnyYaku(yaku))
                }
                return [Score(yaku: winningYaku, fu: 25, options: calculationOptions)]
            case .thirteenOrphans:
                if let yaku = 国士無双.make(with: hand.allTiles, form: nil, drawed: drawed) {
                    winningYaku.insert(AnyYaku(yaku))
                }
                return [Score(yaku: winningYaku, fu: 25, options: calculationOptions)]
            }
            return nil
        }
    }
}
