//
//  Scene.swift
//  test2SpriteKitFail
//
//  Created by Jose Gonzalez on 7/17/17.
//  Copyright © 2017 Jose Gonzalez. All rights reserved.
//

import SpriteKit
import ARKit
import CoreMotion

class Scene: SKScene {
    var walk: VRPedometer?
    var motion: motionManger?
	
	let timer = TimerLabel()
	
	let treasures = Treasure()
	
	static var winTime:Int = 0
	
    var motionManager: CMMotionManager?
    
    var orientation: Double = 0
    var placed = false
    var first3 = false
    
    var increment = 0
    var oldDistance = 0
    var dist = 0
    var lastAnchorID: UUID?
    var xAnchorID: UUID?
    var count = 0
    var point = CGPoint(x:0.5, y:0.5)
    var topPoint = CGPoint(x:0.5, y:0.75)
    var bottomPoint = CGPoint(x:0.5, y:0.05)
    var letftPoint = CGPoint(x:0.25, y:0.5)
    var rightPoint = CGPoint(x:0.75, y:0.5)
    var iniAttitude = true
    var lastNode: SKNode?
    var anchorIDsPlaced = [UUID]()
    var screenSize = CGSize()
    var xOn = false
    var xTapCount = 0
    var gameLoop = 0
    var parentNode: SKNode?
    var foundX = false

    //var rotationOccured: Bool?
    
    override func didMove(to view: SKView) {
    // Setup your scene here
        print("getting data:")
        self.walk = VRPedometer()
        self.walk?.start()
        self.motion = motionManger()
        
        self.dist = (self.walk?.getDistance())!
		
		//initialize and ad timer
		let pos = CGPoint(x:0, y:265)
		timer.position = pos
        timer.fontName = "MarkerFelt-Wide"
		timer.fontSize = 45
		addChild(timer)
		timer.startWith(duration: 300)
		
		//initialize and add treasure count
		let treasurePos = CGPoint(x:0, y:-400)
		treasures.position = treasurePos
		treasures.fontSize = 45
		addChild(treasures)
		treasures.start()
		
    }
    
