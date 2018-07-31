import UIKit

public let 🀇 = 1.萬!
public let 🀈 = 2.萬!
public let 🀉 = 3.萬!
public let 🀊 = 4.萬!
public let 🀋 = 5.萬!
public let 🀌 = 6.萬!
public let 🀍 = 7.萬!
public let 🀎 = 8.萬!
public let 🀏 = 9.萬!
public let 🀐 = 1.索!
public let 🀑 = 2.索!
public let 🀒 = 3.索!
public let 🀓 = 4.索!
public let 🀔 = 5.索!
public let 🀕 = 6.索!
public let 🀖 = 7.索!
public let 🀗 = 8.索!
public let 🀘 = 9.索!
public let 🀙 = 1.筒!
public let 🀚 = 2.筒!
public let 🀛 = 3.筒!
public let 🀜 = 4.筒!
public let 🀝 = 5.筒!
public let 🀞 = 6.筒!
public let 🀟 = 7.筒!
public let 🀠 = 8.筒!
public let 🀡 = 9.筒!
public let 🀀 = Tile.east
public let 🀁 = Tile.south
public let 🀂 = Tile.west
public let 🀃 = Tile.north
public let 🀄 = Tile.center
public let 🀅 = Tile.fortune
public let 🀆 = Tile.blank

public let MarjongTileCharacterSet = { () -> CharacterSet in
    let start = Character("🀀").unicodeScalars.first!
    let end = Character("🀫").unicodeScalars.first!
    let range: ClosedRange<Unicode.Scalar> = start...end
    return CharacterSet(charactersIn: range)
}()
