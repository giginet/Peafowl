import Foundation
import Cocoa

private class BundleIndicator { }

private extension Tile {
    var image: NSImage {
        let bundle = Bundle(for: BundleIndicator.self)
        guard let path = bundle.path(forResource: String(describing: index), ofType: "png") else {
            fatalError("\(index).png is not found")
        }
        return NSImage(contentsOfFile: path)!
    }
}

extension Tile: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return image as Any
    }
}

private let tileImageSize = CGSize(width: 32, height: 45)

private func createTilesImage(of tiles: [Tile], lastTileOffset: CGFloat = 0) -> NSImage {
    let tileCount = tiles.count
    let imageSize = CGSize(width: tileImageSize.width * CGFloat(tileCount) + lastTileOffset, height: tileImageSize.height)
    let offscreenRep = NSBitmapImageRep(bitmapDataPlanes: nil,
                                        pixelsWide: Int(imageSize.width),
                                        pixelsHigh: Int(imageSize.height),
                                        bitsPerSample: 8,
                                        samplesPerPixel: 4,
                                        hasAlpha: true,
                                        isPlanar: false,
                                        colorSpaceName: .deviceRGB,
                                        bitmapFormat: .alphaFirst,
                                        bytesPerRow: 0,
                                        bitsPerPixel: 0)!
    let context = NSGraphicsContext(bitmapImageRep: offscreenRep)
    for (i, tile) in tiles.enumerated() {
        let image = tile.image
        let size = image.size
        var rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let cgImage = image.cgImage(forProposedRect: &rect, context: context, hints: nil) else { continue }
        let beginningX: CGFloat
        if i == tileCount - 1 {
            beginningX = CGFloat(i) * tileImageSize.width + lastTileOffset
        } else {
            beginningX = CGFloat(i) * tileImageSize.width
        }
        let drawiningRect = CGRect(x: beginningX,
                                   y: 0,
                                   width: size.width,
                                   height: size.height)
        context?.cgContext.draw(cgImage, in: drawiningRect)
    }
    return NSImage(cgImage: context!.cgContext.makeImage()!, size: imageSize)
}

extension Array: CustomPlaygroundDisplayConvertible where Element == Tile {
    public var playgroundDescription: Any {
        return createTilesImage(of: self)
    }
}

extension Hand: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return createTilesImage(of: allTiles, lastTileOffset: 10)
    }
}
