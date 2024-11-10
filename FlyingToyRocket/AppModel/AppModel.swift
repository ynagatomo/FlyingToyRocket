//
//  AppModel.swift
//  FlyingToyRocket
//
//  Created by Yasuhito Nagatomo on 2024/11/10.
//

import SwiftUI
import RealityKit

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    let immersiveSpaceID = "ImmersiveSpace"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed

    // Immersive Scene Animation

    private var accumulativeTime: Double = 0
    private var rocketEntity: Entity!
    private var rocketVelocity: SIMD3<Float> = .zero
}

// MARK: - Immersive Scene Animation

extension AppModel {
    func setupFlyingScene(rocketEntity: Entity) {
        self.rocketEntity = rocketEntity
        rocketEntity.position = .zero
        self.rocketVelocity = .init(0, 0.01, 0)
        self.accumulativeTime = 0
    }

    func doAnimation(_ deltaTime: Double) {
        accumulativeTime += deltaTime
        rocketEntity?.position += rocketVelocity * Float(accumulativeTime)
    }
}
