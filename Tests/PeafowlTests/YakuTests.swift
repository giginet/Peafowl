import Foundation
import XCTest
@testable import Peafowl

final class meldedFormedYakuTests: XCTestCase {
    private let tokenizer = Tokenizer()
    
    private func searchWinningYaku<Yaku: YakuProtocol>(_ yaku: Yaku.Type, hand: Hand, context: GameContext) -> [Yaku] {
        let tokenizedResults = tokenizer.tokenize(from: hand.allTiles)
        let yakuList = tokenizedResults.map { tokenizedResult in
            return Yaku.make(with: hand.allTiles,
                             form: .melded(Tokenizer.convertToWinningForm(from: tokenizedResult)!),
                             picked: hand.picked,
                             context: context)
            }.compactMap { $0 }
        return yakuList
    }
    
    private func assert<Yaku: YakuProtocol>(_ hand: Hand, shouldBe yaku: Yaku.Type, context: GameContext? = nil) {
        let yakuList = searchWinningYaku(yaku, hand: hand, context: context ?? makeContext())
        XCTAssertFalse(yakuList.isEmpty)
    }
    
    private func assert<Yaku: YakuProtocol>(_ hand: Hand, shouldNotBe yaku: Yaku.Type, context: GameContext? = nil) {
        let yakuList = searchWinningYaku(yaku, hand: hand, context: context ?? makeContext())
        XCTAssertTrue(yakuList.isEmpty)
    }
    
    private func assert<Yaku: YakuProtocol>(_ eye: (Tile, Tile),
                                            _ meld0: (Tile, Tile, Tile),
                                            _ meld1: (Tile, Tile, Tile),
                                            _ meld2: (Tile, Tile, Tile),
                                            _ meld3: (Tile, Tile, Tile),
                                            shouldBe yaku: Yaku.Type,
                                            context: GameContext? = nil) {
        let hand = makeHand(eye, meld0, meld1, meld2, meld3)
        assert(hand, shouldBe: yaku)
    }
    
    private func assert<Yaku: YakuProtocol>(_ eye: (Tile, Tile),
                                            _ meld0: (Tile, Tile, Tile),
                                            _ meld1: (Tile, Tile, Tile),
                                            _ meld2: (Tile, Tile, Tile),
                                            _ meld3: (Tile, Tile, Tile),
                                            shouldNotBe yaku: Yaku.Type,
                                            context: GameContext? = nil) {
        let hand = makeHand(eye, meld0, meld1, meld2, meld3)
        assert(hand, shouldNotBe: yaku)
    }
    
    func test断ヤオ() {
        assert((二筒, 二筒), (三索, 四索, 五索), (三筒, 四筒, 五筒), (三萬, 四萬, 五萬), (六索, 七索, 八索), shouldBe: 断ヤオ九.self)
        assert((一筒, 一筒), (三索, 四索, 五索), (三筒, 四筒, 五筒), (三萬, 四萬, 五萬), (六索, 七索, 八索), shouldNotBe: 断ヤオ九.self)
    }
    
    func test一盃口() {
        assert((二筒, 二筒), (三索, 四索, 五索), (三索, 四索, 五索), (三萬, 四萬, 五萬), (三萬, 四萬, 五萬), shouldNotBe: 一盃口.self)
        assert((二筒, 二筒), (三索, 四索, 五索), (三索, 四索, 五索), (三萬, 四萬, 五萬), (六索, 七索, 八索), shouldBe: 一盃口.self)
        assert((二筒, 二筒), (三索, 四索, 五索), (四索, 五索, 六索), (三萬, 四萬, 五萬), (六索, 七索, 八索), shouldNotBe: 一盃口.self)
        assert((二筒, 二筒), (三索, 四索, 五索), (三索, 四索, 五索), (三索, 四索, 五索), (六索, 七索, 八索), shouldNotBe: 一盃口.self)
    }
    
    func test二盃口() {
        assert((二筒, 二筒), (三索, 四索, 五索), (三索, 四索, 五索), (三萬, 四萬, 五萬), (三萬, 四萬, 五萬), shouldBe: 二盃口.self)
        assert((二筒, 二筒), (三索, 四索, 五索), (三索, 四索, 五索), (三萬, 四萬, 五萬), (六索, 七索, 八索), shouldNotBe: 二盃口.self)
        assert((二筒, 二筒), (三索, 四索, 五索), (四索, 五索, 六索), (三萬, 四萬, 五萬), (六索, 七索, 八索), shouldNotBe: 二盃口.self)
        assert((二筒, 二筒), (三索, 四索, 五索), (三索, 四索, 五索), (三索, 四索, 五索), (六索, 七索, 八索), shouldNotBe: 二盃口.self)
    }
    
