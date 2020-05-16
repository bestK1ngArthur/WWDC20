//
//  Substance.swift
//  Elementaries
//
//  Created by Artem Belkov on 09.05.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import Foundation

struct Substance {
    typealias Component = String
    
    let name: String
    let elements: [Element]
    
    var components: [Component] {
        var components: [Component] = []
        
        elements.forEach { element in
            components.append(element.name)
            
            if let index = element.index {
                components.append("\(index)")
            }
        }
        
        return components
    }
}

