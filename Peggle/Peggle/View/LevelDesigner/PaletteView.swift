//
//  PaletteView.swift
//  Peggle
//
//  Created by proglab on 5/2/24.
//

import SwiftUI

struct PaletteView: View {
    var levelDesignerViewModel: PaletteViewModelProtocol

    private static let selectedOpacity = 1.0
    private static let unselectedOpacity = 0.2

    var body: some View {
        HStack {
            makeBluePegButton()
            makeOrangePegButton()
            makeGreenPegButton()
            makeGreyPegButton()
            makeBlockButton()
            Spacer()
            makeDeleteButton()
        }
        .padding(.horizontal)
    }

    private func makeBluePegButton() -> some View {
        Image("peg-blue")
            .onTapGesture {
                levelDesignerViewModel.selectAddBluePegAction()
            }
            .opacity(levelDesignerViewModel.selectedAction == .addBluePeg
                     ? PaletteView.selectedOpacity
                     : PaletteView.unselectedOpacity)
    }

    private func makeOrangePegButton() -> some View {
        Image("peg-orange")
            .onTapGesture {
                levelDesignerViewModel.selectAddOrangePegAction()
            }
            .opacity(levelDesignerViewModel.selectedAction == .addOrangePeg
                     ? PaletteView.selectedOpacity
                     : PaletteView.unselectedOpacity)
    }

    private func makeGreenPegButton() -> some View {
        Image("peg-green")
            .onTapGesture {
                levelDesignerViewModel.selectAddGreenPegAction()
            }
            .opacity(levelDesignerViewModel.selectedAction == .addGreenPeg
                     ? PaletteView.selectedOpacity
                     : PaletteView.unselectedOpacity)
    }

    private func makeGreyPegButton() -> some View {
        Image("peg-grey")
            .onTapGesture {
                levelDesignerViewModel.selectAddGreyPegAction()
            }
            .opacity(levelDesignerViewModel.selectedAction == .addGreyPeg
                     ? PaletteView.selectedOpacity
                     : PaletteView.unselectedOpacity)
    }

    private func makeBlockButton() -> some View {
        Image("block")
            .resizable()
            .frame(width: 128, height: 128)
            .onTapGesture {
                levelDesignerViewModel.selectAddBlockAction()
            }
            .opacity(levelDesignerViewModel.selectedAction == .addBlock
                     ? PaletteView.selectedOpacity
                     : PaletteView.unselectedOpacity)
    }

    private func makeDeleteButton() -> some View {
        Image("delete")
            .resizable()
            .frame(width: 128, height: 128)
            .onTapGesture {
                levelDesignerViewModel.selectDeleteAction()
            }
            .opacity(levelDesignerViewModel.selectedAction == .delete
                     ? PaletteView.selectedOpacity
                     : PaletteView.unselectedOpacity)
    }
}

#Preview {
    PaletteView(levelDesignerViewModel: LevelDesignerViewModel())
}
