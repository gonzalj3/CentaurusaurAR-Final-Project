//
//  WinScene.swift
//  centaurusar
//
//  Created by Connor Wallace on 8/13/17.
//  Copyright © 2017 Jose Gonzalez. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class WinScene: SKScene {
	
	var treasuresFound = SKLabelNode()
	
	var part:String = "Aye Aye Matey! You Found All Of The Treasures in: "
	
	override func didMove(to view: SKView) {
        BGSoundController.background_Sound_Controller.playSoundEffect(file_name: "WinningCheer", file_extension: "wav")
		let treasureTime = String(Scene.winTime)
		part += treasureTime
		part += " seconds"
		treasuresFound.text = part
		let pos = CGPoint(x:0, y:0)
		treasuresFound.position = pos
		treasuresFound.fontSize = 30
		treasuresFound.fontName = "MarkerFelt-Thin"
		treasuresFound.alpha = 1
		//treasuresFound.numberOfLines = 5
		treasuresFound.fontColor = UIColor.black
		treasuresFound.lineBreakMode = NSLineBreakMode.byWordWrapping
		self.addChild(treasuresFound)
        
        // Save this rounds score
        saveScore(winTime: Scene.winTime)
        
        // Transission to the high scores view after five seconds
        //usleep(5000000)
        //transitionToHighScoresView()
	}
    
    // Add the new score to the high scores file for display in the HighScores table view.
    // Format is Month d YYYY,winTime
    func saveScore(winTime:Int) {
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        let highScoresFile = dir[0].appending("/centaurus_highScores.csv")
        
        // Get the date for the new score
        let today = Date()
        let todayFormatter = DateFormatter()
        todayFormatter.locale = Locale(identifier: "en_US")
        todayFormatter.setLocalizedDateFormatFromTemplate("MMMdd")
        let scoreDate = todayFormatter.string(from:today)
        
        // Construct the new score entry (String)
        let score = scoreDate + "," + String(winTime) + " Seconds Remaining"
        
        // Grab the contents of the highscores file, add the new score to the table, and save the table to the file
        var highScores = NSArray(contentsOfFile:highScoresFile) as? [String]
        if (highScores != nil && highScores!.count > 0) {
            highScores!.append(score)
        } else {
            let firstHighScore:[String] = [score]
            highScores = firstHighScore
        }
        
        let highScoresToWrite = NSArray(array: highScores!)
        highScoresToWrite.write(toFile: highScoresFile, atomically: true)
    }
    
    // Transition to the high scores view upon winning a round
    func transitionToHighScoresView()
    {
        if let hsView = self.view as? WinLossView {
            hsView.hsTransitionDelegate!.transitionToHighScores()
        }
    }
    
	override func update(_ currentTime: TimeInterval) {
		
	}
}
