//: [Previous](@previous)

import PlaygroundSupport
import SpriteKit

let substances = Substance.substances(from: "substances")

let field: GameField = (5, 5)

let configuration = GameConfiguration(
    field: field,
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
    field: field,
    fieldFormer: fieldFormer,
    substances: substances
)

let scene = GameScene(
    configuration: configuration,
    master: master
)

// Set the scale mode to scale to fit the window
scene.scaleMode = .aspectFill

// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x: 0 , y: 0, width: 400, height: 600))

// Present the scene
sceneView.presentScene(scene)
sceneView.ignoresSiblingOrder = true

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

//: [Next](@next)
