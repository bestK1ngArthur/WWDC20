//
//  GameMaster.swift
//  Elementaries
//
//  Created by Artem Belkov on 10.05.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import Foundation

/// Game field configuration
typealias GameField = (rows: Int, columns: Int)
typealias GameAnswer = (components: [Substance.Component], chain: GameMatrixGroup)

enum GameAnswerResult {
    case correct(Substance)
    case incorrect
    case unspecified
}

/// **GameMaster** controls the game process
class GameMaster {
    private(set) var matrix: GameMatrix = []
    
    private let field: GameField
    private let fieldFormer: GameFieldFormer
    private let substances: [Substance]
    
    private var answers: [GameAnswer] = []
    
    init(field: GameField, fieldFormer: GameFieldFormer, substances: [Substance]) {
        self.field = field
        self.fieldFormer = fieldFormer
        self.substances = substances
        
        formMatrix()
    }
    
    /// Returns answers result
    func check(answer: GameAnswer) -> GameAnswerResult {
        let answerIsCorrect = answers.contains { currentAnswer in
            groupsIsEqual(first: currentAnswer.chain, second: answer.chain) &&
            (currentAnswer.components == answer.components)
        }
        
        let substance = substances.first(where: { substance in
            answer.components == substance.components
        })
        
        if let substance = substance {
            if answerIsCorrect {
                return .correct(substance)
            } else {
                return .unspecified
            }
        }
        
        return .incorrect
    }
    
    private func formMatrix() {
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
        
        // Shuffle substances
        let suffledSubstances = substances.shuffled()
        
        // Find chains for substances & fill field
        for substance in suffledSubstances {
            guard let chain = fieldFormer.findChain(for: matrix, componentsCount: substance.components.count) else {
                continue
            }
            
            let components = substance.components
            for (componentIndex, matrixIndex) in chain.enumerated() {
                let component = components[componentIndex]
                matrix[matrixIndex.row][matrixIndex.column] = component
            }
            
            // Save answers to check in future
            answers.append((components, chain))
        }
    }
    
    private func groupsIsEqual(first: GameMatrixGroup, second: GameMatrixGroup) -> Bool {
        guard first.count == second.count else { return false }
        
        var isEqual = true
        for (index, firstIndex) in first.enumerated() {
            let secondIndex = second[index]
            
            let isCurrentEqual =
                (firstIndex.row == secondIndex.row) &&
                (firstIndex.column == secondIndex.column)
            
            isEqual = isEqual && isCurrentEqual
        }
    
        return isEqual
    }
}
