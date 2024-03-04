//
//  ActionButtonsView.swift
//  Peggle
//
//  Created by proglab on 5/2/24.
//

import SwiftUI

struct ActionButtonsView: View {
    var levelDesignerViewModel: ActionButtonsViewModelProtocol
    @State private var levelName: String = ""
    @State private var error: Error?

    var body: some View {
        NavigationStack {
            HStack {
                makeLoadButton()
                makeSaveButton()
                makeResetButton()
                Spacer()
                    .frame(width: 50)
                makeTextField()
                Spacer()
                    .frame(width: 50)
                makeStartButton()
            }
            .padding(.horizontal)
            .alert(isPresented: Binding<Bool>(
                get: { self.error != nil },
                set: { _ in self.error = nil }
            )) {
                Alert(
                    title: Text("Error"),
                    message: Text(error?.localizedDescription ?? "An unknown error occurred.")
                )
            }
        }
        .frame(height: 30)
    }

    private func makeLoadButton() -> some View {
        Button(action: {
            do {
                try levelDesignerViewModel.loadBoard(levelName: levelName)
            } catch {
                self.error = error
            }
        }, label: {
            Text("LOAD")
        })
    }

    private func makeSaveButton() -> some View {
        Button(action: {
            do {
                try levelDesignerViewModel.saveBoard(levelName: levelName)
            } catch {
                self.error = error
            }
        }, label: {
            Text("SAVE")
        })
    }

    private func makeResetButton() -> some View {
        Button(action: levelDesignerViewModel.clearBoard, label: {
            Text("RESET")
        })
    }

    private func makeTextField() -> some View {
        TextField(
            "Level Name",
            text: $levelName
        )
        .border(.secondary)
    }

    private func makeStartButton() -> some View {
        NavigationLink(
            "START", destination: GameView(gameViewModel: GameViewModel(board: levelDesignerViewModel.board))
        )
    }
}

#Preview {
    ActionButtonsView(levelDesignerViewModel: LevelDesignerViewModel())
}
