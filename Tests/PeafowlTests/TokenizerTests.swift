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

        let hand3 = [二筒, 二筒, 三筒, 三筒, 三筒, 四筒, 四筒, 四筒, 五筒, 五筒, 五筒, 六筒, 六筒, 六筒]
        XCTAssertEqual(Tokenizer().tokenize(from: hand3).count, 4)
    }
}
