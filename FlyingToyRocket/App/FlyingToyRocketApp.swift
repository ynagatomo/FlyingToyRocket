//
//  FlyingToyRocketApp.swift
//  FlyingToyRocket
//
//  Created by Yasuhito Nagatomo on 2024/11/10.
//

import SwiftUI

@main
struct FlyingToyRocketApp: App {
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
                .onChange(of: appModel.showingImmersiveSpace) { _, newValue in
                    if newValue {
                        showImmersiveSpace()
                    } else {
                        closeImmersiveSpace()
                    }
                }
        }
        .windowResizability(.contentSize)

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }

    private func showImmersiveSpace() {
        guard appModel.immersiveSpaceState == .closed else { return }

        Task {
            appModel.immersiveSpaceState = .inTransition
            switch await openImmersiveSpace(id: appModel.immersiveSpaceID) {
            case .opened:
                break
            case .userCancelled, .error:
                fallthrough
            @unknown default:
                appModel.immersiveSpaceState = .closed
                appModel.showingImmersiveSpace = false
            } // switch
        } // Task
    } // func

    private func closeImmersiveSpace() {
        guard appModel.immersiveSpaceState == .open else { return }

        Task {
            appModel.immersiveSpaceState = .inTransition
            await dismissImmersiveSpace()
        }
    }
}
