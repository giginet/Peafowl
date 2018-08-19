import Foundation
import Cocoa

private class BundleIndicator { }

private extension Tile {
    var image: NSImage {
        let bundle = Bundle(for: BundleIndicator.self)
        let path = bundle.path(forResource: String(describing: index), ofType: "png")
        return NSImage(contentsOfFile: path!)!
    }
}

extension Tile: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return image as Any
    }
}

private let tileImageSize = CGSize(width: 32, height: 45)

extension Array: CustomPlaygroundDisplayConvertible where Element == Tile {
    public var playgroundDescription: Any {
        let imageSize = CGSize(width: tileImageSize.width * CGFloat(count), height: tileImageSize.height)
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
        for (i, tile) in self.enumerated() {
            let image = tile.image
            let size = image.size
            var rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            let cgImage = image.cgImage(forProposedRect: &rect, context: context, hints: nil)
            let drawiningRect = CGRect(x: CGFloat(i) * tileImageSize.width,
                                       y: 0,
                                       width: size.width,
                                       height: size.height)
            context?.cgContext.draw(cgImage!, in: drawiningRect)
        }
        return NSImage(cgImage: context!.cgContext.makeImage()!, size: imageSize)
    }
}
