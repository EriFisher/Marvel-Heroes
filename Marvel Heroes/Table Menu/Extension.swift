//  Created by Eric on 10/25/18.
//  Copyright © 2018 App Parents LLC. All rights reserved.
//
//logic to move background image
import CoreGraphics
import SpriteKit

public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

public func += (left: inout CGPoint, right: CGPoint) {
    left = left + right
}
