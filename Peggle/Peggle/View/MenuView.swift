//
//  MenuView.swift
//  Peggle
//
//  Created by proglab on 1/3/24.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 20) {
                    makeTitle()
                    makePlayButton()
                    makeDesignLevelButton()
                }
                .padding()
            }
        }
    }

    private func makeTitle() -> some View {
        Text("Peggle")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .shadow(radius: 10)
            .padding()
            .scaleEffect(1.5)
    }

    private func makePlayButton() -> some View {
        NavigationLink(destination: LevelSelectionView()) {
            Text("Play")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]),
                                           startPoint: .leading,
                                           endPoint: .trailing))
                .cornerRadius(10)
                .shadow(radius: 5)
        }
    }

    private func makeDesignLevelButton() -> some View {
        NavigationLink(destination: LevelDesignerView()) {
            Text("Design a Level")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [.green, .yellow]),
                                           startPoint: .leading,
                                           endPoint: .trailing))
                .cornerRadius(10)
                .shadow(radius: 5)
        }
    }
}

#Preview {
    MenuView()
}
