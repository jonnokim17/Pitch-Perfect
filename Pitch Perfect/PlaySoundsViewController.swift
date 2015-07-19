//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jonathan Kim on 7/18/15.
//  Copyright (c) 2015 Jonathan Kim. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!

    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.fileURL, error: nil)
        audioPlayer.enableRate = true

        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.fileURL, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioWithRate(0.5)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithRate(1.5)
    }

    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }

    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }

    @IBAction func playCathedralAudio(sender: UIButton) {
        playAudioWithReverbEffect(.Cathedral, mix: 50)
    }

    @IBAction func stopAudio(sender: UIButton) {
        stopAndResetAudio()
    }

    func playAudioWithRate(rate: Float) {
        stopAndResetAudio()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }

    func playAudioWithVariablePitch(pitch: Float) {
        stopAndResetAudio()

        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)

        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)

        audioPlayerNode.play()
    }

    func playAudioWithReverbEffect(preset: AVAudioUnitReverbPreset, mix: Float) {
        stopAndResetAudio()
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        var addReverbEffect = AVAudioUnitReverb()
        addReverbEffect.loadFactoryPreset(preset)
        addReverbEffect.wetDryMix = mix
        audioEngine.attachNode(addReverbEffect)

        audioEngine.connect(audioPlayerNode, to: addReverbEffect, format: nil)
        audioEngine.connect(addReverbEffect, to: audioEngine.outputNode, format: nil)

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)

        audioPlayerNode.play()
    }

    func stopAndResetAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
}
