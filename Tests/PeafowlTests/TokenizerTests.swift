import Foundation
import XCTest
@testable import Peafowl

final class TokenizerTests: XCTestCase {
    func makeTokenizer(_ tiles: [Tile]) -> Tokenizer {
        var mutableTiles = tiles
        let drawed = mutableTiles.remove(at: 0)
        let hand = Hand(drawed: drawed, tiles: mutableTiles)
        return Tokenizer(hand: hand)
    }
    
    func testFilterEyesTests() {
        XCTAssertEqual(makeTokenizer([
            🀇, 🀈, 🀇, 🀈, 🀇, 🀈,
            ]).filterEyes().count, 2)
        XCTAssertEqual(makeTokenizer([
            1.筒!,
            2.筒!,
            3.筒!,
            4.筒!,
            5.筒!,
            5.筒!,
            ]).filterEyes().count, 1)
        XCTAssertEqual(makeTokenizer([
            1.筒!,
            2.筒!,
            1.筒!,
            2.筒!,
            5.筒!,
            5.筒!,
            ]).filterEyes().count, 3)
    }
}
