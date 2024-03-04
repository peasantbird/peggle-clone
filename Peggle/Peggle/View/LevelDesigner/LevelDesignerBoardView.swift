//
//  BoardView.swift
//  Peggle
//
//  Created by proglab on 1/2/24.
//

import SwiftUI

struct LevelDesignerBoardView: View {
    var levelDesignerViewModel: LevelDesignerBoardViewModelProtocol

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                ForEach(levelDesignerViewModel.getPegs()) { peg in
                    makePegView(peg)
                }
                ForEach(levelDesignerViewModel.getBlocks()) { block in
                    makeBlockView(block)
                }
            }
            .onTapGesture { location in
                levelDesignerViewModel.addSelectedObject(location: location)
            }
            .onAppear(perform: {
                levelDesignerViewModel.setBoardSize(geometry.size)
            })
        }
    }

    private func makePegView(_ peg: Peg) -> some View {
        PegView(peg: peg)
            .onTapGesture {
                levelDesignerViewModel.removePegIfDeleteSelected(peg)
            }
            .onLongPressGesture(perform: {
                levelDesignerViewModel.removePeg(peg)
            })
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        levelDesignerViewModel.movePeg(peg, to: gesture.location)
                    }
            )
    }

    private func makeBlockView(_ block: Block) -> some View {
        BlockView(block: block)
            .onTapGesture {
                levelDesignerViewModel.removeBlockIfDeleteSelected(block)
            }
            .onLongPressGesture(perform: {
                levelDesignerViewModel.removeBlock(block)
            })
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        levelDesignerViewModel.moveBlock(block, to: gesture.location)
                    }
            )
    }
}

#Preview {
    LevelDesignerBoardView(levelDesignerViewModel: LevelDesignerViewModel())
}
