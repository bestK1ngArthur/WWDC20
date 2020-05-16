//
//  UIFont+Custom.swift
//  Elementaries
//
//  Created by Artem Belkov on 16.05.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import UIKit

extension UIFont {
    static func helveticaNeue(weight: UIFont.Weight = .regular, size: CGFloat) -> UIFont {
        let descriptor = UIFontDescriptor(fontAttributes: [.traits: [
            UIFontDescriptor.TraitKey.weight: weight]
        ])
                
        return .init(descriptor: descriptor.withFamily("Helvetica Neue"), size: size)
    }
}
