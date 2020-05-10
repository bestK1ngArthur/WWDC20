//
//  BubbleNode.swift
//  Elementaries
//
//  Created by Artem Belkov on 10.05.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import SpriteKit

class BubbleNode: SKShapeNode {
    enum State {
        case unselected
        case selected
        case solved
    }
    
    var state: State = .unselected {
        didSet {
            guard state != oldValue else { return }
            
            switch state {
            case .unselected:
                unselect()
            case .selected:
                select()
            case .solved:
                solve()
            }
        }
    }
    
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
        
    private var minRadius: CGFloat = 0
    private var maxRadius: CGFloat = 0
        
    private let label: SKLabelNode = .init()

    private func select() {
        fillColor = .systemIndigo
        
        removeAction(forKey: "unselect")
        run(.scale(by: 2 * maxRadius / frame.width, duration: 0.2), withKey: "select")
    }
    
    private func unselect() {
        fillColor = .systemBlue
        
        removeAction(forKey: "select")
        run(.scale(by: 2 * minRadius / frame.width, duration: 0.2), withKey: "unselect")
    }
    
    private func solve() {
        fillColor = .systemGreen

        removeAction(forKey: "select")
        run(.scale(by: 2 * minRadius / frame.width, duration: 0.2), withKey: "unselect")
    }
}
