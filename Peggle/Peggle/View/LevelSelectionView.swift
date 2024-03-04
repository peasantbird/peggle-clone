//
//  LevelSelectionView.swift
//  Peggle
//
//  Created by proglab on 1/3/24.
//

import SwiftUI

struct LevelSelectionView: View {
    @State private var levelSelectionViewModel = LevelSelectionViewModel()

    var body: some View {
        NavigationStack {
            List(levelSelectionViewModel.savedLevels.sorted(by: { $0.key < $1.key }), id: \.key) { levelName, board in
                NavigationLink(levelName) {
                    GameView(gameViewModel: GameViewModel(board: board))
                }
            }
        }
        .onAppear(perform: {
            levelSelectionViewModel = LevelSelectionViewModel()
        })
    }
}

#Preview {
    LevelSelectionView()
}
