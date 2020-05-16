//
//  AttributedString.swift
//  Elementaries
//
//  Created by Artem Belkov on 16.05.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import UIKit

typealias AttributedString = NSMutableAttributedString

extension AttributedString {
        
    static func attributedString(
        string: String,
        font: UIFont,
        color: UIColor? = nil
    ) -> AttributedString {
        var scriptTextAttributes: [NSAttributedString.Key: Any] = [.font: font]
        
        if let color = color {
            scriptTextAttributes[.foregroundColor] = color
        }
        
        return .init(string: string, attributes: scriptTextAttributes)
    }
    
    static func + (left: AttributedString, right: AttributedString) -> AttributedString {
        let string = AttributedString()
        string.append(left)
        string.append(right)
        return string
    }
    
    static func += (left: inout AttributedString, right: AttributedString) {
        left = left + right
    }
    
    func addColor(_ color: UIColor) {
        let scriptTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: color]
        addAttributes(scriptTextAttributes, range: NSRange(location: 0, length: length))
    }
}
 
// MARK: Superscript & subscript

extension AttributedString {
    
    enum ScriptType {
        case `super`
        case sub
    }
    
    static func scriptString(
        string: String,
        type: ScriptType,
        font: UIFont,
        offset: Int = 8,
        color: UIColor? = nil
    ) -> AttributedString {
        
        var baseLineOffset: Int {
            switch type {
            case .sub: return -offset
            case .super: return offset
            }
        }
            
        var scriptTextAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .baselineOffset: baseLineOffset
        ]
        
        if let color = color {
            scriptTextAttributes[.foregroundColor] = color
        }
        
        return .init(string: string, attributes: scriptTextAttributes)
    }
    
    static func superscriptString(
        string: String,
        font: UIFont,
        color: UIColor? = nil
    ) -> AttributedString {
        scriptString(string: string, type: .super, font: font, color: color)
    }
    
    static func subscriptString(
        string: String,
        font: UIFont,
        color: UIColor? = nil
    ) -> AttributedString {
        scriptString(string: string, type: .sub, font: font, color: color)
    }
}
