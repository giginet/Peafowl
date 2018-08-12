import Foundation
import XCTest
@testable import Peafowl

final class YakuTests: XCTestCase {
    private let tokenizer = Tokenizer()
    
    private func searchWinningYaku<Yaku: YakuProtocol>(_ yaku: Yaku.Type, hand: Hand) -> [Yaku] {
        let tokenizedResults = tokenizer.tokenize(from: hand.allTiles)
        let yakuList = tokenizedResults.map { tokenizedResult in
            return Yaku.make(with: hand.allTiles,
                             form: Tokenizer.convertToWinningForm(from: tokenizedResult),
                             picked: hand.picked,
                             context: makeContext())
            }.compactMap { $0 }
        return yakuList
    }
    
    private func assert<Yaku: YakuProtocol>(_ hand: Hand, shouldBe yaku: Yaku.Type) {
        let yakuList = searchWinningYaku(yaku, hand: hand)
        XCTAssertFalse(yakuList.isEmpty)
    }
    
    private func assert<Yaku: YakuProtocol>(_ hand: Hand, shouldNotBe yaku: Yaku.Type) {
        let yakuList = searchWinningYaku(yaku, hand: hand)
        XCTAssertTrue(yakuList.isEmpty)
    }
    
    func test断ヤオ() {
        assert([二筒, 二筒, 三索, 四索, 五索, 三筒, 四筒, 五筒, 三萬, 四萬, 五萬, 六索, 七索, 八索], shouldBe: 断ヤオ九.self)
        assert([一筒, 一筒, 三索, 四索, 五索, 三筒, 四筒, 五筒, 三萬, 四萬, 五萬, 六索, 七索, 八索], shouldNotBe: 断ヤオ九.self)
    }
}
