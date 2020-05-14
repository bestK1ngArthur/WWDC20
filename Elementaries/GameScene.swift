//
//  GameScene.swift
//  Elementaries
//
//  Created by Artem Belkov on 09.05.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
        
    let configuration: GameConfiguration
    let master: GameMaster
    
    init(configuration: GameConfiguration, substances: [Substance]) {
        self.configuration = configuration
        self.master = .init(field: configuration.field, substances: substances)
        
        super.init(size: .init(width: 750, height: 1334))
        anchorPoint = .init(x: 0.5, y: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        drawComponents()
        drawComponentsTitles()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { handleTouch(touch) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches { handleTouch(touch) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        finishTouch()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        finishTouch()
    }
    
    private var components: [[ComponentNode]] = []
    private var selectedComponents: [ComponentNode] = []
    
    private func handleTouch(_ touch: UITouch) {
        guard let component = atPoint(touch.location(in: self)) as? ComponentNode else { return }
        
        guard component.state != .solved else { return }
        
        if let index = selectedComponents.lastIndex(of: component) {
            let lastIndex = index + 1
            if lastIndex < selectedComponents.count {
                let lastComponents = selectedComponents.suffix(from: lastIndex)
                lastComponents.forEach { unselectComponent($0) }
            }
        } else {
            if selectedComponents.isEmpty {
                selectComponent(component)
            } else if let lastComponent = selectedComponents.last, checkNeighborComponents(first: lastComponent, second: component) {
                selectComponent(component)
            }
        }
    }
    
    private func finishTouch() {
        let textComponents = selectedComponents.compactMap { $0.text }
        
        if master.check(components: textComponents) != nil {
            selectedComponents.forEach { solveComponent($0) }
        } else {
            components.forEach { row in
                row.forEach { component in
                    guard component.state == .selected else { return }
                    unselectComponent(component)
                }
            }
        }
    }
    
    private func drawComponents() {
        
        let componentDiameter = 2 * configuration.componentRadius
        
        let rows = configuration.field.rows
        let columns = configuration.field.columns
        
        let fieldWidth = CGFloat(columns) * componentDiameter + CGFloat(columns - 1) * configuration.componentDistance
        let fieldHeight = CGFloat(rows) * componentDiameter + CGFloat(rows - 1) * configuration.componentDistance
        
        let startX = -fieldWidth / 2
        let startY = -fieldHeight / 2
        
        var components: [[ComponentNode]] = []
        for row in 0..<rows {
            var componentsRow: [ComponentNode] = []
            
            for column in 0..<columns {
                let x = startX + CGFloat(column) * (componentDiameter + configuration.componentDistance) + configuration.componentRadius
                let y = startY + CGFloat(row) * (componentDiameter + configuration.componentDistance) + configuration.componentRadius
                
                let node = ComponentNode.create(with: 2 * configuration.componentRadius)
                node.position = .init(x: x, y: y)
                addChild(node)
                
                componentsRow.append(node)
            }
            
            components.append(componentsRow)
        }
        self.components = components.reversed()
    }
    
    private func drawComponentsTitles() {
        let matrix = master.matrix
                
        guard matrix.count == configuration.field.rows, matrix.reduce(true, { result, row in
            result && (row.count == configuration.field.columns)
        }) else {
            fatalError("Invalid game matrix")
        }
        
        for (rowIndex, row) in matrix.enumerated() {
            for (columnIndex, text) in row.enumerated() {
                let componentNode = components[rowIndex][columnIndex]
                componentNode.text = text
            }
        }
    }
    
    private func checkNeighborComponents(first: ComponentNode, second: ComponentNode) -> Bool {
        guard let firstRow = components.firstIndex(where: { $0.contains(first) }),
              let firstColumn = components[firstRow].firstIndex(where: { $0 == first }),
              let secondRow = components.firstIndex(where: { $0.contains(second) }),
              let secondColumn = components[secondRow].firstIndex(where: { $0 == second }) else {
            return false
        }
        
        let distance = abs(secondRow - firstRow) + abs(secondColumn - firstColumn)
        return distance == 1
    }
    
    private func selectComponent(_ component: ComponentNode) {
        guard !selectedComponents.contains(component) else { return }
        
        selectedComponents.append(component)
        component.state = .selected
    }
    
    private func unselectComponent(_ component: ComponentNode) {
        guard let index = selectedComponents.lastIndex(of: component) else { return }
        
        selectedComponents.remove(at: index)
        component.state = .unselected
    }
    
    private func solveComponent(_ component: ComponentNode) {
        guard let index = selectedComponents.lastIndex(of: component) else { return }
        
        selectedComponents.remove(at: index)
        component.state = .solved
    }
}
