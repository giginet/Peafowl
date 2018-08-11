import Foundation
import XCTest
import Peafowl

final class PairTokenTests: XCTestCase {
    func testInitialize() {
        XCTAssertNotNil(PairToken((東, 東)))
        XCTAssertNotNil(PairToken((一萬, 二萬)))
        XCTAssertNotNil(PairToken((一萬, 三萬)))
        XCTAssertNotNil(PairToken((五萬, 六萬)))
        
        XCTAssertNil(PairToken((一萬, 二筒)))
        XCTAssertNil(PairToken((一萬, 西)))
    }
    
    func testWaitingTilesForMeld() {
        XCTAssertEqual(PairToken((一萬, 二萬))?.waitingTilesForMeld(), [三萬])
        XCTAssertEqual(PairToken((一萬, 三萬))?.waitingTilesForMeld(), [二萬])
        XCTAssertEqual(PairToken((二萬, 三萬))?.waitingTilesForMeld(), [一萬, 四萬])
        XCTAssertEqual(PairToken((八索, 九索))?.waitingTilesForMeld(), [七索])
        XCTAssertEqual(PairToken((七筒, 九筒))?.waitingTilesForMeld(), [八筒])
        XCTAssertEqual(PairToken((三索, 三索))?.waitingTilesForMeld(), [三索])
        XCTAssertEqual(PairToken((南, 南))?.waitingTilesForMeld(), [南])
    }
}

final class MeldTokenTests: XCTestCase {
    func testInitialize() {
        XCTAssertNil(MeldToken((一萬, 西, 北)))
        XCTAssertNil(MeldToken((一萬, 八萬, 九萬)))
        XCTAssertNil(MeldToken((白, 撥, 中)))
        XCTAssertNotNil(MeldToken((東, 東, 東)))
        XCTAssertNotNil(MeldToken((四索, 六索, 五索)))
    }
    
    func testTriplets() {
        [MeldToken((東, 東, 東)),
         MeldToken((一萬, 一萬, 一萬)),
         MeldToken((九筒, 九筒, 九筒))]
            .forEach { meld in
                guard let meld = meld else { return XCTFail("meld should not be nil") }
                XCTAssertTrue(meld.isTriplets)
        }
    }
    
    func testSequential() {
        [MeldToken((一萬, 二萬, 三萬)),
         MeldToken((六筒, 七筒, 八筒)),
         MeldToken((四索, 六索, 五索))]
            .forEach { meld in
                guard let meld = meld else { return XCTFail("meld should not be nil") }
                XCTAssertTrue(meld.isSequential)
        }
    }
}
