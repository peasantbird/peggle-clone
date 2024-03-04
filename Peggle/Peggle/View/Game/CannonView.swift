//
//  CannonView.swift
//  Peggle
//
//  Created by proglab on 29/2/24.
//

import SwiftUI

struct CannonView: View {
    @ObservedObject var gameViewModel: GameViewModel
    var rotation: Angle {
        let opp = gameViewModel.cannonAimPoint.x - gameViewModel.cannonPosition.x
        let adj = gameViewModel.cannonAimPoint.y -
        gameViewModel.cannonPosition.y
        let angle = -atan(opp / adj)
        return Angle(radians: angle)
    }

    var body: some View {
        Image("cannon")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .rotationEffect(rotation)
            .position(gameViewModel.cannonPosition)
    }
}

#Preview {
    CannonView(gameViewModel: GameViewModel(board: Board()))
}
