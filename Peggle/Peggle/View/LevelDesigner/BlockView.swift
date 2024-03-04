//
//  BlockView.swift
//  Peggle
//
//  Created by proglab on 3/3/24.
//

import SwiftUI

struct BlockView: View {
    var block: Block

    var body: some View {
        Image("block")
            .resizable()
            .frame(width: block.width, height: block.height)
            .position(block.center)
    }
}

#Preview {
    BlockView(block: Block(center: CGPoint(), width: Constants.blockWidth, height: Constants.blockHeight))
}
