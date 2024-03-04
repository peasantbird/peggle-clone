//
//  GameView.swift
//  Peggle
//
//  Created by proglab on 18/2/24.
//

import SwiftUI

struct GameView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var gameViewModel: GameViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                if let ball = gameViewModel.ball {
                    renderBallView(ball)
                }
                ForEach(gameViewModel.gamePegs) { gamePeg in
                    renderPegView(gamePeg)
                }
                ForEach(gameViewModel.gameBlocks) { gameBlock in
                    renderBlockView(gameBlock)
                }
                if let bucket = gameViewModel.bucket {
                    renderBucketView(bucket)
                }
                CannonView(gameViewModel: gameViewModel)
                BallCountView(gameViewModel: gameViewModel)
                PowerupSelectionPopup(gameViewModel: gameViewModel)
            }
            .onTapGesture {
                gameViewModel.launchBall()
            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        gameViewModel.setCannonAimPoint(gesture.location)
                    }
            )
            .onAppear(perform: {
                gameViewModel.setBoardSize(geometry.size)
                gameViewModel.setDefaultCannonAimPoint()
                gameViewModel.addBucket()
                gameViewModel.addWalls()
                gameViewModel.startGameLoop()
            })
            .alert("You Won!", isPresented: Binding<Bool>(
                get: { gameViewModel.gameIsWon },
                set: { _ in }
            )) {
                Button("Back", action: { dismiss() })
            }
            .alert("You Lost!", isPresented: Binding<Bool>(
                get: { gameViewModel.gameIsLost },
                set: { _ in }
            )) {
                Button("Back", action: { dismiss() })
            }
        }
    }

    private func renderPegView(_ gamePeg: GamePeg) -> some View {
        let imageName = Utils.pegToImageName(pegType: gamePeg.pegType, isHit: gamePeg.isHitByBall)

        return Image(imageName)
            .resizable()
            .frame(width: gamePeg.diameter, height: gamePeg.diameter)
            .position(gamePeg.position)
            .opacity(gamePeg.toBeRemoved ? 0 : 1)
            .animation(.easeOut(duration: Constants.animationDuration), value: gamePeg.toBeRemoved)
    }

    private func renderBlockView(_ gameBlock: GameBlock) -> some View {
        Image("block")
            .resizable()
            .frame(width: gameBlock.width, height: gameBlock.height)
            .position(gameBlock.position)
    }

    private func renderBallView(_ ball: Ball) -> some View {
        Image("ball")
            .resizable()
            .frame(width: Ball.diameter, height: Ball.diameter)
            .position(ball.position)
    }

    private func renderBucketView(_ bucket: Bucket) -> some View {
        Image("bucket")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: Constants.bucketWidth, height: Constants.bucketHeight)
            .scaleEffect(gameViewModel.ballIsCollected ? 1.2 : 1.0)
            .animation(.easeInOut(duration: Constants.animationDuration), value: gameViewModel.ballIsCollected)
            .position(bucket.center)
    }
}

#Preview {
    let board: Board
    do {
        board = try Board().load(levelName: "Test")
    } catch {
        board = Board()
        print(error)
    }

    let gameViewModel = GameViewModel(board: board)

    return GameView(gameViewModel: gameViewModel)
}
