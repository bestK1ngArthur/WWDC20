//
//  StandartGameFieldFormer.swift
//  Elementaries
//
//  Created by Artem Belkov on 16.05.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import Foundation

/// **StandartGameFieldFormer** is standart alghorhytm to fill all free cells of game field
public class StandartGameFieldFormer: GameFieldFormer {
    private let minComponentsCount: Int
    private let attemptsChainCount: Int
    
    private var matrix: GameMatrix = []
    
    public init(minComponentsCount: Int, attemptsChainCount: Int = 5) {
        self.minComponentsCount = minComponentsCount
        self.attemptsChainCount = attemptsChainCount
    }
    
    /// Find uniqual chain for count in matrix
    public func findChain(for componentsMatrix: GameMatrix, componentsCount: Int) -> GameMatrixGroup? {
        self.matrix = componentsMatrix
              
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
    
    private func isNeighbors(first: GameMatrixIndex, second: GameMatrixIndex) -> Bool {
        let distance = abs(second.row - first.row) + abs(second.column - first.column)
        return distance == 1
    }
}