    override func update(_ currentTime: TimeInterval) {
	timer.update()
        

        
	//check is time is up
	if timer.hasFinished() && treasures.treasuresFound() < 3 {
		let scene = SKScene(fileNamed: "LossScene")!
		let transition = SKTransition.crossFade(withDuration: 3)
		self.view?.presentScene(scene, transition: transition)
	}
	if treasures.treasuresFound() >= 3 {
		Scene.winTime = timer.timeToWin()
		let scene = SKScene(fileNamed: "WinScene")!
		let transition = SKTransition.crossFade(withDuration: 3)
		self.view?.presentScene(scene, transition: transition)
	}

        addTickMark(cause: 1)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        if(count == 0){
                addTickMark(cause: 0)
        }
        else{
            if let touchLocation = touches.first?.location(in:sceneView){
                
                for x in (sceneView.scene?.nodes(at: touchLocation))!{
                    if(x.name == "x"){
                        parentNode = x.parent!
                        var labelNode:SKSpriteNode
                        labelNode = SKSpriteNode(imageNamed: "treasurechest")
                        let changeToTreasureChest = SKAction.setTexture(labelNode.texture!)
                        x.run(changeToTreasureChest)
                        x.action
                        self.foundX = true
                    }
                }
                if self.foundX == true {
                    let when = DispatchTime.now() + 4
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        self.parentNode?.removeAllChildren()
                        self.timer.startWith(duration: 90)
                        print("restart loop")
                        self.foundX = false
                        self.treasures.update()
                        print("The number of \(self.treasures.treasuresFound())******************")
                        self.restartLoop()
                    }
                }
                
            }
        }
        
    }

    func restartLoop(){
        count = 0
        placed = false
        first3 = false
        xOn = false
        let pos = CGPoint(x:0, y:265)
        timer.position = pos
        timer.fontName = "MarkerFelt-Wide"
        timer.fontSize = 45
        addChild(timer)
        timer.startWith(duration: 30)
    }

    
    func addTickMark(cause:Int){

        //The if statement below assures that if the calling fucntion is touchesBegan then no tick mark has been placed already.
        //As well, the if statement assures that if the calling function is update then a tick mark must have already been placed.
        
        if((cause == 0 && placed == false)||(cause == 1 && placed==true)){
            
            let groundPoint = self.motion?.getZGravity()
            if groundPoint!{
                // going need to add code to be able to get hit tests to determine actual distance in meters if thats possible at all.
                // Create a transform with a translation of 1.2 meters in front of the camera
                guard let sceneView = self.view as? ARSKView else {
                    return
                }
                if sceneView.scene?.nodes(at: point).count == 0 {
                    if sceneView.scene?.nodes(at: topPoint).count == 0 {
                        if sceneView.scene?.nodes(at: bottomPoint).count == 0 {
                            // Create anchor using the camera's current position
                            if let currentFrame = sceneView.session.currentFrame{
                                var translation = matrix_identity_float4x4
                                translation.columns.3.z = -1
                                let transform = simd_mul(currentFrame.camera.transform, translation)
                                
                                // Add a new anchor to the session
                                let anchor = ARAnchor(transform: transform)
                                lastAnchorID = anchor.identifier
                                sceneView.session.add(anchor: anchor)
                                anchorIDsPlaced.append(anchor.identifier)
                                placed = true
                                count = count + 1
                                
                                
                            }
                        }
                    }
                }
                
            }
            else if (self.motion?.getLookUp())!{
                guard let sceneView2 = self.view as? ARSKView else {
                    return
                }

                if lastNode != nil{
                }
                if count == 1 || count == 2
                {
                    placeSprite(sceneView2: sceneView2)
                }
                screenSize = (sceneView2.scene?.size)!
                for x in (sceneView2.scene?.nodes(at: CGPoint(x: 0.0, y: -300.0)))!{
                        if (sceneView2.anchor(for: x)?.identifier == lastAnchorID){

                            for y in (sceneView2.scene?.nodes(at: CGPoint(x: 0.0, y: -100.0)))!{
                                if (sceneView2.anchor(for: y)?.identifier == lastAnchorID){
                                    if(sceneView2.scene?.nodes(at: CGPoint(x:0.0, y:100.0)).count == 0){
                                        placeSpriteFurther(sceneView2: sceneView2)
                                    }
                                }
                            }
                    }
                }
            }
        }
    }
    
    func placeSprite(sceneView2: ARSKView){
        if let currentFrame = sceneView2.session.currentFrame{
            
            var translation3 = matrix_identity_float4x4
            translation3.columns.3.z = -4
            let transform3 = simd_mul(currentFrame.camera.transform, translation3)
            
            let anchorA = ARAnchor(transform: transform3)
            lastAnchorID = anchorA.identifier
            anchorIDsPlaced.append(anchorA.identifier)
            sceneView2.session.add(anchor: anchorA)
            
            lastNode = sceneView2.node(for: anchorA)
            lastNode?.name = "last+\(count)"
            print("node named placed is \(String(describing: lastNode?.name))")
            print("anchorID: \(String(describing: lastAnchorID))")
            placed = true
            first3 = true
            count = count + 1
        }
        
    }
    
    func placeSpriteFurther(sceneView2: ARSKView){
        if let currentFrame = sceneView2.session.currentFrame{
            
            var translation3 = matrix_identity_float4x4
            translation3.columns.3.z = -6
            let transform3 = simd_mul(currentFrame.camera.transform, translation3)
            
            let anchorA = ARAnchor(transform: transform3)
            lastAnchorID = anchorA.identifier
            anchorIDsPlaced.append(anchorA.identifier)
            sceneView2.session.add(anchor: anchorA)
            
            lastNode = sceneView2.node(for: anchorA)
            lastNode?.name = "last+\(count)"
            print("node named placed is \(String(describing: lastNode?.name))")
            print("anchorID: \(String(describing: lastAnchorID))")
            placed = true
            first3 = true
            count = count + 1
        }
        
    }
    
    func place3Sprites(sceneView2: ARSKView){
        if let currentFrame = sceneView2.session.currentFrame{
            //the one closest
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -1.5
            translation.columns.3.x = 0.5 //this works well but its the lower part of the screen
            let transform = simd_mul(currentFrame.camera.transform, translation)
            //the middle into the distance
            var translation2 = matrix_identity_float4x4
            translation2.columns.3.z = -3
            translation2.columns.3.x = -0.2 //this works well but its the lower part of the screen
            let transform2 = simd_mul(currentFrame.camera.transform, translation2)
            //the one farthest
            var translation3 = matrix_identity_float4x4
            translation3.columns.3.z = -9
            translation3.columns.3.x = -1.7 //this works well but its the lower part of the screen
            let transform3 = simd_mul(currentFrame.camera.transform, translation3)
            
            // Add two new anchors to the session
            let anchorA = ARAnchor(transform: transform)
            lastAnchorID = anchorA.identifier
            sceneView2.session.add(anchor: anchorA)
            
            let anchorB = ARAnchor(transform: transform2)
            lastAnchorID = anchorB.identifier
            sceneView2.session.add(anchor: anchorB)
            
            let anchorC = ARAnchor(transform: transform3)
            lastAnchorID = anchorC.identifier
            sceneView2.session.add(anchor: anchorC)
            
            placed = true
            first3 = true
            count = count + 1
            
            if iniAttitude != false{
                print("the iniAttitude is \(iniAttitude)")
                self.motion?.confirmInitialAttitude() //So I am uncommenting this to now have it called straight from getLookUp
                //i am going to try to have the getInitialAttitude to get called by another function call inside getLookUp that being getAngles
                //cant do the above b.c. i would then be setting the initialAttitude as it poitns to the ground so will actually just have
                //getlookup to call getInitialAttitude and not call get angles to see if that works
                
                if(self.motion?.startingAttitude != nil){
                    iniAttitude = false
                    print("NOW the iniAttitude is \(iniAttitude)")
                }

                
            }
            else{
                self.motion?.canPlaceTick()
            }
            
            
        }
        
    }
    
}
