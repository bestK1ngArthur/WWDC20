//
//  ComponentNode.swift
//  Elementaries
//
//  Created by Artem Belkov on 10.05.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import SpriteKit

class ComponentNode: SKShapeNode {
    enum State {
        case unselected
        case selected
        case solved
    }
    
    var state: State = .unselected {
        didSet {
            guard state != oldValue else { return }
            
            switch state {
            case .unselected: unselect()
            case .selected: select()
            case .solved: solve()
            }
        }
    }
    
    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }
        
    static func create(radius: CGFloat) -> ComponentNode {
        let node = ComponentNode(circleOfRadius: radius)
        
        node.name = "component_node"
        node.fillColor = .systemBlue
        node.lineWidth = 0
        node.addChild(node.label)
        
        node.minRadius = radius
        node.maxRadius = 1.2 * radius
        
        return node
    }
    
    private enum ActionKey: String {
        case select
        case unselect
    }
        
    private var minRadius: CGFloat!
    private var maxRadius: CGFloat!
        
    private let label: SKLabelNode = .init()

    private func select() {
        fillColor = .systemIndigo
        
        removeAction(forKey: ActionKey.unselect.rawValue)
        run(.scale(by: 2 * maxRadius / frame.width, duration: 0.2), withKey: ActionKey.select.rawValue)
    }
    
    private func unselect() {
        fillColor = .systemBlue
        
        removeAction(forKey: ActionKey.select.rawValue)
        run(.scale(by: 2 * minRadius / frame.width, duration: 0.2), withKey: ActionKey.unselect.rawValue)
    }
    
    private func solve() {
        fillColor = .systemGreen

        removeAction(forKey: ActionKey.select.rawValue)
        run(.scale(by: 2 * minRadius / frame.width, duration: 0.2), withKey: ActionKey.unselect.rawValue)
    }
}
