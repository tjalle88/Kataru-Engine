//
//  KESoundModule.swift
//  Kataru Engine
//
//  Created by Kalle Jönsson on 2017-09-17.
//  Copyright © 2017 Takemaki Software. All rights reserved.
//

import Foundation
import AVFoundation

enum LoadFileError: Error {
	case fileNotFound(String)
	case noPlayerAvailable(String)
	case fileNotInStrings(String)
	case unknownError(String)
	
}

class KEAudioModule {
	
	fileprivate var audioEngine: AVAudioEngine
	fileprivate var playerNodeBGM: AVAudioPlayerNode
    fileprivate var soundPlayers: [KEAudioPlayer]
	fileprivate var bgmPlaybackComplete: Bool
	fileprivate var bgmSongPlaying: String
	fileprivate let audioTimeZero = AVAudioTime(sampleTime: 0, atRate: 44100)
	
	
    init(numberOfSoundPlayers: Int) {
		
		print("Creating Audio Module...")

		
		audioEngine = AVAudioEngine()
		playerNodeBGM = AVAudioPlayerNode()
		
		
		audioEngine.attach(playerNodeBGM)
		audioEngine.connect(playerNodeBGM, to: audioEngine.mainMixerNode, format: nil)
		
        //Create the number of players requested
		soundPlayers = [KEAudioPlayer]()
        for _ in 1...numberOfSoundPlayers {
            soundPlayers.append(KEAudioPlayer())
        }
        
        //Connect the players
        for player in soundPlayers {
            audioEngine.attach(player.node)
            audioEngine.connect(player.node, to: audioEngine.mainMixerNode, format: nil)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("Engine start failure")
        }
		
		bgmPlaybackComplete = false
		
		bgmSongPlaying = ""
        
	}
	

	
    func playBGM(songName: String) {
		
		if songName == "" {
			return
		}
		
		if songName == bgmSongPlaying {
			return
		}
		
        //error handling?
        var fileName = "\(NSLocalizedString(songName, tableName: "BGM", bundle: Bundle.main, value: "", comment: ""))"
        
        let split = fileName.components(separatedBy: ".")
        fileName = split[0]
        let fileType: String = split[1]
        
        do {
        try loadMusic(fileName: fileName, fileType: fileType)
        } catch {
            return
        }
		
		playerNodeBGM.play()
	}
	
	func pauseBGM() {
		
		if !bgmPlaybackComplete {
			playerNodeBGM.pause()
		}
		else {
			playerNodeBGM.stop()
		}
		
	}
    

    func playSoundEffect(effectName: String) {
        
        //error handling?
        var fileName = "\(NSLocalizedString(effectName, tableName: "SoundEffects", bundle: Bundle.main, value: "", comment: ""))"
        let split = fileName.components(separatedBy: ".")
        fileName = split[0]
        let fileType: String = split[1]
        
        do{
			
        	let player = try loadSound(fileName: fileName, fileType: fileType)
        	player.play()
			
        } catch{
			
			
			
        }
        
    }
	
	//Playback completetion handler of bgm node
	func bgmCompletionHandler() {
		bgmPlaybackComplete = true
	}
	
    
    //Loads the requested file to the bgm player
    func loadMusic(fileName: String, fileType: String) throws {
        
        var audioFile: AVAudioFile
        
        print("Getting file path...")
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: fileType) else{
            throw LoadFileError.fileNotFound("File path not found")
        }
        let url = URL(fileURLWithPath: path)
        
        print("Assigning path to AVAudiofile")
        
        try audioFile = AVAudioFile(forReading: url)
		
		if bgmPlaybackComplete {
			playerNodeBGM.stop()
			bgmPlaybackComplete = false
		}
		playerNodeBGM.scheduleFile(audioFile, at: audioTimeZero , completionHandler: bgmCompletionHandler)
        
    }
    
    
    //Allocates a sound player, schedules the requested sound and returns the player
	func loadSound(fileName: String, fileType: String) throws -> KEAudioPlayer {
		
        //Find a free player
        var myPlayer: KEAudioPlayer?
		var availablePlayers = [KEAudioPlayer]()
		var playerWithFileFound: Bool = false
        
        for player in soundPlayers {
            
            if !player.isPlaying && player.audioFileName == fileName {
                myPlayer = player
				playerWithFileFound = true
                break
				
			} else if !player.isPlaying {
				
				availablePlayers.append(player)
				
			}
            
        }
		
		if !playerWithFileFound && availablePlayers.count > 0 {
			print("Idle player was found. No player with reusable file was found.")
			myPlayer = availablePlayers[0]
		} else if !playerWithFileFound && availablePlayers.count == 0 {
			print("No player available")
			throw LoadFileError.noPlayerAvailable("No idle player was found")
		}
		
		if playerWithFileFound {
			
			print("Player with the requested file found. Rescheduling file.")
			
			if let unwrappedPlayer = myPlayer {
				
				try unwrappedPlayer.rescheduleFile(at: audioTimeZero)
				
				return unwrappedPlayer
				
			} else {
				
				throw LoadFileError.unknownError("myPlayer unwrapped to nil even though the flag PlayerWithFileFound was true")
				
			}
			
			
		} else {
			
			var audioFile: AVAudioFile
			
			print("Getting file path...")
			
			guard let path = Bundle.main.path(forResource: fileName, ofType: fileType) else{
				print("File not found")
				throw LoadFileError.fileNotFound("File path was not found")
			}
			let url = URL(fileURLWithPath: path)
			
			print("Assigning path to AVAudiofile")
			
			try audioFile = AVAudioFile(forReading: url)
			
			if let unwrappedPlayer = myPlayer
			{
				unwrappedPlayer.scheduleFile(fileName: fileName, file: audioFile, at: audioTimeZero)
				
				return unwrappedPlayer
				
			} else {
				print("No player available")
				throw LoadFileError.unknownError("Player unwrapped to nil unexpectedly")
			}
			
		}
		


		
	}
	
}
