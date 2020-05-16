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
typealias GameMatrixIndex = (row: Int, column: Int)
typealias GameMatrixGroup = [GameMatrixIndex]

protocol GameFieldFormer {
    func findChain(for componentsMatrix: GameMatrix, componentsCount: Int) -> GameMatrixGroup?
}

class GameMaster {

    private(set) var matrix: GameMatrix = []
    
    private let field: GameField
    private let fieldFormer: GameFieldFormer
    
    private let substances: [Substance]
    
    init(field: GameField, fieldFormer: GameFieldFormer, substances: [Substance]) {
        self.field = field
        self.fieldFormer = fieldFormer
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
                
        matrix = []
        
        // Fill empty values
        for _ in 0..<field.rows {
            var row: [Substance.Component] = []
            for _ in 0..<field.columns {
                row.append("")
            }
            matrix.append(row)
        }
                
//        matrix = [
//            ["", "", "X", ""],
//            ["", "X", "X", ""],
//            ["", "X", "X", "X"],
//            ["", "X", "X", "X"]
//        ]
        
        let suffledSubstances = substances.shuffled()
        for substance in suffledSubstances {
            print("Substance: \(substance.components.joined())")
            
            guard let chain = fieldFormer.findChain(for: matrix, componentsCount: substance.components.count) else {
                continue
            }
            
            let components = substance.components
            for (componentIndex, matrixIndex) in chain.enumerated() {
                let component = components[componentIndex]
                matrix[matrixIndex.row][matrixIndex.column] = component
            }
            
            printMatrix()
            print("")
        }
    }
    
    private func printMatrix() {
        
        for row in matrix {
            var rowText = row.reduce("") { result, component in
                result + " \(component) |"
            }
            
            rowText.removeLast()

            print("[\(rowText)]")
        }
    }
}

extension GameMatrixGroup {
    
    func contains(_ index: GameMatrixIndex) -> Bool {
        contains { currentIndex in
            (currentIndex.row == index.row) &&
            (currentIndex.column == index.column)
        }
    }
}

extension GameMatrix {
        
    subscript(index: GameMatrixIndex) -> Substance.Component? {
        guard contains(index) else { return nil }
        
        return self[index.row][index.column]
    }
    
    func contains(_ index: GameMatrixIndex) -> Bool {
        guard 0..<count ~= index.row else { return false }
        guard 0..<self[index.row].count ~= index.column else { return false }
        
        return true
    }
}
