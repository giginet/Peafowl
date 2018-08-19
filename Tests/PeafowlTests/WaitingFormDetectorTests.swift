import Foundation
import XCTest
@testable import Peafowl

final class WaitingFormDetectorTests: XCTestCase {
    let tokenizer = Tokenizer()
    let waitingFormDetector = WaitingFormDetector()

    func testWaitingFormWithBothSides() {
        let waiting = waitingFormDetector.detect(from: .melded((PairToken((五筒, 五筒))!,
                                                                MeldToken((二萬, 三萬, 四萬))!,
                                                                MeldToken((二萬, 三萬, 四萬))!,
                                                                MeldToken((二索, 三索, 四索))!,
                                                                MeldToken((二索, 三索, 四索))!)), picked: 二萬)
        XCTAssertEqual(waiting, [.bothSides])
    }

    func testWaitingFormWithMiddleTile() {
        let waiting = waitingFormDetector.detect(from: .melded((PairToken((五筒, 五筒))!,
                                                                MeldToken((二萬, 三萬, 四萬))!,
                                                                MeldToken((二萬, 三萬, 四萬))!,
                                                                MeldToken((二索, 三索, 四索))!,
                                                                MeldToken((二索, 三索, 四索))!)), picked: 三萬)
        XCTAssertEqual(waiting, [.middleTile])
    }

    func testWaitingFormWithSingleTile() {
        let waiting = waitingFormDetector.detect(from: .melded((PairToken((五筒, 五筒))!,
                                                                MeldToken((二萬, 三萬, 四萬))!,
                                                                MeldToken((二萬, 三萬, 四萬))!,
                                                                MeldToken((二索, 三索, 四索))!,
                                                                MeldToken((二索, 三索, 四索))!)), picked: 五筒)
        XCTAssertEqual(waiting, [.singleTile])
    }

    func testWaitingFormWithSingleSideAndBothSides() {
        let waiting = waitingFormDetector.detect(from: .melded((PairToken((五筒, 五筒))!,
                                                                MeldToken((一萬, 二萬, 三萬))!,
                                                                MeldToken((三萬, 四萬, 五萬))!,
                                                                MeldToken((一索, 二索, 三索))!,
                                                                MeldToken((一索, 二索, 三索))!)), picked: 三萬)
        XCTAssertEqual(waiting, [.singleSide, .bothSides])
    }

    func testWaitingFormWithEitherOfMelds() {
        let waiting = waitingFormDetector.detect(from: .melded((PairToken((五筒, 五筒))!,
                                                                MeldToken((七筒, 七筒, 七筒))!,
                                                                MeldToken((五索, 五索, 五索))!,
                                                                MeldToken((一索, 二索, 三索))!,
                                                                MeldToken((一索, 二索, 三索))!)), picked: 七筒)
        XCTAssertEqual(waiting, [.eitherOfMelds])
    }
}
