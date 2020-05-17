/*:
# Complex Game

[👈 To simple game](@previous)

To play the game сlick and drag on the screen to create a chemical formula.

### Make sure the assitant editor and live view are selected:
![Assitant Editor](assistantEditor.png)
*/
import PlaygroundSupport
import SpriteKit

let field: GameField = (6, 5)

/*:
 Now we will take data from a large database of substances that I have collected in a file.
*/
let substances = Substance.substances(from: "SubstancesDB")

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

let sceneView = SKView(frame: CGRect(x: 0 , y: 0, width: 400, height: 600))

// Present the scene
sceneView.presentScene(scene)
sceneView.ignoresSiblingOrder = true

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

