//
//  Peg.swift
//  Peggle
//
//  Created by proglab on 1/2/24.
//

import Foundation

struct Peg: PeggleObject, Hashable, Identifiable, Codable {
    private(set) var id = UUID()
    let pegType: PegType
    var center: CGPoint
    let radius: Double
    var diameter: Double {
        radius * 2
    }
    var minX: CGFloat {
        center.x - radius
    }
    var maxX: CGFloat {
        center.x + radius
    }
    var minY: CGFloat {
        center.y - radius
    }
    var maxY: CGFloat {
        center.y + radius
    }

    func accept(_ visitor: OverlapVisitor) -> Bool {
        visitor.checkOverlap(with: self)
    }

    func checkOverlap(with block: Block) -> Bool {
        // Find the closest point on the block to the circle's center
        let closestX = max(block.minX, min(center.x, block.maxX))
        let closestY = max(block.minY, min(center.y, block.maxY))

        // Calculate the distance between the circle's center and this closest point
        let distanceX = center.x - closestX
        let distanceY = center.y - closestY
        let distanceSquared = distanceX * distanceX + distanceY * distanceY

        // If the distance is less than the circle's radius, they overlap
        return distanceSquared <= (radius * radius)
    }

    func checkOverlap(with peg: Peg) -> Bool {
        let distance = self.center.distance(to: peg.center)
        let combinedRadius = radius + peg.radius
        return distance < combinedRadius
    }

    mutating func moveCenter(to newCenter: CGPoint) {
        center = newCenter
    }
}
