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

protocol GameFieldComposer {
    
}

class GameMaster {

    private(set) var matrix: GameMatrix = []
    
    private let field: GameField
    private let substances: [Substance]
    private let minComponentsCount: Int
    
    private let attemptsChainCount = 5
    
    init(field: GameField, substances: [Substance]) {
        self.field = field
        self.substances = substances
        self.minComponentsCount = substances.min(by: { first, second in
            first.components.count < second.components.count
        })?.components.count ?? 2
        
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
            
            guard let chain = findChain(for: substance) else {
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
    
    private func isNeighbors(first: GameMatrixIndex, second: GameMatrixIndex) -> Bool {
        let distance = abs(second.row - first.row) + abs(second.column - first.column)
        return distance == 1
    }
    
    private func findChain(for substance: Substance) -> GameMatrixGroup? {
        let componentsCount = substance.components.count
        
        let filteredGroups = freeMatrixGroups.filter {
            ($0.count == componentsCount) ||
            ($0.count >= (componentsCount + minComponentsCount)) ||
            getTails(for: $0).count <= 2
        }
  
        guard
            let selectedGroup = filteredGroups.randomElement(),
            let startIndex = getCorners(for: selectedGroup).randomElement() else {
            return nil
        }
                
        func findPossibleChain(startIndex: GameMatrixIndex, group: GameMatrixGroup, count: Int) -> GameMatrixGroup? {
            var chain: GameMatrixGroup = [startIndex]
            
            for _ in 0..<(count - 1) {
                guard let index = chain.last else { return nil }
                
                var neighbors = selectedGroup.filter { isNeighbors(first: index, second: $0) }
                
                func getNextIndex() -> GameMatrixIndex? {
                    guard let nextIndex = neighbors.randomElement() else { return nil }
                    
                    if chain.contains(nextIndex) {
                        neighbors.removeAll {
                            ($0.row == nextIndex.row) &&
                            ($0.column == nextIndex.column)
                        }
                        
                        return getNextIndex()
                    } else {
                        return nextIndex
                    }
                }
                
                guard let nextIndex = getNextIndex() else { return nil }
                chain.append(nextIndex)
            }
            
            return chain
        }
        
        var attemptsCount = attemptsChainCount

        while attemptsCount > 0 {
            attemptsCount -= 1
            
            guard let chain = findPossibleChain(
                startIndex: startIndex,
                group: selectedGroup,
                count: componentsCount
            ) else {
                continue
            }
            
            // Check chain
            
            for index in chain {
                matrix[index.row][index.column] = "X"
            }
            
            printMatrix()
            
            let hasShortGroups = freeMatrixGroups.contains { $0.count < minComponentsCount }
            let hasDeadGroups = freeMatrixGroups.contains { getTails(for: $0).count > 2 }
            
            for index in chain {
                matrix[index.row][index.column] = ""
            }
            
            if hasShortGroups || hasDeadGroups {
                continue
            } else {
                return chain
            }
        }
        
        return nil
    }
    
    private var freeMatrixGroups: [GameMatrixGroup] {
        var groups: [GameMatrixGroup] = []
                
        for rowIndex in 0...(matrix.count - 1) {
            for columnIndex in 0...(matrix[rowIndex].count - 1) {
                let index: GameMatrixIndex = (rowIndex, columnIndex)
                                
                let groupsContains = groups.contains { $0.contains(index) }
                guard !groupsContains else { continue }
                
                guard let freeGroup = findFreeGroup(startIndex: index), !freeGroup.isEmpty else {
                    continue
                }
                
                groups.append(freeGroup)
            }
        }
        
        var groupsText = groups.reduce("") { result, group in
            result + "\(group.count) | "
        }
        
        if !groupsText.isEmpty {
            groupsText.removeLast()
            groupsText.removeLast()
            groupsText.removeLast()
        }

        print("Groups: \(groups.count) (\(groupsText))")
        
        return groups
    }
    
    private func findFreeGroup(startIndex: GameMatrixIndex) -> GameMatrixGroup? {
        guard matrix.contains(startIndex) else { return nil }
        guard let component = matrix[startIndex], component.isEmpty else { return nil }
        
        var group: GameMatrixGroup = []
        
        func findFreeNeighbors(for index: GameMatrixIndex) {
            guard !group.contains(index) else { return }
            
            guard let component = matrix[index], component.isEmpty else {
                return
            }
            
            group.append(index)
            
            let leftIndex: GameMatrixIndex = (index.row, index.column - 1)
            findFreeNeighbors(for: leftIndex)
            
            let topIndex: GameMatrixIndex = (index.row - 1, index.column)
            findFreeNeighbors(for: topIndex)

            let rightIndex: GameMatrixIndex = (index.row, index.column + 1)
            findFreeNeighbors(for: rightIndex)

            let bottomIndex: GameMatrixIndex = (index.row + 1, index.column)
            findFreeNeighbors(for: bottomIndex)
        }
        
        findFreeNeighbors(for: startIndex)
        
        return group
    }
    
    private func getCorners(for group: GameMatrixGroup) -> GameMatrixGroup {
        var cornersNeighbors: [(GameMatrixIndex, Int)] = []
        
        for index in group {
            var neighborsCount = 0
            
            for currentIndex in group {
                guard isNeighbors(first: index, second: currentIndex) else { continue }
                neighborsCount += 1
            }
            
            cornersNeighbors.append((index, neighborsCount))
        }
        
        guard let minNeighborsCount = cornersNeighbors.min(by: { first, second in
            first.1 < second.1
        })?.1 else {
            return []
        }
        
        let corners = cornersNeighbors
            .filter { $0.1 == minNeighborsCount }
            .map { $0.0 }
        
        return corners
    }
    
    private func getTails(for group: GameMatrixGroup) -> GameMatrixGroup {
        var corners: GameMatrixGroup = []
        
        for index in group {
            var neighborsCount = 0
            
            for currentIndex in group {
                guard isNeighbors(first: index, second: currentIndex) else { continue }
                neighborsCount += 1
            }
            
            if neighborsCount == 1 {
                corners.append(index)
            }
        }

        return corners
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
