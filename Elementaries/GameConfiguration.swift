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
    
    let bubbleRadius: CGFloat
    let bubbleDistance: CGFloat
    
    static let `default`: GameConfiguration = .init(
        field: .init(rows: 4, columns: 3),
        bubbleRadius: 50,
        bubbleDistance: 20
    )
}
