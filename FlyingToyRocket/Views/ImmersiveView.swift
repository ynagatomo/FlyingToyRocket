//
//  ImmersiveView.swift
//  FlyingToyRocket
//
//  Created by Yasuhito Nagatomo on 2024/11/10.
//

import SwiftUI
import RealityKit
import RealityKitContent
// import Combine

struct ImmersiveView: View {
    @Environment(AppModel.self) private var appModel
    @State private var eventSubscription: EventSubscription?

    var body: some View {
        RealityView { content in
            if let rootEntity = try? await Entity(named: "Fly", in: realityKitContentBundle) {
                rootEntity.position = .init(x: 0, y: 0, z: -1.5)

                if let rocket = rootEntity.findEntity(named: "ToyRocket") {
                    appModel.setupFlyingScene(rocketEntity: rocket)
                    eventSubscription = content.subscribe(to: SceneEvents.Update.self) { event in
                        appModel.doAnimation(event.deltaTime)
                    } // subscription
                } else {
                    assertionFailure()
                } // if

                content.add(rootEntity)
                // Add an Sky-dome
                // Add an IBL
            } else {
                assertionFailure()
            }
        } // RealityView
        .handlesGameControllerEvents(matching: .gamepad)
        .onDisappear {
            eventSubscription?.cancel() // fail-safe
            eventSubscription = nil
        }
    } // body
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
