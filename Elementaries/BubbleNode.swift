//
//  BubbleNode.swift
//  Elementaries
//
//  Created by Artem Belkov on 10.05.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import SpriteKit

class BubbleNode: SKShapeNode {
    
    static func create(with text: String, radius: CGFloat) -> BubbleNode {
        let node = BubbleNode(circleOfRadius: radius)
        
        node.name = "element_node"
        node.fillColor = .blue
        node.lineWidth = 0
        
        return node
    }
    
    func select() {
        removeAction(forKey: "unselect")
        run(.scale(by: 1.2, duration: 0.25), withKey: "select")
    }
    
    func unselect() {
        removeAction(forKey: "select")
        run(.scale(by: 0.84, duration: 0.25), withKey: "unselect")
    }
}
