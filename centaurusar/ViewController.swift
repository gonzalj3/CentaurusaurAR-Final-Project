//
//  ViewController.swift
//  test2SpriteKitFail
//
//  Created by Jose Gonzalez on 7/17/17.
//  Copyright © 2017 Jose Gonzalez. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

// Loss and win scene delegates for handling the transitions to the main menu and high scores views
protocol HighScoresViewTransitionDelegate{
    func transitionToHighScores()
}

protocol MainMenuViewTransitionDelegate{
    func transissionToMainMenu()
}

class WinLossView: SKView {
    var hsTransitionDelegate: HighScoresViewTransitionDelegate?
    var mmTransitionDelegate: MainMenuViewTransitionDelegate?
}

class ViewController: UIViewController, ARSKViewDelegate, HighScoresViewTransitionDelegate, MainMenuViewTransitionDelegate {
    var count = 0
    
    @IBOutlet var sceneView: ARSKView!
    var audioPlayer: AVAudioPlayer?
    
    let box = CGSize(width: 5, height: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Assign the high score and main menu transition delegates to this view controller
        if let lossView = self.view as? WinLossView {
            lossView.delegate = self
        }
        
        if let winView = self.view as? WinLossView {
            winView.delegate = self
        }
        
        // Set the AR view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true

        // Start up the background music
        BGSoundController.background_Sound_Controller.playBackgroundMusic(file_name: "accordion_fast", file_extension: "mp3")
        
        // Load the SKScene from 'Scene.sks'
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        //configuration.planeDetection = .horizontal // This was commented out b.c. the func view would on its own be called without any prompt from viewcontroller otherwise.
        //configuration.worldAlignment = .gravityAndHeading
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        // Create and configure a node for the anchor added to the view's session.
        var labelNode:SKSpriteNode
        if count == 5 || count == 10 || count == 15 {
            labelNode = SKSpriteNode(imageNamed: "xBrushstrokes")
            labelNode.name = "x"
        }
        else{
            labelNode = SKSpriteNode(imageNamed: "brushstroke")
        }

        labelNode.setScale(5)
        labelNode.xScale = 20
        let boundingBoxNode = SKShapeNode(rectOf: labelNode.calculateAccumulatedFrame().size)
        boundingBoxNode.lineWidth = 1
        boundingBoxNode.strokeColor = .red
        boundingBoxNode.fillColor = .clear
        boundingBoxNode.path = boundingBoxNode.path?.copy(dashingWithPhase: 0, lengths: [10,10])
        labelNode.addChild(boundingBoxNode)

        count += 1
        return labelNode
    }
    
    // Function implementation for HighScoresView and FirstView transitions
    func transitionToHighScores() {
        let highScoresStoryBoard:UIStoryboard = UIStoryboard(name:"HighScores", bundle:nil)
        let highScoresVC = highScoresStoryBoard.instantiateViewController(withIdentifier: "HighScoresViewController") as! HighScoresViewController
        self.present(highScoresVC, animated:true, completion:nil)
    }
    
    func transissionToMainMenu() {
        let FirstStoryBoard:UIStoryboard = UIStoryboard(name:"First", bundle:nil)
        let FirstScoresVC = FirstStoryBoard.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
        self.present(FirstScoresVC, animated:true, completion:nil)
    }
    
    /* Unemplemented, required functions */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }

}
