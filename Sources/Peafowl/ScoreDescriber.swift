import Foundation

public struct ScoreDescriber {
    public init() { }
    
    public func describe(_ score: Score) -> String {
        let yakuList = score.yaku.map { "\($0.name) \($0.concealedFan)" }
        let footer: String
        switch score.rank {
        case .some(.yakuman):
            footer = "役満 \(score.value)点"
        case .none:
            footer = "\(score.miniPoint)符\(score.fan)飜 \(score.value)点"
        case .some(let rank):
            footer = "\(score.miniPoint)符\(score.fan)飜 \(rank) \(score.value)点"
        }
        return """
        \(yakuList.joined(separator: "\n"))
        \(footer)
        """
    }
}
