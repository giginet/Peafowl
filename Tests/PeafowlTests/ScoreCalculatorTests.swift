import Foundation
import XCTest
@testable import Peafowl

final class PointCalculatorTests: XCTestCase {
    let pointCalculator = PointCulculator(enableCeiling: false)
    let winningDetector = WinningDetector()
    
    func calculateMiniPoint(of hand: Hand, context: GameContext = makeContext()) -> Int? {
        guard let winningForms = winningDetector.detectForms(hand.allTiles),
            let winningForm = winningForms.first else {
                return nil
        }
        
        let waitingForm = WaitingFormDetector().detect(from: winningForm,
                                                       picked: hand.picked)
        return pointCalculator.calculateMiniPoint(hand,
                                                  winningForm: winningForm,
                                                  waitingForm: waitingForm,
                                                  context: context)
        
    }
    
    func testCalculateMiniPoints() {
        // Test cases http://majandofu.com/fu-calculation
        XCTAssertEqual(calculateMiniPoint(of: [三萬, 三萬, 三萬, 九索, 九索, 九索, 中, 中, 中, 五萬, 六萬, 七萬, 三筒, 三筒]), 44)
        XCTAssertEqual(calculateMiniPoint(of: [一萬, 三萬, 一索, 二索, 三索, 七筒, 八筒, 九筒, 東, 東, 東, 一萬, 一萬, 二萬]), 32)
        XCTAssertEqual(calculateMiniPoint(of: [三萬, 五萬, 六萬, 七萬, 七筒, 八筒, 九筒, 八索, 八索, 八索, 中, 中, 中, 三萬],
                                          context: makeContext(winningType: .rob)), 44)
    }
}

final class ScoreCalculatorTests: XCTestCase {
    let scoreCalculator = ScoreCalculator(options: .default)
    let context = makeContext()
    
    func testCalculateCountedYakumanScore() {
        let hand: Hand = [一筒, 二筒, 三筒, 五筒, 五筒, 五筒, 中, 中, 中, 東, 東, 東, 八筒, 八筒]
        let context = makeContext(riichiStyle: .single, isOneShot: true, dora: [中])
        let score = scoreCalculator.calculate(with: hand, context: context)
        XCTAssertNotNil(score)
        XCTAssertEqual(score?.yaku, [AnyYaku(立直()),
                                     AnyYaku(一発()),
                                     AnyYaku(混一色()),
                                     AnyYaku(役牌(3)),
                                     AnyYaku(ドラ(3)),
                                     AnyYaku(門前清自摸和()),
                                     AnyYaku(三暗刻())])
        XCTAssertEqual(score?.fan, 14)
        XCTAssertEqual(score?.miniPoint, 50)
        XCTAssertEqual(score?.score, 32000)
        XCTAssertEqual(score!.rank!, .yakuman(1))
    }
    
    func testSevenPairs() {
        let hand: Hand = [二萬, 二萬, 三索, 三索, 五萬, 五萬, 四筒, 四筒, 六萬, 六萬, 八索, 八索, 七筒, 七筒]
        let score = scoreCalculator.calculate(with: hand, context: context)
        XCTAssertEqual(score?.fan, 4)
        XCTAssertEqual(score?.miniPoint, 25)
        XCTAssertEqual(score?.score, 6400)
        XCTAssertNil(score?.rank)
        XCTAssertEqual(score?.yaku, [AnyYaku(断ヤオ九()), AnyYaku(門前清自摸和()), AnyYaku(七対子())])
    }
}
