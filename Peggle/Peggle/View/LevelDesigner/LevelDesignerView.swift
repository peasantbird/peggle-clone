//
//  ContentView.swift
//  Peggle
//
//  Created by proglab on 31/1/24.
//

import SwiftUI

struct LevelDesignerView: View {
    @State private var levelDesignerViewModel = LevelDesignerViewModel()

    var body: some View {
        VStack {
            LevelDesignerBoardView(levelDesignerViewModel: levelDesignerViewModel)
            PaletteView(levelDesignerViewModel: levelDesignerViewModel)
            ActionButtonsView(levelDesignerViewModel: levelDesignerViewModel)
        }
    }
}

#Preview {
    LevelDesignerView()
}
