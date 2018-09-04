//
//  DocumentationDetailAudioVC.swift
//  ELRDRG
//
//  Created by Martin Mangold on 04.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
import AVFoundation

class DocumentationDetailAudioVC: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: RoundButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var storageLocation: String = ""
    
    @IBAction func saveAudioRecord(_ sender: UIBarButtonItem) {
        print("Audio gespeichert unter: \(storageLocation)")
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelAudioRecorder(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("Darf aufnehmen")
                    } else {
                        print("Keine Erlaubnis für Audio")
                    }
                }
            }
        } catch {
            // failed to record!
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startRecording() {
        let uuidOfAudio = NSUUID().uuidString
        let audioFilename = getDocumentsDirectory().appendingPathComponent("\(uuidOfAudio).m4a")
        storageLocation = audioFilename.absoluteString
        print("Speichert unter: \(audioFilename)")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            recordButton.setTitle("Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            recordButton.setTitle("Start", for: .normal)
        } else {
            recordButton.setTitle("Start", for: .normal)
            // recording failed :(
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }

}
