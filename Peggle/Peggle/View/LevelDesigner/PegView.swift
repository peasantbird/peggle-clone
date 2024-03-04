//
//  PegView.swift
//  Peggle
//
//  Created by proglab on 2/2/24.
//

import SwiftUI

struct PegView: View {
    var peg: Peg
    var imageName: String {
        Utils.pegToImageName(pegType: peg.pegType)
    }

    var body: some View {
        Image(imageName)
            .resizable()
            .frame(width: peg.diameter, height: peg.diameter)
            .position(peg.center)
    }
}

#Preview {
    PegView(peg: Peg(pegType: .optional, center: CGPoint(), radius: Constants.pegRadius))
}
