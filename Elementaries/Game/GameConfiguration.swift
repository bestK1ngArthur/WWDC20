//
//  GameConfiguration.swift
//  Elementaries
//
//  Created by Artem Belkov on 10.05.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import UIKit

/// Game interface configuration
struct GameConfiguration {
    let field: GameField
    let componentWidth: CGFloat
    let componentDistance: CGFloat
    
    static let `default`: GameConfiguration = .init(
        field: (4, 4),
        componentWidth: 100,
        componentDistance: 30
    )
}
