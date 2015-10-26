//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by 郭坤 on 15/10/10.
//  Copyright © 2015年 Lambda Theory. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    @IBOutlet weak var buttonSnail: UIButton!
    @IBOutlet weak var buttonRabbit: UIButton!
    @IBOutlet weak var buttonChipmuck: UIButton!
    @IBOutlet weak var buttonUdar: UIButton!
    
    @IBOutlet weak var buttonStop: UIButton!
    
    var audioEngine: AVAudioEngine!
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        try! audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        try! audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSnailClicked(sender: UIButton) {
        playAudioWithRate(0.5)
    }

    @IBAction func onRabbitClicked(sender: UIButton) {
        playAudioWithRate(1.5)
    }
    
    @IBAction func onChipmuckClicked(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func onUdarClicked(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func stopPlay(sender: UIButton) {
        stopPlay()
    }
    
    @IBAction func onReverbClicked(sender: UIButton) {
        
        let effect = AVAudioUnitReverb()
        effect.loadFactoryPreset(AVAudioUnitReverbPreset.MediumHall3)
        effect.wetDryMix = 50
        
        playAudioWithConfiguredEffect(effect)
    }
    
    @IBAction func onEchoClicked(sender: UIButton) {
        let effect = AVAudioUnitDelay()
        effect.wetDryMix = 50
        effect.delayTime = 0.5
        
        playAudioWithConfiguredEffect(effect)

    }
    
    func stopPlay() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioWithRate(rate: Float) {
        stopPlay()
        
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float) {

        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        
        playAudioWithConfiguredEffect(changePitchEffect)
    }
    
    func playAudioWithConfiguredEffect (effect: AVAudioUnit) {
        stopPlay()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        audioEngine.attachNode(effect)
        
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
}
