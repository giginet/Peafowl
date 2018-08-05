import Foundation
import XCTest
@testable import Peafowl

final class SevenPairsFormTokenizerTests {
    func testTokenize() {
        let tokenizer = SevenPairsFormTokenizer()
        
        let hand0 = [東, 東, 南, 南, 西, 西, 北, 北, 白, 白, 撥, 撥, 中, 中]
        XCTAssertEqual(tokenizer.tokenize(from: hand0).count, 1)
        
        let hand1 = [東, 東, 東, 東, 西, 西, 北, 北, 白, 白, 撥, 撥, 中, 中]
        XCTAssertEqual(tokenizer.tokenize(from: hand1).count, 0)
    }
}
