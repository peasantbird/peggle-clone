//
//  LevelDesignerBoardViewModelProtocol.swift
//  Peggle
//
//  Created by proglab on 8/2/24.
//

import Foundation

protocol LevelDesignerBoardViewModelProtocol {
    func getPegs() -> [Peg]
    func getBlocks() -> [Block]
    func addSelectedObject(location: CGPoint)
    func setBoardSize(_ size: CGSize)
    func removePegIfDeleteSelected(_ peg: Peg)
    func removePeg(_ peg: Peg)
    func movePeg(_ peg: Peg, to location: CGPoint)
    func removeBlockIfDeleteSelected(_ block: Block)
    func removeBlock(_ block: Block)
    func moveBlock(_ block: Block, to location: CGPoint)
}
