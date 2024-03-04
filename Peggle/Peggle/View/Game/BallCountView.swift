//
//  BallCountView.swift
//  Peggle
//
//  Created by proglab on 2/3/24.
//

import SwiftUI

struct BallCountView: View {
    @ObservedObject var gameViewModel: GameViewModel

    var body: some View {
        HStack {
            Image("ball")
                .resizable()
                .frame(width: 30, height: 30)
            Text("\(gameViewModel.ballsLeft) Balls Left")
                .font(.title3)
        }
        .position(CGPoint(x: 90, y: 10))
    }
}

#Preview {
    BallCountView(gameViewModel: GameViewModel(board: Board()))
}
