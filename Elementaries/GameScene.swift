//
//  GameScene.swift
//  Elementaries
//
//  Created by Artem Belkov on 09.05.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let configuration: GameConfiguration = .default
    let composer: GameComposer = .init()
        
    override func didMove(to view: SKView) {
        drawBubbles()
        drawBubblesTitles()
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
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    private var bubbles: [[BubbleNode]] = []
    private var selectedBubbles: [BubbleNode] = []
    
    private func handleTouch(_ touch: UITouch) {
        guard let bubble = atPoint(touch.location(in: self)) as? BubbleNode else { return }
        
        guard bubble.state != .solved else { return }
        
        if let index = selectedBubbles.lastIndex(of: bubble) {
            let lastIndex = index + 1
            
            if lastIndex < selectedBubbles.count {
                let lastBubbles = selectedBubbles.suffix(from: index + 1)
                lastBubbles.forEach { unselectBubble($0) }
            }
            
        } else {
            
            if selectedBubbles.isEmpty {
                selectBubble(bubble)
            } else if let lastBubble = selectedBubbles.last, checkNeighborBubbles(first: lastBubble, second: bubble) {
                selectBubble(bubble)
            }
        }
    }
    
    private func finishTouch() {
        let components = selectedBubbles.compactMap { $0.text }
        
        if composer.checkComponents(components) {
            selectedBubbles.forEach { solveBubble($0) }
        } else {
            bubbles.forEach { $0.forEach { unselectBubble($0) } }
        }
    }
    
    private func drawBubbles() {
        
        let bubbleDiameter = 2 * configuration.bubbleRadius
        
        let rows = configuration.field.rows
        let columns = configuration.field.columns
        
        let fieldWidth = CGFloat(columns) * bubbleDiameter + CGFloat(columns - 1) * configuration.bubbleDistance
        let fieldHeight = CGFloat(rows) * bubbleDiameter + CGFloat(rows - 1) * configuration.bubbleDistance
        
        let startX = -fieldWidth / 2
        let startY = -fieldHeight / 2
        
        var bubbles: [[BubbleNode]] = []
        for row in 0..<rows {
            var bubblesRow: [BubbleNode] = []
            
            for column in 0..<columns {
                let x = startX + CGFloat(column) * (bubbleDiameter + configuration.bubbleDistance) + configuration.bubbleRadius
                let y = startY + CGFloat(row) * (bubbleDiameter + configuration.bubbleDistance) + configuration.bubbleRadius
                
                let node = BubbleNode.create(radius: configuration.bubbleRadius)
                node.position = .init(x: x, y: y)
                addChild(node)
                
                bubblesRow.append(node)
            }
            
            bubbles.append(bubblesRow)
        }
        self.bubbles = bubbles.reversed()
    }
    
    private func drawBubblesTitles() {
        let matrix = composer.matrix
                
        guard matrix.count == configuration.field.rows, matrix.reduce(true, { result, row in
            result && (row.count == configuration.field.columns)
        }) else {
            fatalError("Invalid game matrix")
        }
        
        for (rowIndex, row) in matrix.enumerated() {
            for (columnIndex, text) in row.enumerated() {
                let bubbleNode = bubbles[rowIndex][columnIndex]
                bubbleNode.text = text
            }
        }
    }
    
    private func checkNeighborBubbles(first: BubbleNode, second: BubbleNode) -> Bool {
        guard let firstRow = bubbles.firstIndex(where: { $0.contains(first) }),
              let firstColumn = bubbles[firstRow].firstIndex(where: { $0 == first }),
              let secondRow = bubbles.firstIndex(where: { $0.contains(second) }),
              let secondColumn = bubbles[secondRow].firstIndex(where: { $0 == second }) else {
            return false
        }
        
        let distance = abs(secondRow - firstRow) + abs(secondColumn - firstColumn)
        
        return distance == 1
    }
    
    private func selectBubble(_ bubble: BubbleNode) {
        guard !selectedBubbles.contains(bubble) else { return }
        
        selectedBubbles.append(bubble)
        bubble.state = .selected
    }
    
    private func unselectBubble(_ bubble: BubbleNode) {
        guard let index = selectedBubbles.lastIndex(of: bubble) else { return }
        
        selectedBubbles.remove(at: index)
        bubble.state = .unselected
    }
    
    private func solveBubble(_ bubble: BubbleNode) {
        guard let index = selectedBubbles.lastIndex(of: bubble) else { return }
        
        selectedBubbles.remove(at: index)
        bubble.state = .solved
    }
}
