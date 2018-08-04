import Foundation
import XCTest
@testable import Peafowl

extension Hand: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Tile...) {
        self.init(drawed: nil, tiles: elements)
    }
    
    public typealias ArrayLiteralElement = Tile
    
}

final class TokenizeOrdinaryFormTests: XCTestCase {
    func testTokenize() {
        let hand: Hand = [撥, 撥, 中, 中, 中, 白, 白, 白, 一萬, 一萬, 二萬, 二萬, 三萬, 三萬]
        let forms = Tokenizer(hand: hand).tokenize()
        XCTAssertEqual(forms.count, 1)
    }
}
