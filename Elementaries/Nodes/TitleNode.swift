//
//  TitleNode.swift
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
        
        return node
    }
}
