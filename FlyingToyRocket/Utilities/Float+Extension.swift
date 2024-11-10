//
//  Float+Extension.swift
//  FlyingToyRocket
//
//  Created by Yasuhito Nagatomo on 2024/11/10.
//

import Foundation

extension Float {
    func clamped(min: Float, max: Float) -> Float {
        if self < min {
            return min
        } else if self > max {
            return max
        } else {
            return self
        }
    }
}
