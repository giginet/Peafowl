import Foundation
import XCTest
@testable import Peafowl

final class TokenizerTests: XCTestCase {
    let tokenizer: OrdinaryFormTokenizer = {
        let hand = Hand(drawed: nil, tiles: [])
        return OrdinaryFormTokenizer(hand: hand)
    }()
    
    func testFindEyesTests() {
        XCTAssertEqual(tokenizer.findEyes(from: [
            🀇, 🀈, 🀇, 🀈, 🀇, 🀈,
            ]).count, 2)
        XCTAssertEqual(tokenizer.findEyes(from: [
            一筒,
            二筒,
            三筒,
            四筒,
            五筒,
            五筒,
            ]).count, 1)
        XCTAssertEqual(tokenizer.findEyes(from: [
            1.筒!,
            2.筒!,
            1.筒!,
            2.筒!,
            5.筒!,
            5.筒!,
            ]).count, 3)
        XCTAssertEqual(tokenizer.findEyes(from: [
            1.筒!,
            1.筒!,
            1.筒!,
            2.筒!,
            2.筒!,
            1.筒!,
            ]).count, 3)
    }
    
    func testFindTripletMelds() {
        XCTAssertEqual(tokenizer.findTripletMelds(from: [
            1.筒!,
            1.筒!,
            1.筒!,
            1.筒!,
            .east,
            .east,
            ]).count, 1)
        XCTAssertEqual(tokenizer.findTripletMelds(from: [
            1.筒!,
            1.筒!,
            1.筒!,
            .east,
            .east,
            .east,
            ]).count, 2)
        XCTAssertEqual(tokenizer.findTripletMelds(from: [
            1.筒!,
            1.萬!,
            1.筒!,
            .east,
            .center,
            .east,
            ]).count, 0)
    }
    
    func testFindSequentialMelds() {
        XCTAssertEqual(tokenizer.findSequentialMelds(from: [
            1.筒!,
            2.筒!,
            3.筒!,
            ]).count, 1)
        XCTAssertEqual(tokenizer.findSequentialMelds(from: [
            1.筒!,
            2.萬!,
            3.筒!,
            ]).count, 0)
        XCTAssertEqual(tokenizer.findSequentialMelds(from: [
            1.筒!,
            2.筒!,
            3.筒!,
            4.筒!,
            ]).count, 2)
        XCTAssertEqual(tokenizer.findSequentialMelds(from: [
            1.筒!,
            2.筒!,
            3.筒!,
            4.筒!,
            5.筒!,
            ]).count, 3)
        XCTAssertEqual(tokenizer.findSequentialMelds(from: [
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
        XCTAssertEqual(tokenizer.findSequentialMelds(from: [
            8.筒!,
            9.筒!,
            1.筒!,
            ]).count, 0)
        XCTAssertEqual(tokenizer.findSequentialMelds(from: [
            1.筒!,
            2.筒!,
            3.筒!,
            1.筒!,
            2.筒!,
            3.筒!,
            ]).count, 1)
        XCTAssertEqual(tokenizer.findSequentialMelds(from: [
            1.筒!,
            2.筒!,
            3.筒!,
            4.萬!,
            5.萬!,
            6.萬!,
            ]).count, 2)
        XCTAssertEqual(tokenizer.findSequentialMelds(from: [
            2.筒!,
            3.筒!,
            4.筒!,
            ]).count, 1)
        XCTAssertEqual(tokenizer.findSequentialMelds(from: [白, 撥, 中]).count, 0)
        XCTAssertEqual(tokenizer.findSequentialMelds(from: [東, 西, 南, 北]).count, 0)
    }
}
