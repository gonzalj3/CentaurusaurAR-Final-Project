//
//  TimerLabel.swift
//  centaurusar
//
//  Created by Connor Wallace on 8/7/17.
//  Copyright © 2017 Jose Gonzalez. All rights reserved.
//

import Foundation
import SpriteKit

class TimerLabel: SKLabelNode {
	
	var end:NSDate!
	
	var start:NSDate?
	
	private func timeLeft() -> TimeInterval {
		let remaining = end.timeIntervalSinceNow
		return max(remaining, 0)
	}
	
	func update() {
		let timeLeft = Int(self.timeLeft())
        
        // Turn the timer red if time is about to run out and change music to fast drums!
        if(self.timeLeft() < 6) {
            self.fontColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1)
            BGSoundController.background_Sound_Controller.playBackgroundMusic(file_name: "in_game_drums", file_extension: "wav")
        } else {
            // If the player gets more time, go back to the fast accordion
            BGSoundController.background_Sound_Controller.playBackgroundMusic(file_name: "accordion_fast", file_extension: "mp3")
        }
        
		self.text = String(timeLeft)
	}
	
	func startWith(duration: TimeInterval) {
		start = NSDate()
		let now = NSDate()
		end = now.addingTimeInterval(duration)
	}
	
	func hasFinished() -> Bool {
		
		return timeLeft() == 0
	}
	
	func addTime() {
		end = end.addingTimeInterval(5)
	}
	
	func timeToWin() -> Int {
		let change = start?.timeIntervalSinceNow
		var winTime = Int(change!)
		winTime = winTime * -1
		return winTime
	}
}
