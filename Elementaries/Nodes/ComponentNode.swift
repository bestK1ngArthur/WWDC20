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
        set {
            label.text = newValue
            label.position = .init(x: 0, y: -label.frame.height / 2)
        }
    }
    
    static func create(with width: CGFloat) -> ComponentNode {
                
        let node = ComponentNode(
            rect: .init(origin: .init(x: -width / 2, y: -width / 2),
                        size: .init(width: width, height: width)),
            cornerRadius: 6
        )
        
        node.name = "component_node"
        node.fillColor = .systemIndigo
        node.strokeColor = .systemTeal
        node.lineWidth = width / 8
        node.addChild(node.label)
        
        node.minWidth = node.frame.width
        node.maxWidth = 1.1 * node.frame.width
                
        return node
    }
    
    private enum ActionKey: String {
        case select
        case unselect
    }
        
    private var minWidth: CGFloat!
    private var maxWidth: CGFloat!
        
    private let label: TextNode = .create(with: .helveticaNeue(weight: .bold, size: 48))

    private func select() {
        fillColor = .systemBlue
        
        removeAction(forKey: ActionKey.unselect.rawValue)
        run(.scale(by: maxWidth / frame.width, duration: 0.2), withKey: ActionKey.select.rawValue)
    }
    
    private func unselect() {
        fillColor = .systemIndigo
        
        removeAction(forKey: ActionKey.select.rawValue)
        run(.scale(by: minWidth / frame.width, duration: 0.2), withKey: ActionKey.unselect.rawValue)
    }
    
    private func solve() {
        fillColor = .systemGreen

        removeAction(forKey: ActionKey.select.rawValue)
        run(.scale(by: minWidth / frame.width, duration: 0.2), withKey: ActionKey.unselect.rawValue)
    }
}
