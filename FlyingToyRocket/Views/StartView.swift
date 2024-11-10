//
//  StartView.swift
//  FlyingToyRocket
//
//  Created by Yasuhito Nagatomo on 2024/11/10.
//

import SwiftUI

struct StartView: View {
    @Environment(AppModel.self) private var appModel

    var body: some View {
        VStack {
            Button(action: {
                appModel.showingImmersiveSpace = true
            }, label: {
                Text("Start")
            })
            .padding()
            .disabled(appModel.immersiveSpaceState != .closed)
        } // VStack
        .padding()
    }
}

#Preview {
    StartView()
        .environment(AppModel())
}
