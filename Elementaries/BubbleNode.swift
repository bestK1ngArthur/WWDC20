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
        node.fillColor = .systemBlue
        node.lineWidth = 0
        node.addChild(node.label)
        
        node.minRadius = radius
        node.maxRadius = 1.2 * radius
        
        return node
    }
    
    func select() {
        guard !isSelected else { return }
        
        isSelected = true

        fillColor = .systemGreen
        
        removeAction(forKey: "unselect")
        run(.scale(by: 2 * maxRadius / frame.width, duration: 0.2), withKey: "select")
    }
    
    func unselect() {
        guard isSelected else { return }
        
        isSelected = false
        
        fillColor = .systemBlue
        
        removeAction(forKey: "select")
        run(.scale(by: 2 * minRadius / frame.width, duration: 0.2), withKey: "unselect")
    }
    
    private var isSelected = false
    
    private var minRadius: CGFloat = 0
    private var maxRadius: CGFloat = 0
        
    private let label: SKLabelNode = .init()
}
