//
//  GameComposer.swift
//  Elementaries
//
//  Created by Artem Belkov on 10.05.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import Foundation

typealias GameMatrix = [[String]]

class GameComposer {
    
    var matrix: GameMatrix = [
        ["1", "2", "3", "4"],
        ["5", "6", "7", "8"],
        ["9", "10", "11", "12"],
        ["13", "14", "15", "16"]
    ]
    
    func checkComponents(_ compontent: [String]) -> Bool {
        return true
    }
}