    func test三色同順() {
        assert((二筒, 二筒), (三索, 四索, 五索), (三筒, 四筒, 五筒), (三萬, 四萬, 五萬), (東, 東, 東), shouldBe: 三色同順.self)
        assert((二筒, 二筒), (三索, 四索, 五索), (四筒, 五筒, 六筒), (三萬, 四萬, 五萬), (東, 東, 東), shouldNotBe: 三色同順.self)
    }
    
    func test三色同刻() {
        assert((二筒, 二筒), (三索, 三索, 三索), (三筒, 三筒, 三筒), (三萬, 三萬, 三萬), (東, 東, 東), shouldBe: 三色同刻.self)
        assert((二筒, 二筒), (三索, 四索, 五索), (三筒, 四筒, 五筒), (三萬, 四萬, 五萬), (東, 東, 東), shouldNotBe: 三色同刻.self)
        assert((二筒, 二筒), (三索, 四索, 五索), (四筒, 五筒, 六筒), (三萬, 四萬, 五萬), (東, 東, 東), shouldNotBe: 三色同刻.self)
        assert((二筒, 二筒), (東, 東, 東), (南, 南, 南), (西, 西, 西), (北, 北, 北), shouldNotBe: 三色同刻.self)
    }
    
    func test混老頭() {
        assert((一筒, 一筒), (一索, 一索, 一索), (九筒, 九筒, 九筒), (一萬, 一萬, 一萬), (九索, 九索, 九索), shouldBe: 混老頭.self)
        assert((二筒, 二筒), (一索, 二索, 三索), (七筒, 八筒, 九筒), (一萬, 二萬, 三萬), (九索, 九索, 九索), shouldNotBe: 混老頭.self)
    }
    
    func test混全帯么九() {
        assert((一筒, 一筒), (一索, 二索, 三索), (七筒, 八筒, 九筒), (一萬, 二萬, 三萬), (東, 東, 東), shouldBe: 混全帯么九.self)
        assert((二筒, 二筒), (一索, 二索, 三索), (七筒, 八筒, 九筒), (一萬, 二萬, 三萬), (東, 東, 東), shouldNotBe: 混全帯么九.self)
        assert((二筒, 二筒), (一索, 二索, 三索), (七筒, 八筒, 九筒), (一萬, 二萬, 三萬), (三索, 三索, 三索), shouldNotBe: 混全帯么九.self)
        assert((一筒, 一筒), (一索, 二索, 三索), (七筒, 八筒, 九筒), (一萬, 二萬, 三萬), (九索, 九索, 九索), shouldNotBe: 混全帯么九.self)
    }
    
    func test純全帯么九() {
        assert((一筒, 一筒), (一索, 二索, 三索), (七筒, 八筒, 九筒), (一萬, 二萬, 三萬), (東, 東, 東), shouldNotBe: 純全帯么九.self)
        assert((二筒, 二筒), (一索, 二索, 三索), (七筒, 八筒, 九筒), (一萬, 二萬, 三萬), (東, 東, 東), shouldNotBe: 純全帯么九.self)
        assert((二筒, 二筒), (一索, 二索, 三索), (七筒, 八筒, 九筒), (一萬, 二萬, 三萬), (三索, 三索, 三索), shouldNotBe: 純全帯么九.self)
        assert((一筒, 一筒), (一索, 二索, 三索), (七筒, 八筒, 九筒), (一萬, 二萬, 三萬), (九索, 九索, 九索), shouldBe: 純全帯么九.self)
    }
    
    func test一気通貫() {
        assert((一筒, 一筒), (一索, 二索, 三索), (四索, 五索, 六索), (七索, 八索, 九索), (東, 東, 東), shouldBe: 一気通貫.self)
        assert((一筒, 一筒), (一筒, 二筒, 三筒), (四筒, 五筒, 六筒), (七筒, 八筒, 九筒), (東, 東, 東), shouldBe: 一気通貫.self)
        assert((一筒, 一筒), (一萬, 二萬, 三萬), (四萬, 五萬, 六萬), (七萬, 八萬, 九萬), (東, 東, 東), shouldBe: 一気通貫.self)
        assert((一筒, 一筒), (一索, 二索, 三索), (四索, 五索, 六索), (七索, 八索, 九索), (七索, 八索, 九索), shouldBe: 一気通貫.self)
        assert((一筒, 一筒), (一筒, 二筒, 三筒), (四索, 五索, 六索), (七索, 八索, 九索), (七索, 八索, 九索), shouldNotBe: 一気通貫.self)
        assert((一筒, 一筒), (一筒, 二筒, 三筒), (三索, 四索, 五索), (五索, 六索, 七索), (七索, 八索, 九索), shouldNotBe: 一気通貫.self)
    }
    
