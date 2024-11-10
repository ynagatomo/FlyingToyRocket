//
//  ContentView.swift
//  FlyingToyRocket
//
//  Created by Yasuhito Nagatomo on 2024/11/10.
//

import SwiftUI
import RealityKit
// import RealityKitContent

struct ContentView: View {
    @Environment(AppModel.self) private var appModel

    var body: some View {
        if appModel.immersiveSpaceState == .closed {
            StartView()
        } else {
            PlayingView()
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
