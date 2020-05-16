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
    let description: String

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
    
    static func substances(from json: String) -> [Substance] {
        guard let url = Bundle.main.url(forResource: json, withExtension: "json") else {
            fatalError("Failed to locate \(json) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(json) from bundle.")
        }
        
        let decoder = JSONDecoder()
        let substances = try? decoder.decode([Substance].self, from: data)
        
        return substances ?? []
    }
}

extension Substance: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case formula
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try values.decode(String.self, forKey: .name)
        description = try values.decode(String.self, forKey: .description)

        let formula = try values.decode(String.self, forKey: .formula)
        let rawElements = formula
            .split(separator: " ")
            .map(String.init)
        
        var elements: [Element] = []
        for (index, rawElement) in rawElements.enumerated() {
            guard !rawElement.isNumber else { continue }
            
            var index: Int? {
                guard (index + 1) < rawElements.count else { return nil }
                
                let nextRawElement = rawElements[index + 1]
                guard nextRawElement.isNumber else { return nil }
                return Int(nextRawElement)
            }

            elements.append(.init(name: rawElement, index: index))
        }
        
        self.elements = elements
    }
}