    func test小三元() {
        assert((白, 白), (撥, 撥, 撥), (中, 中, 中), (七索, 八索, 九索), (七筒, 八筒, 九筒), shouldBe: 小三元.self)
        assert((撥, 撥), (白, 白, 白), (中, 中, 中), (七索, 八索, 九索), (七筒, 八筒, 九筒), shouldBe: 小三元.self)
        assert((中, 中), (白, 白, 白), (撥, 撥, 撥), (七索, 八索, 九索), (七筒, 八筒, 九筒), shouldBe: 小三元.self)
        assert((一筒, 一筒), (白, 白, 白), (撥, 撥, 撥), (中, 中, 中), (七筒, 八筒, 九筒), shouldNotBe: 小三元.self)
    }
    
    func test混一色() {
        assert((一筒, 一筒), (一索, 二索, 三索), (四索, 五索, 六索), (七索, 八索, 九索), (東, 東, 東), shouldNotBe: 混一色.self)
        assert((一索, 一索), (一索, 二索, 三索), (四索, 五索, 六索), (七索, 八索, 九索), (東, 東, 東), shouldBe: 混一色.self)
        assert((一萬, 一萬), (一萬, 二萬, 三萬), (四萬, 五萬, 六萬), (七萬, 八萬, 九萬), (東, 東, 東), shouldBe: 混一色.self)
        assert((一筒, 一筒), (一筒, 二筒, 三筒), (四筒, 五筒, 六筒), (七筒, 八筒, 九筒), (東, 東, 東), shouldBe: 混一色.self)
        assert((一索, 一索), (一索, 二索, 三索), (四索, 五索, 六索), (七索, 八索, 九索), (八索, 八索, 八索), shouldNotBe: 混一色.self)
        assert((一萬, 一萬), (一萬, 二萬, 三萬), (四萬, 五萬, 六萬), (七萬, 八萬, 九萬), (八萬, 八萬, 八萬), shouldNotBe: 混一色.self)
        assert((一筒, 一筒), (一筒, 二筒, 三筒), (四筒, 五筒, 六筒), (七筒, 八筒, 九筒), (八筒, 八筒, 八筒), shouldNotBe: 混一色.self)
    }
    
    func test清一色() {
        assert((一筒, 一筒), (一索, 二索, 三索), (四索, 五索, 六索), (七索, 八索, 九索), (東, 東, 東), shouldNotBe: 清一色.self)
        assert((一索, 一索), (一索, 二索, 三索), (四索, 五索, 六索), (七索, 八索, 九索), (東, 東, 東), shouldNotBe: 清一色.self)
        assert((一萬, 一萬), (一萬, 二萬, 三萬), (四萬, 五萬, 六萬), (七萬, 八萬, 九萬), (東, 東, 東), shouldNotBe: 清一色.self)
        assert((一筒, 一筒), (一筒, 二筒, 三筒), (四筒, 五筒, 六筒), (七筒, 八筒, 九筒), (東, 東, 東), shouldNotBe: 清一色.self)
        assert((一索, 一索), (一索, 二索, 三索), (四索, 五索, 六索), (七索, 八索, 九索), (八索, 八索, 八索), shouldBe: 清一色.self)
        assert((一萬, 一萬), (一萬, 二萬, 三萬), (四萬, 五萬, 六萬), (七萬, 八萬, 九萬), (八萬, 八萬, 八萬), shouldBe: 清一色.self)
        assert((一筒, 一筒), (一筒, 二筒, 三筒), (四筒, 五筒, 六筒), (七筒, 八筒, 九筒), (八筒, 八筒, 八筒), shouldBe: 清一色.self)
    }
    
    func test三暗刻() {
        assert((一筒, 一筒), (一索, 一索, 一索), (九筒, 九筒, 九筒), (一萬, 一萬, 一萬), (七索, 八索, 九索), shouldBe: 三暗刻.self)
        assert((一筒, 一筒), (一索, 一索, 一索), (九筒, 九筒, 九筒), (一萬, 一萬, 一萬), (九索, 九索, 九索), shouldNotBe: 三暗刻.self)
    }
    
