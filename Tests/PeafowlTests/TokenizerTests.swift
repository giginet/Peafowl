import Foundation
import XCTest
@testable import Peafowl

final class TokenizerTests: XCTestCase {
    func testTokenize() {
        let hand0 = [發, 發, 中, 中, 中, 白, 白, 白, 一萬, 一萬, 二萬, 二萬, 三萬, 三萬]
        XCTAssertEqual(Tokenizer().tokenize(from: hand0).count, 1)

        let hand1 = [二萬, 二萬, 三萬, 三萬, 三萬, 四萬, 四萬, 四萬, 五萬, 二索, 三索, 四索, 五筒, 五筒]
        XCTAssertEqual(Tokenizer().tokenize(from: hand1).count, 1)

        let hand2 = [二萬, 二萬, 三萬, 三萬, 四萬, 四萬, 五萬, 五萬, 二索, 三索, 四索, 二筒, 三筒, 四筒]
        XCTAssertEqual(Tokenizer().tokenize(from: hand2).count, 2)
    }

    func testFindEyesTests() {
        XCTAssertEqual(Tokenizer.findEyes(from: [
            🀇, 🀈, 🀇, 🀈, 🀇, 🀈,
            ]).count, 2)
        XCTAssertEqual(Tokenizer.findEyes(from: [
            一筒,
            二筒,
            三筒,
            四筒,
            五筒,
            五筒,
            ]).count, 1)
        XCTAssertEqual(Tokenizer.findEyes(from: [
            1.筒!,
            2.筒!,
            1.筒!,
            2.筒!,
            5.筒!,
            5.筒!,
            ]).count, 3)
        XCTAssertEqual(Tokenizer.findEyes(from: [
            1.筒!,
            1.筒!,
            1.筒!,
            2.筒!,
            2.筒!,
            1.筒!,
            ]).count, 3)
    }

    func testFindTripletMelds() {
        XCTAssertEqual(Tokenizer.findTripletMelds(from: [
            1.筒!,
            1.筒!,
            1.筒!,
            1.筒!,
            .east,
            .east,
            ]).count, 1)
        XCTAssertEqual(Tokenizer.findTripletMelds(from: [
            1.筒!,
            1.筒!,
            1.筒!,
            .east,
            .east,
            .east,
            ]).count, 2)
        XCTAssertEqual(Tokenizer.findTripletMelds(from: [
            1.筒!,
            1.萬!,
            1.筒!,
            .east,
            .center,
            .east,
            ]).count, 0)
    }

    func testFindSequentialMelds() {
        XCTAssertEqual(Tokenizer.findSequentialMelds(from: [
            1.筒!,
            2.筒!,
            3.筒!,
            ]).count, 1)
        XCTAssertEqual(Tokenizer.findSequentialMelds(from: [
            1.筒!,
            2.萬!,
            3.筒!,
            ]).count, 0)
        XCTAssertEqual(Tokenizer.findSequentialMelds(from: [
            1.筒!,
            2.筒!,
            3.筒!,
            4.筒!,
            ]).count, 2)
        XCTAssertEqual(Tokenizer.findSequentialMelds(from: [
            1.筒!,
            2.筒!,
            3.筒!,
            4.筒!,
            5.筒!,
            ]).count, 3)
        XCTAssertEqual(Tokenizer.findSequentialMelds(from: [
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
        XCTAssertEqual(Tokenizer.findSequentialMelds(from: [
            8.筒!,
            9.筒!,
            1.筒!,
            ]).count, 0)
        XCTAssertEqual(Tokenizer.findSequentialMelds(from: [
            1.筒!,
            2.筒!,
            3.筒!,
            1.筒!,
            2.筒!,
            3.筒!,
            ]).count, 1)
        XCTAssertEqual(Tokenizer.findSequentialMelds(from: [
            1.筒!,
            2.筒!,
            3.筒!,
            4.萬!,
            5.萬!,
            6.萬!,
            ]).count, 2)
        XCTAssertEqual(Tokenizer.findSequentialMelds(from: [
            2.筒!,
            3.筒!,
            4.筒!,
            ]).count, 1)
        XCTAssertEqual(Tokenizer.findSequentialMelds(from: [白, 發, 中]).count, 0)
        XCTAssertEqual(Tokenizer.findSequentialMelds(from: [東, 西, 南, 北]).count, 0)
    }
}
