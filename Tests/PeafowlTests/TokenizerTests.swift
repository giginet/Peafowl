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
            一筒,
            二筒,
            三筒,
            四筒,
            五筒,
            五筒,
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
    
    func testFindTripletMelds() {
        XCTAssertEqual(findTripletMelds(from: [
            1.筒!,
            1.筒!,
            1.筒!,
            1.筒!,
            .east,
            .east,
            ]).count, 1)
        XCTAssertEqual(findTripletMelds(from: [
            1.筒!,
            1.筒!,
            1.筒!,
            .east,
            .east,
            .east,
            ]).count, 2)
        XCTAssertEqual(findTripletMelds(from: [
            1.筒!,
            1.萬!,
            1.筒!,
            .east,
            .center,
            .east,
            ]).count, 0)
    }
    
    func testFindSequentialMelds() {
        XCTAssertEqual(findSequentialMelds(from: [
            1.筒!,
            2.筒!,
            3.筒!,
            ]).count, 1)
        XCTAssertEqual(findSequentialMelds(from: [
            1.筒!,
            2.萬!,
            3.筒!,
            ]).count, 0)
        XCTAssertEqual(findSequentialMelds(from: [
            1.筒!,
            2.筒!,
            3.筒!,
            4.筒!,
            ]).count, 2)
        XCTAssertEqual(findSequentialMelds(from: [
            1.筒!,
            2.筒!,
            3.筒!,
            4.筒!,
            5.筒!,
            ]).count, 3)
        XCTAssertEqual(findSequentialMelds(from: [
            1.筒!,
            2.筒!,
            3.筒!,
            4.筒!,
            5.筒!,
            6.筒!,
            7.筒!,
            8.筒!,
            9.筒!,
            ]).count, 7)
        XCTAssertEqual(findSequentialMelds(from: [
            8.筒!,
            9.筒!,
            1.筒!,
            ]).count, 0)
        XCTAssertEqual(findSequentialMelds(from: [
            1.筒!,
            2.筒!,
            3.筒!,
            1.筒!,
            2.筒!,
            3.筒!,
            ]).count, 1)
        XCTAssertEqual(findSequentialMelds(from: [
            1.筒!,
            2.筒!,
            3.筒!,
            4.萬!,
            5.萬!,
            6.萬!,
            ]).count, 2)
        XCTAssertEqual(findSequentialMelds(from: [白, 撥, 中]).count, 0)
        XCTAssertEqual(findSequentialMelds(from: [東, 西, 南, 北]).count, 0)
    }
}
