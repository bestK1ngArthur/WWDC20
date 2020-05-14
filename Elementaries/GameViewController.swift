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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            
            let scene = GameScene(
                configuration: .default,
                substances: [
                    .init(name: "Water", elements: [
                        .init(name: "H", index: 2),
                        .init(name: "O")
                    ]),
                    .init(name: "?", elements: [
                        .init(name: "H", index: 2),
                        .init(name: "S"),
                        .init(name: "O", index: 4)
                    ]),
                    .init(name: "?", elements: [
                        .init(name: "Na"),
                        .init(name: "O"),
                        .init(name: "H")
                    ]),
                    .init(name: "?", elements: [
                        .init(name: "K", index: 2),
                        .init(name: "S"),
                        .init(name: "O", index: 4)
                    ])
                ]
            )
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
                        
            // Present the scene
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
