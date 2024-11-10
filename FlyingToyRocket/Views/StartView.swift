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
            Text("Flying Toy Rocket!")
                .font(.largeTitle)
                .padding()

            Image("gamecontroller")
                .resizable()
                .scaledToFit()
                .frame(width: 300)

            if appModel.gameControllerConnected == false {
                Text("A Game Controller is required to control the rocket.")
                    .foregroundStyle(.yellow)
            } else {
                Text("A Game Controller is connected.")
                    .foregroundStyle(.green)
            }

            Button(action: {
                appModel.showingImmersiveSpace = true
            }, label: {
                Text("Start")
            })
            .padding()
            .disabled(appModel.immersiveSpaceState != .closed)
        } // VStack
        .padding()
        .frame(width: 800, height: 400)
        .handlesGameControllerEvents(matching: .gamepad)
    }
}

#Preview {
    StartView()
        .environment(AppModel())
}
