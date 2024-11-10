//
//  AppModel.swift
//  FlyingToyRocket
//
//  Created by Yasuhito Nagatomo on 2024/11/10.
//

import SwiftUI
import RealityKit
import GameController
import OSLog

@MainActor
@Observable
class AppModel {
    var showingImmersiveSpace: Bool = false

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
    private var rocketRotationX: Float = 0
    private var rocketRotationZ: Float = 0

    // Game Controller

    var gameControllerConnected = false

    init() {
        setGameControllerNotification()
    }
}

// MARK: - Immersive Scene Animation

extension AppModel {
    func setupFlyingScene(rocketEntity: Entity) {
        self.rocketEntity = rocketEntity
        rocketEntity.position = .init(x: 0, y: 1.5, z: 0) // Start Position
        self.accumulativeTime = 0
        self.rocketRotationX = 0
        self.rocketRotationZ = 0
    }

    func doAnimation(_ deltaTime: Double) {
        accumulativeTime += deltaTime

        let gcvalue = pollGameControllerInput()
        rocketRotationX += -gcvalue.lyvalue / 20.0
        rocketRotationZ += -gcvalue.lxvalue / 20.0

        let quat = simd_quatf(angle: rocketRotationX, axis: [1, 0, 0])
        * simd_quatf(angle: rocketRotationZ, axis: [0, 0, 1])
        rocketEntity?.orientation = quat

        let speed = expf(gcvalue.ryvalue + 1.0) // e^(0...2) => 1...e^2
        let velocity = SIMD3<Float>(0, 0.1 * speed, 0)
        let direction = simd_act(quat, velocity)
        rocketEntity?.position += direction * Float(deltaTime)
    }
}

// MARK: - Game Controller

extension AppModel {
    func setGameControllerNotification() {
        let center = NotificationCenter.default
        let main = OperationQueue.main

        center.addObserver(forName: NSNotification.Name.GCControllerDidConnect,
                           object: nil,
                           queue: main) { _ in
            Logger.appRunning.debug("** Game controller was connected.")
            Task { @MainActor in
                self.gameControllerConnected = true
                self.setupGCOnPressHandlers()
            }
        }

        center.addObserver(forName: NSNotification.Name.GCControllerDidDisconnect,
                           object: nil,
                           queue: main) { _ in
            Logger.appRunning.debug("** Game controller was disconnected.")
            Task { @MainActor in
                self.gameControllerConnected = false
            }
        }
    }

    // swiftlint:disable:next large_tuple
    func pollGameControllerInput() -> (lxvalue: Float, lyvalue: Float, rxvalue: Float, ryvalue: Float) {
        var lxvalue: Float = 0
        var lyvalue: Float = 0
        var rxvalue: Float = 0
        var ryvalue: Float = 0

        if let gamecontroller = GCController.current {
            if let extendedGamepad = gamecontroller.extendedGamepad {
                lxvalue = extendedGamepad.leftThumbstick.xAxis.value // -1...1
                lyvalue = extendedGamepad.leftThumbstick.yAxis.value // -1...1
                rxvalue = extendedGamepad.rightThumbstick.xAxis.value // -1...1
                ryvalue = extendedGamepad.rightThumbstick.yAxis.value // -1...1
            }
        } else {
            // no game controller
        }

        return (lxvalue: lxvalue, lyvalue: lyvalue, rxvalue: rxvalue, ryvalue: ryvalue)
    }

    func setupGCOnPressHandlers() {
        // [B/O]
        registerGCOnPressedHander(input: GCInputButtonB) { [weak self] in
            self?.showingImmersiveSpace = true
        }
        // [A/X]
        registerGCOnPressedHander(input: GCInputButtonA) { [weak self] in
            self?.showingImmersiveSpace = false
        }
    }

    private func registerGCOnPressedHander(input: String, handler: @escaping () -> Void) {
        if let gamecontroller = GCController.current {
            gamecontroller.physicalInputProfile.buttons[input]?.valueChangedHandler
                = {  (_, _, pressed) in // (button, value, pressed)
                if pressed {
                    handler()
                }
            } // closure
        } // if
    } // func
}
