//
//  PlayingView.swift
//  FlyingToyRocket
//
//  Created by Yasuhito Nagatomo on 2024/11/10.
//

import SwiftUI

struct PlayingView: View {
    @Environment(AppModel.self) private var appModel

    var body: some View {
        VStack {
            Button(action: {
                appModel.showingImmersiveSpace = false
            }, label: {
                Text("End")
            })
            .disabled(appModel.immersiveSpaceState != .open)
        } // VStack
        .frame(width: 100, height: 80)
    }
}

#Preview {
    PlayingView()
        .environment(AppModel())
}
