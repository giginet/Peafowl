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
        let hand0: Hand = [撥, 撥, 中, 中, 中, 白, 白, 白, 一萬, 一萬, 二萬, 二萬, 三萬, 三萬]
        XCTAssertEqual(OrdinaryFormTokenizer(hand: hand0).tokenize().count, 1)
        
        let hand1: Hand = [二萬, 二萬, 三萬, 三萬, 三萬, 四萬, 四萬, 四萬, 五萬, 二索, 三索, 四索, 五筒, 五筒]
        XCTAssertEqual(OrdinaryFormTokenizer(hand: hand1).tokenize().count, 1)
        
        let hand2: Hand = [二萬, 二萬, 三萬, 三萬, 四萬, 四萬, 五萬, 五萬, 二索, 三索, 四索, 二筒, 三筒, 四筒]
        XCTAssertEqual(OrdinaryFormTokenizer(hand: hand2).tokenize().count, 2)
    }
}
