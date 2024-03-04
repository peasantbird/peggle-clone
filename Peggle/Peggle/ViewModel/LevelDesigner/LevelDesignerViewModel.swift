//
//  LevelDesignerViewModel.swift
//  Peggle
//
//  Created by proglab on 6/2/24.
//

import Foundation

@Observable
class LevelDesignerViewModel: ActionButtonsViewModelProtocol, LevelDesignerBoardViewModelProtocol,
                              PaletteViewModelProtocol {
    private(set) var board = Board()
    private(set) var selectedAction: Action = .addBluePeg
    private var addActionMappings: [Action: (CGPoint) -> Peg]

    init() {
        addActionMappings = [
            .addBluePeg: { Peg(pegType: .optional, center: $0, radius: Constants.pegRadius) },
            .addOrangePeg: { Peg(pegType: .compulsory, center: $0, radius: Constants.pegRadius) },
            .addGreenPeg: { Peg(pegType: .powerup, center: $0, radius: Constants.pegRadius) },
            .addGreyPeg: { Peg(pegType: .stubborn, center: $0, radius: Constants.pegRadius) }
        ]
    }

    func selectAddBluePegAction() {
        selectedAction = .addBluePeg
    }

    func selectAddOrangePegAction() {
        selectedAction = .addOrangePeg
    }

    func selectAddGreenPegAction() {
        selectedAction = .addGreenPeg
    }

    func selectAddGreyPegAction() {
        selectedAction = .addGreyPeg
    }

    func selectAddBlockAction() {
        selectedAction = .addBlock
    }

    func selectDeleteAction() {
        selectedAction = .delete
    }

    func clearBoard() {
        board.clearBoard()
    }

    func getPegs() -> [Peg] {
        Array(board.pegs)
    }

    func removePeg(_ peg: Peg) {
        board.removePeg(peg)
    }

    func removePegIfDeleteSelected(_ peg: Peg) {
        if selectedAction == .delete {
            board.removePeg(peg)
        }
    }

    func movePeg(_ peg: Peg, to location: CGPoint) {
        board.movePeg(peg, to: location)
    }

    func addSelectedObject(location: CGPoint) {
        if let actionClosure = addActionMappings[selectedAction] {
            let peg = actionClosure(location)
            board.addPeg(peg)
        } else if selectedAction == .addBlock {
            board.addBlock(Block(center: location, width: Constants.blockWidth, height: Constants.blockHeight))
        }
    }

    func setBoardSize(_ size: CGSize) {
        board.setSize(size)
    }

    func saveBoard(levelName: String) throws {
        try board.save(levelName: levelName)
    }

    func loadBoard(levelName: String) throws {
        board = try board.load(levelName: levelName)
    }

    func getBlocks() -> [Block] {
        Array(board.blocks)
    }

    func removeBlockIfDeleteSelected(_ block: Block) {
        if selectedAction == .delete {
            board.removeBlock(block)
        }
    }

    func removeBlock(_ block: Block) {
        board.removeBlock(block)
    }

    func moveBlock(_ block: Block, to location: CGPoint) {
        board.moveBlock(block, to: location)
    }
}
