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
    
    init(configuration: GameConfiguration, master: GameMaster) {
        self.configuration = configuration
        self.master = master
        
        super.init(size: .init(width: 750, height: 1334))
        anchorPoint = .init(x: 0.5, y: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        drawComponents()
        drawComponentsTitles()
        drawResultLabel()
        drawHelpLabel()
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
    
    private let resultLabel: TextNode = .create(with: .helveticaNeue(weight: .bold, size: 58))
    private let helpLabel: TextNode = .create(with: .helveticaNeue(size: 40))
    
    // MARK: Touches
    
    private func handleTouch(_ touch: UITouch) {
        var componentNode: ComponentNode? {
            if let componentNode = atPoint(touch.location(in: self)) as? ComponentNode {
                return componentNode
            }
            
            if let label = atPoint(touch.location(in: self)) as? TextNode {
                return label.parent as? ComponentNode
            }
            
            return nil
        }
        
        guard let component = componentNode, component.state != .solved else { return }
                
        if let index = selectedComponents.lastIndex(of: component) {
            let lastIndex = index + 1
            if lastIndex < selectedComponents.count {
                let lastComponents = selectedComponents.suffix(from: lastIndex)
                lastComponents.forEach { unselectComponent($0) }
            }
        } else {
            if selectedComponents.isEmpty {
                selectComponent(component)
            } else if let lastComponent = selectedComponents.last, isNeighbors(first: lastComponent, second: component) {
                selectComponent(component)
            }
        }
    }
    
    private func finishTouch() {
        let components = selectedComponents.compactMap { $0.text }
        let chain: GameMatrixGroup = selectedComponents.compactMap { node in
            guard let rowIndex = self.components.firstIndex(where: { row in
                row.contains { $0.index == node.index }
            }) else {
                return nil
            }
            
            guard let columnIndex = self.components[rowIndex].firstIndex(where: {
                $0.index == node.index
            }) else {
                return nil
            }
            
            return (rowIndex, columnIndex)
        }
        
        let result = master.check(answer: (components, chain))
        
        func unselectComponents() {
            selectedComponents.forEach { component in
                guard component.state == .selected else { return }
                unselectComponent(component)
            }
        }
        
        switch result {
        case .correct(_):
            selectedComponents.forEach { solveComponent($0) }
        case .incorrect:
            unselectComponents()
            resultLabel.attributedText = nil
        case .unspecified:
            unselectComponents()
            showHelpTitle()
        }
    }
    
    // MARK: Drawing
    
    private func drawComponents() {
        
        let width = configuration.componentWidth
        let distance = configuration.componentDistance
        
        let rows = configuration.field.rows
        let columns = configuration.field.columns
        
        let fieldWidth = CGFloat(columns) * width + CGFloat(columns - 1) * distance
        let fieldHeight = CGFloat(rows) * width + CGFloat(rows - 1) * distance
        
        let startX = -fieldWidth / 2
        let startY = -fieldHeight / 2
        
        var components: [[ComponentNode]] = []
        for row in 0..<rows {
            var componentsRow: [ComponentNode] = []
            
            for column in 0..<columns {
                let index: GameMatrixIndex = (rows - (1 + row), column)
                                
                let x = startX + CGFloat(column) * (width + distance) + width / 2
                let y = startY + CGFloat(row) * (width + distance) + width / 2
                
                let node = ComponentNode.create(
                    width: width,
                    position: .init(x: x, y: y),
                    index: index
                )
                
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
    
    private func drawResultLabel() {
        let topComponentNode = children
            .filter { $0 is ComponentNode }
            .sorted { $0.position.y > $1.position.y }
            .first
        
        guard let topNode = topComponentNode else { return }

        resultLabel.position = .init(
            x: 0,
            y: topNode.position.y + topNode.frame.height / 2 + 2 * configuration.componentDistance
        )
                
        addChild(resultLabel)
    }
    
    private func drawHelpLabel() {
        let bottomComponentNode = children
            .filter { $0 is ComponentNode }
            .sorted { $0.position.y < $1.position.y }
            .first
        
        guard let bottomNode = bottomComponentNode else { return }

        let y = bottomNode.position.y - (bottomNode.frame.height / 2 + 2 * configuration.componentDistance + helpLabel.frame.height)
        helpLabel.position = .init(x: 0, y: y)
    
        helpLabel.numberOfLines = 0
        helpLabel.preferredMaxLayoutWidth = frame.width - 2 * configuration.componentWidth
        
        addChild(helpLabel)
    }
    
    // MARK: Actions
    
    private func selectComponent(_ component: ComponentNode) {
        guard !selectedComponents.contains(component) else { return }
        
        selectedComponents.append(component)
        component.state = .selected

        updateResultTitle()
        clearHelpTitle()
    }
    
    private func unselectComponent(_ component: ComponentNode) {
        guard let index = selectedComponents.lastIndex(of: component) else { return }
        
        selectedComponents.remove(at: index)
        component.state = .unselected
        
        updateResultTitle()
    }
    
    private func solveComponent(_ component: ComponentNode) {
        guard let index = selectedComponents.lastIndex(of: component) else { return }
        
        selectedComponents.remove(at: index)
        component.state = .solved
    }
    
    // MARK: Labels
    
    private func updateResultTitle() {
        let components = selectedComponents.compactMap { $0.text }
        
        var title: AttributedString = .init(string: " ")
        
        for component in components where !component.isEmpty {
            var componentText: AttributedString {
                if component.isNumber {
                    return .subscriptString(
                        string: component,
                        font: resultLabel.textFont.withSize(resultLabel.textFont.pointSize / 2),
                        color: resultLabel.fontColor
                    )
                } else {
                    return .attributedString(
                        string: component,
                        font: resultLabel.textFont,
                        color: resultLabel.fontColor
                    )
                }
            }
            
            title += componentText
        }
        
        resultLabel.attributedText = title + .init(string: " ")
    }
    
    private func showHelpTitle() {
        helpLabel.text = "This substance does exist, but we didn’t guess it"
        
        let bottomComponentNode = children
            .filter { $0 is ComponentNode }
            .sorted { $0.position.y < $1.position.y }
            .first
        
        guard let bottomNode = bottomComponentNode else { return }

        let y = bottomNode.position.y - (bottomNode.frame.height / 2 + 2 * configuration.componentDistance + helpLabel.frame.height)
        helpLabel.position = .init(x: 0, y: y)
    }
    
    private func clearHelpTitle() {
        helpLabel.text = nil
    }
    
    // MARK: Helpers
    
    private func isNeighbors(first: ComponentNode, second: ComponentNode) -> Bool {
        guard let firstRow = components.firstIndex(where: { $0.contains(first) }),
              let firstColumn = components[firstRow].firstIndex(where: { $0 == first }),
              let secondRow = components.firstIndex(where: { $0.contains(second) }),
              let secondColumn = components[secondRow].firstIndex(where: { $0 == second }) else {
            return false
        }
        
        let distance = abs(secondRow - firstRow) + abs(secondColumn - firstColumn)
        return distance == 1
    }
}
