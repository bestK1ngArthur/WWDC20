//
//  GameMaster.swift
//  Elementaries
//
//  Created by Artem Belkov on 10.05.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import Foundation

typealias GameField = (rows: Int, columns: Int)
typealias GameMatrix = [[Substance.Component]]

class GameMaster {

    private let field: GameField
    private let substances: [Substance]
    
    var matrix: GameMatrix = []
    
    init(field: GameField, substances: [Substance]) {
        self.field = field
        self.substances = substances
        
        generateMatrix()
    }
        
    func check(components: [String]) -> Substance? {
        guard let substance = substances.first(where: { substance in
            components == substance.components
        }) else {
            return nil
        }
        
        return substance
    }
    
    private func generateMatrix() {
        let totalComponentsCount = substances.reduce(0) { result, substance in
            result + substance.components.count
        }
        
        guard totalComponentsCount >= field.rows * field.columns else {
            fatalError("Can't generate game matrix. Substance components count is not enough to fill game field")
        }
        
        // TODO: Make alghorhytm
        
        // H20
        // H2SO4
        // NaOH
        // K2SO4
        
        matrix = [
            ["H", "2", "Na", "O"],
            ["H", "O", "K", "H"],
            ["2", "S", "2", "4"],
            ["4", "O", "S", "O"]
        ]
    }
}
