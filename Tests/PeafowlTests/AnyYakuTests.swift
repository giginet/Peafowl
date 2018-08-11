import Foundation
import XCTest
@testable import Peafowl

final class AnyYakuTests: XCTestCase {
    func testYaku() {
        let yakus: [AnyYaku] = [AnyYaku(断ヤオ九()),
                                AnyYaku(国士無双(isWaitingHead: true)),
                                AnyYaku(七対子()),]
        XCTAssertEqual(yakus.count, 3)
        XCTAssertEqual(yakus.map { $0.name }, ["断ヤオ九", "国士無双", "七対子"])
    }

    func testEquatable() {
        XCTAssertEqual(AnyYaku(断ヤオ九()), AnyYaku(断ヤオ九()))
        XCTAssertNotEqual(AnyYaku(断ヤオ九()), AnyYaku(七対子()))
    }
}
