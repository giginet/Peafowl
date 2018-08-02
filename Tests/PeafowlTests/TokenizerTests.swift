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
    
    func testFindEyesTests() {
        XCTAssertEqual(makeTokenizer([
            🀇, 🀈, 🀇, 🀈, 🀇, 🀈,
            ]).findEyes().count, 2)
        XCTAssertEqual(makeTokenizer([
            1.筒!,
            2.筒!,
            3.筒!,
            4.筒!,
            5.筒!,
            5.筒!,
            ]).findEyes().count, 1)
        XCTAssertEqual(makeTokenizer([
            1.筒!,
            2.筒!,
            1.筒!,
            2.筒!,
            5.筒!,
            5.筒!,
            ]).findEyes().count, 3)
        XCTAssertEqual(makeTokenizer([
            1.筒!,
            1.筒!,
            1.筒!,
            2.筒!,
            2.筒!,
            1.筒!,
            ]).findEyes().count, 3)
    }
    
    func testFindMelds() {
        XCTAssertEqual(findMelds(from: [
            1.筒!,
            1.筒!,
            1.筒!,
            1.筒!,
            .east,
            .east,
            ]).count, 1)
        XCTAssertEqual(findMelds(from: [
            1.筒!,
            1.筒!,
            1.筒!,
            .east,
            .east,
            .east,
        ]).count, 2)
        XCTAssertEqual(findMelds(from: [
            1.筒!,
            1.萬!,
            1.筒!,
            .east,
            .center,
            .east,
            ]).count, 0)
    }
}
