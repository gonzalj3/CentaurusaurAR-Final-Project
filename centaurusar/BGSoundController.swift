//
//  BGMusicPlayer.swift
//  centaurusar
//
//  Created by Patrick Stauch on 8/7/17.
//  Copyright © 2017 Jose Gonzalez. All rights reserved.
//

import AVFoundation

// Singleton for playing background music. Pass a music file name and type to playBackgroundMusic.
// Making this a singleton enables the background music to play from scene to scene without any complicated
// extra setup
class BGSoundController {
    static let background_Sound_Controller = BGSoundController()
    var background_sound_player: AVAudioPlayer?
    var currentlyPlayingFile:String?

    
    // playBackgroundMusic checks the currentlyPlaying flag and the file currently being played.
    // If no background music is currently being played OR if the file name passed during the most recent
    // call is different than the file name stored in currentlyPlayingFile, the play the specified background
    // music. This keeps background music that is already playing from restarting if a storyboard/scene
    // that plays the same music reloads.
    func playBackgroundMusic(file_name:String, file_extension:String) {
        if ((background_sound_player == nil && currentlyPlayingFile == nil) || ( !(background_sound_player!.isPlaying)  || currentlyPlayingFile! != file_name)) {
            let bg_music_url = Bundle.main.url(forResource: file_name, withExtension: file_extension)!
            do {
                background_sound_player = try AVAudioPlayer(contentsOf: bg_music_url)
                background_sound_player!.numberOfLoops = -1
                background_sound_player!.prepareToPlay()
                background_sound_player!.play()
                currentlyPlayingFile = file_name
            } catch {
                print("Could not play \(file_name)")
            }
        }
    }
    
    // Stop playing any background music. Print on error when called with no bg music.
    func stopBackgroundMusic() {
        if ( background_sound_player != nil && background_sound_player!.isPlaying ) {
            background_sound_player!.stop()
        } else {
            print("ERROR: stopBackgroundMusic() called when no background music playing. Check backgroundMusicPlayer.isPlaying before calling.")
        }
    }
    
    // Play a sound effect with an optional specified delay and lopp number.
    func playSoundEffect(file_name:String, file_extension:String, delay:TimeInterval = 0, loop_num:Int = 0) {
        let sound_url = Bundle.main.url(forResource: file_name, withExtension: file_extension)!
        do {
            background_sound_player = try AVAudioPlayer(contentsOf: sound_url)
            background_sound_player!.numberOfLoops = loop_num
            background_sound_player!.prepareToPlay()
            background_sound_player!.play()
            currentlyPlayingFile = file_name
        } catch {
            print("Could not play \(file_name)")
        }
    }
}
