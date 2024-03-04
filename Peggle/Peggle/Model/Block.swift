//
//  Block.swift
//  Peggle
//
//  Created by proglab on 3/3/24.
//

import Foundation

struct Block: PeggleObject, Hashable, Identifiable, Codable {
    private(set) var id = UUID()
    var center: CGPoint
    var width: Double
    var height: Double
    var minX: CGFloat {
        center.x - width / 2
    }
    var maxX: CGFloat {
        center.x + width / 2
    }
    var minY: CGFloat {
        center.y - height / 2
    }
    var maxY: CGFloat {
        center.y + height / 2
    }

    func accept(_ visitor: OverlapVisitor) -> Bool {
        visitor.checkOverlap(with: self)
    }

    func checkOverlap(with block: Block) -> Bool {
        // Check if one block is to the side of the other
        if self.maxX < block.minX || block.maxX < self.minX {
            return false
        }

        // Check if one block is above the other
        if self.maxY < block.minY || block.maxY < self.minY {
            return false
        }

        // If none of the above, rectangles are overlapping
        return true
    }

    func checkOverlap(with peg: Peg) -> Bool {
        peg.checkOverlap(with: self)
    }

    mutating func moveCenter(to newCenter: CGPoint) {
        center = newCenter
    }
}
