//
//  GameConfiguration.swift
//  Elementaries
//
//  Created by Artem Belkov on 10.05.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import UIKit

struct GameConfiguration {
    let field: GameField
    let componentRadius: CGFloat
    let componentDistance: CGFloat
    
    static let `default`: GameConfiguration = .init(
        field: (4, 4),
        componentRadius: 50,
        componentDistance: 30
    )
}
