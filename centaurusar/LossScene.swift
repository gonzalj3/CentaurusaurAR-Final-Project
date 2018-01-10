//
//  LossScene.swift
//  centaurusar
//
//  Created by Connor Wallace on 8/13/17.
//  Copyright © 2017 Jose Gonzalez. All rights reserved.
//

import AVFoundation
import Foundation
import SpriteKit
import UIKit

class LossScene: SKScene {
	
	var plankLabel:SKLabelNode?
	
	override func didMove(to view: SKView) {
		plankLabel = self.childNode(withName:"plankLabel") as? SKLabelNode
		let fadeAction = SKAction.fadeIn(withDuration:5)
		self.plankLabel?.run(fadeAction)
        
        // Stop the background music and play a depressing sound to let the player
        // know how disapointed in them we are...
        BGSoundController.background_Sound_Controller.playSoundEffect(file_name: "GameOver", file_extension: "mp3", delay: 2.5, loop_num: 0)
        
        // Transition back to the main menu after the player has had enough time to
        // think about what went so terribly wrong.
        //usleep(5000000)
        //transitionToMainMenu()
	}
	
    // Transition back to the main menu on player loss
    func transitionToMainMenu() {
        if let lossView = self.view as? WinLossView {
            lossView.mmTransitionDelegate!.transissionToMainMenu()
        } else {
            print("Failed at cast to WinLossView")
        }
    }
    
	override func update(_ currentTime: TimeInterval) {
	}
}

