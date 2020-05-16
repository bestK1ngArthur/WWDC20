//
//  TextNode.swift
//  Elementaries
//
//  Created by Artem Belkov on 16.05.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import SpriteKit

class TextNode: SKLabelNode {
    
    var textFont: UIFont = .systemFont(ofSize: 16) {
        didSet {
            fontSize = textFont.pointSize
            fontName = textFont.fontName
        }
    }
    
    static func create(with font: UIFont) -> TextNode {
        let node = TextNode()

        node.textFont = font
        node.horizontalAlignmentMode = .center
        node.isUserInteractionEnabled = false
        
        return node
    }
    
    func scaleUp() {
        let scaleUpAction = SKAction.scale(to: 1.5, duration: 0.15)
        let scaleDownAction = SKAction.scale(to: 1, duration: 0.15)

        let action = SKAction.sequence([scaleUpAction, scaleDownAction])
        run(action)
    }
    
    func smallScaleUp() {
        let scaleUpAction = SKAction.scale(to: 1.05, duration: 0.3)
        let scaleDownAction = SKAction.scale(to: 1, duration: 0.3)
        
        let action = SKAction.sequence([scaleUpAction, scaleDownAction])
        run(action)
    }
}
