//
//  BubbleNode.swift
//  Elementaries
//
//  Created by Artem Belkov on 10.05.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import SpriteKit

class BubbleNode: SKShapeNode {
    
    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    static func create(radius: CGFloat) -> BubbleNode {
        let node = BubbleNode(circleOfRadius: radius)
        
        node.name = "bubble_node"
        node.fillColor = .blue
        node.lineWidth = 0
        node.addChild(node.label)
                
        return node
    }
    
    func select() {
        guard !isSelected else { return }
        
        isSelected = true
        
        removeAction(forKey: "unselect")
        run(.scale(by: 1.2, duration: 0.2), withKey: "select")
    }
    
    func unselect() {
        guard isSelected else { return }
        
        isSelected = false
        
        removeAction(forKey: "select")
        run(.scale(by: 1/1.2, duration: 0.2), withKey: "unselect")
    }
    
    private var isSelected = false
    
    private let label: SKLabelNode = .init()
}
