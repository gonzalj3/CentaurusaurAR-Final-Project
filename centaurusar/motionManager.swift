//
//  motionManager.swift
//  test2SpriteKitFail
//
//  Created by Jose Gonzalez on 7/24/17.
//  Copyright © 2017 Jose Gonzalez. All rights reserved.
//

import CoreMotion

class motionManger {
    let motionManager = CMMotionManager()
    var deviceQuaternion: CMQuaternion?
    var deviceAceceleration: CMAcceleration?
    var pitchLower:Int
    var zUpperB:Int
    var zLowerB:Int
    var pitchUpper:Int
    var pitch:Int
    var yaw:Int
    var roll:Int
    var z:Int
    var y:Int
    var x:Int
    var startingAttitude: CMAttitude?
    var startingAttitudeTemp: CMAttitude?
    var attitudeValue: CMAttitude?
    var rollValue: Int
    var startingRoll: Int
    var canPlace = false
    var confirmAttitude = false
    var orientation: Double = 0
    
    init() {
        zUpperB = -90
        zLowerB = -102
        pitchLower = -5
        pitchUpper = 25
        pitch = 50
        z = 50
        yaw = 50
        roll = 50
        x = 50
        y = 50
        startingRoll = 50
        rollValue = 50
    }
    
    func getAngles(){
        if motionManager.isDeviceMotionAvailable && motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1.0 / 60.0
            motionManager.startAccelerometerUpdates()
            motionManager.deviceMotionUpdateInterval = 1/60.0
            motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: OperationQueue(), withHandler: { (deviceMotion, error) in
                guard let data = deviceMotion else { return }
                self.pitch = Int(self.deg(rad: data.attitude.pitch))
                self.yaw = Int(self.deg(rad: data.attitude.yaw))
                self.roll = Int(self.deg(rad: data.attitude.roll))
                self.z = Int(100*data.gravity.z)
  
                if(self.confirmAttitude==false){
                    self.startingAttitudeTemp = data.attitude
                    self.startingRoll = self.roll
                }
                self.attitudeValue = data.attitude
            })
        }
        return
}
    
    func confirmInitialAttitude(){
        self.startingAttitude = self.startingAttitudeTemp
        self.rollValue = self.startingRoll
        print("Starting Attitude is \(String(describing: self.startingAttitude))")
        self.confirmAttitude = true
    }
    
    func getInitialAttitude(){
        if motionManager.isDeviceMotionAvailable && motionManager.isAccelerometerAvailable {
            motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: OperationQueue(), withHandler: { (deviceMotion, error) in
                guard let data = deviceMotion else { return }
                self.pitch = Int(self.deg(rad: data.attitude.pitch))
                self.yaw = Int(self.deg(rad: data.attitude.yaw))
                self.roll = Int(self.deg(rad: data.attitude.roll))
                self.z = Int(100*data.gravity.z)
                if(self.startingAttitude == nil){
                 self.startingAttitude = data.attitude
                 }
            })
        }
        else{
            print("no data for self.startingattitude")
        }
        return
        
    }
    
    func mag(from attitude: CMAttitude)->Double{
        return sqrt(pow(attitude.roll, 2) + pow(attitude.yaw,2) + pow(attitude.pitch, 2))
    }
    

    
    func canPlaceTick()->Bool{

        let upperBoundAttitude = 0.6 //(self.mag(from: self.startingAttitude!) + 0.2) // if this gets called to soon after we get the initial attitude this wont work// may just need to figure out
        self.attitudeValue?.multiply(byInverseOf: (self.startingAttitude)!)
        
        // calculate magnitude of the change from our initial attitude
        let magData = self.mag(from: self.attitudeValue!)
        print("This is magData \(magData).")
        if magData == 0.0//< upperBoundAttitude //&& magData > lowerBoundAttitude
        {
            self.canPlace = true
        }
        else
        {
            self.canPlace = false
        }
        return canPlace
    }
    
    func rollCorrect()->Bool{
        let uB = self.rollValue + 3
        let lB = self.rollValue - 3
        
        if self.roll < uB && self.roll > lB{
            print ("Correct roll is: \(String(describing: self.roll))")
            return true
        }
        else{
            print ("Incorrect roll is: \(String(describing: self.roll))")

        return false
        }
    }
    
    
    func getZGravity()->Bool{
        getAngles()
        return pitch > pitchLower && pitch < pitchUpper && z > zLowerB && z < zUpperB
    }
    
    func getLookUp()->Bool{
                getAngles()
        return pitch > 70 && pitch < 85 && z > -29 && z < 5
    }
    
    func deg(rad:Double) -> Double{
        return 180 / Double.pi * rad
    }

}
