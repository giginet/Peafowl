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
}
