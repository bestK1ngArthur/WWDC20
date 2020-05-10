//
//  GameMaster.swift
//  Elementaries
//
//  Created by Artem Belkov on 10.05.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import Foundation

class GameMaster {
    
    var matrix: [[String]] = [
        ["1", "2", "3", "4"],
        ["5", "6", "7", "8"],
        ["9", "10", "11", "12"],
        ["13", "14", "15", "16"]
    ]
    
    func checkComponents(_ components: [String]) -> Bool {
        return components.count == 3
    }
}
