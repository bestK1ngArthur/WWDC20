//
//  GameFieldFormer.swift
//  Elementaries
//
//  Created by Artem Belkov on 16.05.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import Foundation

typealias GameMatrix = [[Substance.Component]]

typealias GameMatrixIndex = (row: Int, column: Int)
typealias GameMatrixGroup = [GameMatrixIndex]

protocol GameFieldFormer {
    func findChain(for componentsMatrix: GameMatrix, componentsCount: Int) -> GameMatrixGroup?
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

extension GameMatrixGroup {
    
    func contains(_ index: GameMatrixIndex) -> Bool {
        contains { currentIndex in
            (currentIndex.row == index.row) &&
            (currentIndex.column == index.column)
        }
    }
}
