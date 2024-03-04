//
//  Board.swift
//  Peggle
//
//  Created by proglab on 1/2/24.
//

import Foundation

@Observable
class Board: Codable {
    var blocks: Set<Block> = Set()
    var pegs: Set<Peg> = Set()
    var size = CGSize.zero

    func setSize(_ size: CGSize) {
        self.size = size
    }

    func addBlock(_ block: Block) {
        guard !hasOverlapWithExistingObjects(block) else {
            return
        }

        guard isWithinBounds(block) else {
            return
        }

        blocks.insert(block)
    }

    func removeBlock(_ block: Block) {
        blocks.remove(block)
    }

    func moveBlock(_ block: Block, to location: CGPoint) {
        guard blocks.contains(block) else {
            return
        }

        var movedBlock = block
        movedBlock.moveCenter(to: location)
        blocks.remove(block)

        guard !hasOverlapWithExistingObjects(movedBlock) else {
            blocks.insert(block)
            return
        }

        guard isWithinBounds(movedBlock) else {
            blocks.insert(block)
            return
        }

        blocks.insert(movedBlock)
    }

    func addPeg(_ peg: Peg) {
        guard !hasOverlapWithExistingObjects(peg) else {
            return
        }

        guard isWithinBounds(peg) else {
            return
        }

        pegs.insert(peg)
    }

    func removePeg(_ peg: Peg) {
        pegs.remove(peg)
    }

    func movePeg(_ peg: Peg, to location: CGPoint) {
        guard pegs.contains(peg) else {
            return
        }

        var movedPeg = peg
        movedPeg.moveCenter(to: location)
        pegs.remove(peg)

        guard !hasOverlapWithExistingObjects(movedPeg) else {
            pegs.insert(peg)
            return
        }

        guard isWithinBounds(movedPeg) else {
            pegs.insert(peg)
            return
        }

        pegs.insert(movedPeg)
    }

    private func hasOverlapWithExistingObjects(_ peggleObject: PeggleObject) -> Bool {
        for existingPeg in pegs where peggleObject.checkOverlap(with: existingPeg) {
            return true
        }
        for existingBlock in blocks where peggleObject.checkOverlap(with: existingBlock) {
            return true
        }
        return false
    }

    private func isWithinBounds(_ peggleObject: PeggleObject) -> Bool {
        let minX = peggleObject.minX
        let maxX = peggleObject.maxX
        let minY = peggleObject.minY
        let maxY = peggleObject.maxY

        return minX >= 0 && maxX <= size.width && minY >= 0 && maxY <= size.height
    }

    func clearBoard() {
        pegs.removeAll()
        blocks.removeAll()
    }
}
