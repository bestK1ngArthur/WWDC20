//
//  GameConfiguration.swift
//  Elementaries
//
//  Created by Artem Belkov on 10.05.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import UIKit

struct GameConfiguration {
    struct Field {
        let rows: Int
        let columns: Int
    }
    
    let field: Field
    
    let componentRadius: CGFloat
    let componentDistance: CGFloat
    
    static let `default`: GameConfiguration = .init(
        field: .init(rows: 4, columns: 4),
        componentRadius: 50,
        componentDistance: 20
    )
}
