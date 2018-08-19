import Cocoa
import Peafowl

Tile(.east)
1.萬!
三萬

let hand = [二萬, 二萬, 三萬, 四萬, 四萬, 五萬, 五萬, 二索, 三索, 四索, 二筒, 三筒, 四筒, 三萬] as Hand

let scoreCalculator = ScoreCalculator(options: .default)

let context = GameContext()
let score = scoreCalculator.calculate(with: hand, context: context)
let describer = ScoreDescriber()
describer.describe(score!)
