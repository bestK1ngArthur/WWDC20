/*:
# Simple Game

[👈 To information](@previous)

To play the game сlick and drag on the screen to create a chemical formula.
*/
import PlaygroundSupport
import SpriteKit

/*:
 First, set up a small playing field so that the game does not last long
*/
let field: GameField = (4, 4)

/*:
 Then we set the data on substances to fill the field. Let's choose simple substances and some acids.
*/
let substances = Substance.simpleSubstances + Substance.acids

/*:
 Here you can visually configure the game.
*/
let configuration = GameConfiguration(
    field: field,
    componentWidth: 70,
    componentDistance: 20
)

/*:
 **GameFieldFormer** is responsible for the algorithm for filling the playing field. In this case, I use my own algorithm, but you can write your own and set it here.
*/
let fieldFormer = StandartGameFieldFormer(
    minComponentsCount: substances
        .min { $0.components.count < $1.components.count }?
        .components.count ?? 2,
    attemptsChainCount: 5
)

/*:
 **GameMaster** controls the process of the game and determines when you guessed correctly.
*/
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

let sceneView = SKView(frame: CGRect(x: 0 , y: 0, width: 400, height: 600))

// Present the scene
sceneView.presentScene(scene)
sceneView.ignoresSiblingOrder = true

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

//: [👉 To complex game](@next)
