//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by 郭坤 on 15/10/10.
//  Copyright © 2015年 Lambda Theory. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var buttonStop: UIButton!
    @IBOutlet weak var buttonRecord: UIButton!

    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear()
        lableRecording.text = "Tap to Record"
        buttonStop.hidden = true;
        buttonRecord.setImage(UIImage(named: "Record"), forState: UIControlState.Normal)
    }

    @IBOutlet weak var lableRecording: UILabel!
    
    @IBAction func recordAudio(sender: UIButton) {
        if audioRecorder == nil {
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            
            let recordingName = "my_audio.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryRecord)
            
            try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
        }
        
        if audioRecorder.recording {
            lableRecording.text = "Tap to continue"
            buttonRecord.setImage(UIImage(named: "Record"), forState: UIControlState.Normal)
            audioRecorder.pause()
        } else {
            if audioRecorder.currentTime == 0 { // Start a new recording
                audioRecorder.prepareToRecord()
            }
            
            lableRecording.text = "recording in progress"
            buttonRecord.setImage(UIImage(named: "Pause"), forState: UIControlState.Normal)
            
            audioRecorder.record()
        }
        buttonStop.hidden = false
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (!flag) {
            print("Recording audio has failed")
            buttonRecord.enabled = true
            buttonStop.hidden = true
            lableRecording.text = "Tap to Record"
            return
        }
        recordedAudio = RecordedAudio(pathUrl: recorder.url, fileTitle: recorder.url.lastPathComponent)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayback)
        
        self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            playSoundsVC.receivedAudio = sender as! RecordedAudio
        }
    }
    

    @IBAction func stopRecordAudio(sender: UIButton) {
        
        buttonRecord.enabled = true
        
        audioRecorder.stop()
        try! AVAudioSession.sharedInstance().setActive(false)
    }
}

