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
                                                  waitingForm: waitingForm.first!,
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
        XCTAssertEqual(score?.value, 32000)
        XCTAssertEqual(score!.rank!, .yakuman(1))
    }
    
    func testMultipleTokens() {
        let hand: Hand = [二萬, 二萬, 三萬, 四萬, 四萬, 五萬, 五萬, 二索, 三索, 四索, 二筒, 三筒, 四筒, 三萬]
        let context = makeContext()
        let scores = scoreCalculator.calculateAllAvailableScores(with: hand, context: context)
        XCTAssertEqual(scores?.count, 2)
        let yaku = scores!.map { $0.yaku }
        XCTAssertTrue(yaku.contains([AnyYaku(断ヤオ九()),
                                     AnyYaku(門前清自摸和()),
                                     AnyYaku(一盃口()),
                                     AnyYaku(平和())]))
        XCTAssertTrue(yaku.contains([AnyYaku(断ヤオ九()),
                                     AnyYaku(門前清自摸和()),
                                     AnyYaku(一盃口()),
                                     AnyYaku(三色同順())]))
        
        let highestScore = scoreCalculator.calculate(with: hand, context: context)
        XCTAssertEqual(highestScore?.fan, 4)
        XCTAssertEqual(highestScore?.miniPoint, 30)
        XCTAssertEqual(highestScore?.value, 7700)
        XCTAssertNil(highestScore?.rank)
    }
    
    func testMultipleForms() {
        let hand: Hand = [五筒, 五筒, 二萬, 三萬, 四萬, 二萬, 三萬, 四萬, 二索, 三索, 四索, 二索, 三索, 四索]
        let context = makeContext()
        let scores = scoreCalculator.calculateAllAvailableScores(with: hand, context: context)?.sorted()
        XCTAssertEqual(scores?.count, 2)
        XCTAssertEqual(scores?.first?.yaku, [AnyYaku(断ヤオ九()),
                                             AnyYaku(門前清自摸和()),
                                             AnyYaku(七対子())])
        XCTAssertEqual(scores?.last?.yaku, [AnyYaku(断ヤオ九()),
                                            AnyYaku(門前清自摸和()),
                                            AnyYaku(二盃口()),
                                            AnyYaku(平和())])
        
        let highestScore = scoreCalculator.calculate(with: hand, context: context)
        XCTAssertEqual(highestScore?.fan, 6)
        XCTAssertEqual(highestScore?.miniPoint, 30)
        XCTAssertEqual(highestScore?.value, 12000)
        XCTAssertEqual(highestScore?.rank, .haneman)
    }
    
    func testMultipleMiniPoint() {
        let hand: Hand = [二索, 二索, 三筒, 四筒, 五筒, 一萬, 二萬, 三萬, 三萬, 四萬, 中, 中, 中, 二萬]
        let context = makeContext()
        let scores = scoreCalculator.calculateAllAvailableScores(with: hand, context: context)?.sorted()
        XCTAssertEqual(scores?.count, 2)
        XCTAssertEqual(scores?.first?.yaku, [AnyYaku(門前清自摸和()),
                                             AnyYaku(役牌(1))])
        XCTAssertEqual(scores?.last?.yaku, [AnyYaku(門前清自摸和()),
                                            AnyYaku(役牌(1))])

        XCTAssertEqual(scores?.first?.fan, 2)
        XCTAssertEqual(scores?.first?.miniPoint, 30)
        XCTAssertEqual(scores?.first?.value, 2000)
        XCTAssertNil(scores?.first?.rank)
        
        XCTAssertEqual(scores?.last?.fan, 2)
        XCTAssertEqual(scores?.last?.miniPoint, 40)
        XCTAssertEqual(scores?.last?.value, 2600)
        XCTAssertNil(scores?.last?.rank)
    }
    
    func testSevenPairs() {
        let hand: Hand = [二萬, 二萬, 三索, 三索, 五萬, 五萬, 四筒, 四筒, 六萬, 六萬, 八索, 八索, 七筒, 七筒]
        let score = scoreCalculator.calculate(with: hand, context: context)
        XCTAssertEqual(score?.fan, 4)
        XCTAssertEqual(score?.miniPoint, 25)
        XCTAssertEqual(score?.value, 6400)
        XCTAssertNil(score?.rank)
        XCTAssertEqual(score?.yaku, [AnyYaku(断ヤオ九()),
                                     AnyYaku(門前清自摸和()),
                                     AnyYaku(七対子())])
    }
}
