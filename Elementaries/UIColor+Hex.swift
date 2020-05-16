//
//  UIColor+Hex.swift
//  Elementaries
//
//  Created by Artem Belkov on 16.05.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import UIKit
import SpriteKit

extension UIColor {
    static func color(from hex: String) -> UIColor {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        guard cString.count == 6 else { return .systemGray }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return .init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: 1
        )
    }
}

extension SKColor {
    static var gameBlue: SKColor { .color(from: "#3B59A5") }
    static var gameBlueLight: SKColor { .color(from: "#5680E9") }
    
    static var gameGreen: SKColor { .color(from: "#116466") }
    static var gameGreenLight: SKColor { .color(from: "#4AA8AE") }
        
    static var gameRed: SKColor { .color(from: "#9A1750") }
    static var gameRedLight: SKColor { .color(from: "#EE4C7C") }
}
