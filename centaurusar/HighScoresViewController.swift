//
//  HighScoresVCViewController.swift
//  centaurusar
//
//  Created by Patrick Stauch on 8/7/17.
//  Copyright © 2017 Jose Gonzalez. All rights reserved.
//

import UIKit
import AVFoundation

class HighScoresViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var table: UITableView!
    
    var HSFile:String!
    var highScores:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start background music if it isn't already playing
        BGSoundController.background_Sound_Controller.playBackgroundMusic(file_name: "accordion", file_extension: "mp3")
        
        // The stored high scores are located in the documents directory as a csv file
        // Find the documents directory
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        
        // If HSFile does not already exists, append the documents directory with centAR_highScores.csv
        // Otherwise, do not overwrite it.
        HSFile = dir[0].appending("/centaurus_highScores.csv")
        print(HSFile)
        
        // Parse the contents of the high scores file and load the high scores into the table view
        loadHighScores()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Get the number of high scores stored in the table, used during tableview construction
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScores.count
    }
    
    // Populate the tableview with the high scores, used during tableview construction
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Use a reusable cell so that it can be recycled to populate the table view with data
        let hsCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "hsCell")!
        hsCell.textLabel?.text = highScores[indexPath.row]
        return hsCell
    }
    
    // The high scores are stored in a file titled highScores.txt
    func loadHighScores() {
        // 2D array used to sort high scores
        var highScores_2D:[[String]] = [[]]
        
        
        if let loadedHighScores_csv = NSArray(contentsOfFile: HSFile) as? [String] {
            // Parse the high scores csv file into a 2D array so it can be sorted
            for highScore_csv in loadedHighScores_csv {
                let highScore_substr = highScore_csv.split(separator: ",")
                let highScore = [String(highScore_substr[0]),String(highScore_substr[1])]
                
                if (highScores_2D[0].count == 0) {
                    highScores_2D[0] = highScore
                }
                else if (highScore.count == 2) {
                    highScores_2D.append(highScore)
                } else {
                    print("Error appending high score to table. Ignoring entry.")
                    print("Error token is \(highScore).")
                }
            }
            
            // Sort the high scores in descneding order by high score (highScore[1])
            if(highScores_2D.count > 1) {
                highScores_2D.sort { $0[1] > $1[1]}
            }
        
            // Join each subarray in the 2D array back into a single string and append it to highscores
            for highScore_subarr in highScores_2D {
                let highScore = highScore_subarr.joined(separator: ": ")
                highScores.append(highScore)
            }
        }
        
        // If the file was empty, insert a special statement
        if (highScores.count == 0) {
            highScores.append("Arr! You haven't found any treasure yet!")
            highScores.append("How embarrrrrrasing!")
        }
        
        table.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
