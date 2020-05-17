//
//  Substance.swift
//  Elementaries
//
//  Created by Artem Belkov on 09.05.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import Foundation

public typealias SubstanceComponent = String

/// Chemical substance
public struct Substance {
    let name: String
    let description: String

    let elements: [Element]
    
    public var components: [SubstanceComponent] {
        var components: [SubstanceComponent] = []
        
        elements.forEach { element in
            components.append(element.name)
            
            if let index = element.index {
                components.append("\(index)")
            }
        }
        
        return components
    }
    
    public static func substances(from json: String) -> [Substance] {
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
    
    public init(from decoder: Decoder) throws {
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

extension Substance {
    
    /// List of simple substances
    public static var simpleSubstances: [Substance] {
        return [
            .init(name: "Water", description: "The amount of fresh water in the world is only about 2 percent", elements: [
                .init(name: "H", index: 2),
                .init(name: "O")
            ]),
            .init(name: "Chlorine", description: "Chlorine is a greenish yellow poisonous gas", elements: [
                .init(name: "Cl", index: 2)
            ]),
            .init(name: "Bromine", description: "Bromine is the only non-metal that is liquid at room temperature", elements: [
                .init(name: "Br", index: 2)
            ]),
            .init(name: "Sodium chloride", description: "Sodium chloride is a common salt that everyone has in the kitchen", elements: [
                .init(name: "Na"),
                .init(name: "Cl")
            ]),
            .init(name: "Oxygen", description: "Solid oxygen is a light blue crystal", elements: [
                .init(name: "O", index: 2)
            ]),
            .init(name: "Dinitrogen", description: "Liquid nitrogen is used as a refrigerant", elements: [
                .init(name: "N", index: 2)
            ])
        ]
    }
    
    /// List of acids
    public static var acids: [Substance] {
        return [
            .init(name: "Sulfuric acid", description: "Sulfuric acid is used in car batteries", elements: [
                .init(name: "H", index: 2),
                .init(name: "S"),
                .init(name: "O", index: 4)
            ]),
            .init(name: "Nitric acid", description: "Nitric acid is one of the strongest acids", elements: [
                .init(name: "H"),
                .init(name: "N"),
                .init(name: "O", index: 3)
            ]),
            .init(name: "Nitrous acid", description: "The diluted nitrous acid solution has a bluish tint", elements: [
                .init(name: "H"),
                .init(name: "N"),
                .init(name: "O", index: 2)
            ]),
            .init(name: "Hydrogen chloride", description: "The concentration of hydrochloric acid in the human stomach is 0.3-0.5%", elements: [
                .init(name: "H"),
                .init(name: "Cl")
            ]),
            .init(name: "Phosphoric acid", description: "Phosphoric acid is used to clean metal surfaces from rust", elements: [
                .init(name: "H", index: 3),
                .init(name: "P"),
                .init(name: "O", index: 4)
            ])
        ]
    }
}
