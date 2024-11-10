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
            .padding()
            .disabled(appModel.immersiveSpaceState != .open)

//            Model3D(named: "Scene", bundle: realityKitContentBundle)
//                .padding(.bottom, 50)
//            Text("Hello, world!")
//            ToggleImmersiveSpaceButton()
        } // VStack
        .padding()
    }
}

#Preview {
    PlayingView()
        .environment(AppModel())
}
