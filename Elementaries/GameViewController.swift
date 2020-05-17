//
//  GameViewController.swift
//  Elementaries
//
//  Created by Artem Belkov on 09.05.2020.
//  Copyright © 2020 Artem Belkov. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    private let gameField: GameField = (5, 5)
    private let substances = Substance.substances(from: "SubstancesDB")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
                        
            let configuration = GameConfiguration(
                field: gameField,
                componentWidth: 70,
                componentDistance: 20
            )
            
            let fieldFormer = StandartGameFieldFormer(
                minComponentsCount: substances
                    .min { $0.components.count < $1.components.count }?
                    .components.count ?? 2,
                attemptsChainCount: 5
            )
            
            let master = GameMaster(
                field: gameField,
                fieldFormer: fieldFormer,
                substances: substances
            )
            
            let scene = GameScene(
                configuration: configuration,
                master: master
            )
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
                        
            // Present the scene
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
