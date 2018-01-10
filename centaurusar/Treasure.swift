//
//  Treasure.swift
//  centaurusar
//
//  Created by Connor Wallace on 8/13/17.
//  Copyright © 2017 Jose Gonzalez. All rights reserved.
//

import Foundation

import Foundation
import SpriteKit

class Treasure: SKLabelNode {
	
	var treasures:Int = 0
	
	func update() {
		treasures += 1
		let treasStr:String = String(treasures)
		let message:String = "Treasures: " + treasStr
		self.text = message
	}
	
	func start() {
		let treasStr:String = String(treasures)
		let message:String = "Treasures: " + treasStr
		self.text = message
	}
	
	func treasuresFound() -> Int {
		
		return treasures
	}
	
}
