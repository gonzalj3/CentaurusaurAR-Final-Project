//Class that can be used to track user distance travelled in CetaurusAR

import Foundation
import CoreMotion

class VRPedometer {
    var motion2: motionManger?
    
    let pedometer = CMPedometer()
    var curDistance:Int
    var curDistanceChange:Bool

    init() {
        self.curDistance = 0
        self.curDistanceChange = false

    }
    
    //function that begins collecting distance data from user
    func start() {
        self.motion2 = motionManger()
        if CMPedometer.isStepCountingAvailable() {
            if CMPedometer.isDistanceAvailable() {
                let date = Date()
                self.pedometer.startUpdates(from: date, withHandler: {(data:CMPedometerData?, error:Error?) -> Void in
                    if error == nil {
                        self.curDistance = data!.distance!.intValue
                        self.curDistanceChange = true
                    }
                    else {
                        print("Start update Failed")
                    }
                })
            }
            else {
                print("Distance Unavailable")
            }
        }
        else {
            print("Step Counting Unavailable")
        }
    }
    
    //checks that distance has begun collection
    //must be called before the first getDistance() call
    func hasDistance() -> Bool {
        return self.curDistanceChange
    }
    
    //returns current distance traveled by user as an integer
    func getDistance() -> Int {
        return self.curDistance
    }
    
}
