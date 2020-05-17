//
//  Element.swift
//  Elementaries
//
//  Created by Artem Belkov on 10.05.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import Foundation

/// Element of substance
struct Element {
    let name: String
    let index: Int?
    
    init(name: String, index: Int? = nil) {
        self.name = name
        self.index = index
    }
}
