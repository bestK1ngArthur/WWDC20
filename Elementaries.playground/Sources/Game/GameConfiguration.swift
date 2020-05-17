//
//  GameConfiguration.swift
//  Elementaries
//
//  Created by Artem Belkov on 10.05.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import UIKit

/// Game interface configuration
public struct GameConfiguration {
    let field: GameField
    let componentWidth: CGFloat
    let componentDistance: CGFloat
    
    static let `default`: GameConfiguration = .init(
        field: (4, 4),
        componentWidth: 70,
        componentDistance: 20
    )
    
    public init(field: GameField, componentWidth: CGFloat, componentDistance: CGFloat) {
        self.field = field
        self.componentWidth = componentWidth
        self.componentDistance = componentDistance
    }
}
