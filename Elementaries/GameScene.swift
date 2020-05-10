//
//  GameScene.swift
//  Elementaries
//
//  Created by Artem Belkov on 09.05.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import SpriteKit
import GameplayKit

struct GameConfiguration {
    struct Field {
        let rows: Int
        let columns: Int
    }
    
    let field: Field
    
    let bubbleRadius: CGFloat
    let bubbleDistance: CGFloat
}

enum GameState {
    case initialized
    case playing
    case finished
}

class GameScene: SKScene {
    
    var configuration: GameConfiguration = .init(
        field: .init(rows: 6, columns: 4),
        bubbleRadius: 50,
        bubbleDistance: 20
    )
    
    var state: GameState = .initialized
    
    override func didMove(to view: SKView) {
        drawBubbles()
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let bubble = atPoint(location) as? BubbleNode {
                bubble.select()
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let bubble = atPoint(location) as? BubbleNode {
                bubble.unselect()
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let bubble = atPoint(location) as? BubbleNode {
                bubble.unselect()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    private func drawBubbles() {
        
        let bubbleDiameter = 2 * configuration.bubbleRadius
        
        let rows = configuration.field.rows
        let columns = configuration.field.columns
        
        let fieldWidth = CGFloat(columns) * bubbleDiameter + CGFloat(columns - 1) * configuration.bubbleDistance
        let fieldHeight = CGFloat(rows) * bubbleDiameter + CGFloat(rows - 1) * configuration.bubbleDistance
        
        let startX = -fieldWidth / 2
        let startY = -fieldHeight / 2
                
        for row in 0..<rows {
            for column in 0..<columns {
                let x = startX + CGFloat(column) * (bubbleDiameter + configuration.bubbleDistance) + configuration.bubbleRadius
                let y = startY + CGFloat(row) * (bubbleDiameter + configuration.bubbleDistance) + configuration.bubbleRadius
                
                let node = BubbleNode.create(with: "H", radius: configuration.bubbleRadius)
                node.position = .init(x: x, y: y)
                addChild(node)
            }
        }
    }
}
