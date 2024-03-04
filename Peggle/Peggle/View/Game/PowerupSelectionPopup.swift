//
//  PowerupSelectionPopup.swift
//  Peggle
//
//  Created by proglab on 3/3/24.
//

import SwiftUI

struct PowerupSelectionPopup: View {
    @ObservedObject var gameViewModel: GameViewModel

    var body: some View {
        if gameViewModel.showingPowerupSelection {
            VStack(spacing: 20) {
                Text("Select a Power-up")
                    .font(.title)
                ForEach(PowerupType.allCases, id: \.self) { powerupType in
                    Button(action: {
                        gameViewModel.selectPowerup(powerupType)
                        gameViewModel.showingPowerupSelection = false
                    }) {
                        Text(powerupType.rawValue)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(50)
            .background(Color.white.opacity(0.8))
            .cornerRadius(20)
            .position(gameViewModel.powerupSelectionPopupPosition)
        }
    }
}

#Preview {
    PowerupSelectionPopup(gameViewModel: GameViewModel(board: Board()))
}
