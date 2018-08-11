import Foundation
import XCTest
import Peafowl

final class TileTests: XCTestCase {
    let tiles: [Tile] = [
        1.筒!,
        5.索!,
        9.萬!,
        .center,
        .blank,
        .north,
        .south,
    ]

    private func assertTiles(_ results: [Bool], checker: (Tile) -> Bool) {
        for (tile, result) in zip(tiles, results) {
            XCTAssertEqual(checker(tile), result)
        }
    }

    func testInitializer() {
        XCTAssertNil(Tile.character(-1))
        XCTAssertNil(Tile.character(0))
        XCTAssertNotNil(Tile.character(1))
        XCTAssertNotNil(Tile.character(9))
        XCTAssertNil(Tile.character(10))
    }

    func testSimple() {
        assertTiles([true, true, true, false, false, false, false]) { $0.isSimple }
    }

    func testHonor() {
        assertTiles([false, false, false, true, true, true, true]) { $0.isHonor }
    }

    func testWind() {
        assertTiles([false, false, false, false, false, true, true]) { $0.isWind }
    }

    func testDragon() {
        assertTiles([false, false, false, true, true, false, false]) { $0.isDragon }
    }

    func testTerminal() {
        assertTiles([true, false, true, false, false, false, false]) { $0.isTerminal }
    }

    func testNext() {
        XCTAssertEqual(1.萬!.next!, 2.萬!)
        XCTAssertNil(9.萬!.next)
        XCTAssertNil(Tile.east.next)
        XCTAssertNil(Tile.center.next)
    }

    func testPrevious() {
        XCTAssertNil(1.萬!.previous)
        XCTAssertEqual(9.萬!.previous, 8.萬!)
        XCTAssertNil(Tile.east.previous)
        XCTAssertNil(Tile.center.previous)
    }
}