    func test四暗刻() {
        assert((一筒, 一筒), (一索, 一索, 一索), (九筒, 九筒, 九筒), (一萬, 一萬, 一萬), (七索, 八索, 九索), shouldNotBe: 四暗刻.self)
        assert((一筒, 一筒), (一索, 一索, 一索), (九筒, 九筒, 九筒), (一萬, 一萬, 一萬), (九索, 九索, 九索), shouldBe: 四暗刻.self)
    }
    
    func test対々和() {
        assert((一筒, 一筒), (一索, 一索, 一索), (九筒, 九筒, 九筒), (一萬, 一萬, 一萬), (七索, 八索, 九索), shouldNotBe: 対々和.self)
        assert((一筒, 一筒), (一索, 一索, 一索), (九筒, 九筒, 九筒), (一萬, 一萬, 一萬), (九索, 九索, 九索), shouldBe: 対々和.self)
    }
    
    func test字一色() {
        assert((一筒, 一筒), (一索, 一索, 一索), (九筒, 九筒, 九筒), (一萬, 一萬, 一萬), (七索, 八索, 九索), shouldNotBe: 字一色.self)
        assert((一筒, 一筒), (一索, 一索, 一索), (九筒, 九筒, 九筒), (一萬, 一萬, 一萬), (九索, 九索, 九索), shouldNotBe: 字一色.self)
        assert((東, 東), (南, 南, 南), (西, 西, 西), (中, 中, 中), (撥, 撥, 撥), shouldBe: 字一色.self)
    }
    
    func test緑一色() {
        assert((一筒, 一筒), (一索, 一索, 一索), (九筒, 九筒, 九筒), (一萬, 一萬, 一萬), (七索, 八索, 九索), shouldNotBe: 緑一色.self)
        assert((一筒, 一筒), (一索, 一索, 一索), (九筒, 九筒, 九筒), (一萬, 一萬, 一萬), (九索, 九索, 九索), shouldNotBe: 緑一色.self)
        assert((撥, 撥), (二索, 三索, 四索), (六索, 六索, 六索), (八索, 八索, 八索), (二索, 三索, 四索), shouldBe: 緑一色.self)
    }
}

final class SevenPairsFormedYakuTests: XCTestCase {
    private func assert<Yaku: YakuProtocol>(_ pair0: (Tile, Tile),
                                            _ pair1: (Tile, Tile),
                                            _ pair2: (Tile, Tile),
                                            _ pair3: (Tile, Tile),
                                            _ pair4: (Tile, Tile),
                                            _ pair5: (Tile, Tile),
                                            _ pair6: (Tile, Tile),
                                            shouldBe yaku: Yaku.Type,
                                            context: GameContext? = nil) {
        let hand: Hand = [pair0.0, pair0.1, pair1.0, pair1.1, pair2.0, pair2.1, pair3.0, pair3.1,
                          pair4.0, pair4.1, pair5.0, pair5.1, pair6.0, pair6.1]
        let yaku = Yaku.make(with: hand.allTiles,
                             form: .sevenPairs,
                             picked: hand.picked,
                             context: makeContext())
        XCTAssertNotNil(yaku)
    }
    
    private func assert<Yaku: YakuProtocol>(_ pair0: (Tile, Tile),
                                            _ pair1: (Tile, Tile),
                                            _ pair2: (Tile, Tile),
                                            _ pair3: (Tile, Tile),
                                            _ pair4: (Tile, Tile),
                                            _ pair5: (Tile, Tile),
                                            _ pair6: (Tile, Tile),
                                            shouldNotBe yaku: Yaku.Type,
                                            context: GameContext? = nil) {
        let hand: Hand = [pair0.0, pair0.1, pair1.0, pair1.1, pair2.0, pair2.1, pair3.0, pair3.1,
                          pair4.0, pair4.1, pair5.0, pair5.1, pair6.0, pair6.1]
        let yaku = Yaku.make(with: hand.allTiles,
                             form: .sevenPairs,
                             picked: hand.picked,
                             context: makeContext())
        XCTAssertNil(yaku)
    }
    
    func test七対子() {
        assert((東, 東), (南, 南), (西, 西), (北, 北), (白, 白), (撥, 撥), (中, 中), shouldBe: 七対子.self)
        assert((東, 東), (東, 東), (西, 西), (北, 北), (白, 白), (撥, 撥), (中, 中), shouldNotBe: 七対子.self)
    }
    
    func test混老頭() {
        assert((一筒, 一筒), (九索, 九索), (東, 東), (西, 西), (九筒, 九筒), (撥, 撥), (中, 中), shouldBe: 混老頭.self)
    }
}
