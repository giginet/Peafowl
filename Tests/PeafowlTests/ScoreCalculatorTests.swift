import Foundation
import XCTest
@testable import Peafowl

extension Hand: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Tile
    
    public init(arrayLiteral elements: Hand.ArrayLiteralElement...) {
        let picked = elements.last
        self = .init(tiles: Array(elements.dropLast()), drawed: picked)
    }
}

final class ScoreCalculatorTests: XCTestCase {
    let scoreCalculator = ScoreCalculator(options: .default)
    let context = GameContext(winningType: .selfPick,
                              pickedSource: .wall,
                              isOneShot: false,
                              isDealer: false,
                              isClosed: true)
    
    func testSevenPairs() {
        let hand: Hand = [一萬, 一萬, 三索, 三索, 五萬, 五萬, 四筒, 四筒, 六萬, 六萬, 八索, 八索, 中, 中]
        let scores = scoreCalculator.calculate(with: hand, context: context)
        XCTAssertEqual(scores?.count, 1)
        XCTAssertEqual(scores!.first!.yaku, [AnyYaku(七対子())])
    }
}
