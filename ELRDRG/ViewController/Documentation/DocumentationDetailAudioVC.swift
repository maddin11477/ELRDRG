//
//  DocumentationDetailAudioVC.swift
//  ELRDRG
//
//  Created by Martin Mangold on 04.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit


class DocumentationDetailAudioVC: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    //VC for Audio Memos
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var recordButton: RoundButton!
    @IBOutlet weak var audioControlSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var storageLocation: String = ""
    var audioName: String = ""
    var timer: Timer?
    let docuHandler: DocumentationHandler = DocumentationHandler()
    public var audioDocumentation : Documentation?
    

    @IBAction func saveAudioRecord(_ sender: UIBarButtonItem) {
        print("Audio gespeichert unter: \(storageLocation)")
        docuHandler.SaveAudioDocumentation(audioName: audioName, description: descriptionTextField.text!, saveDate: Date())
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
        
        if(audioDocumentation == nil){
            //neue Aufnahme
            print("Neue Aufnahme")
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
        } else {
            //änderung der bestehenden aufnahme...
            let attachment = audioDocumentation?.attachments?.allObjects[0] as! Attachment
            print("Try to load: \(attachment.uniqueName!).mp4")
            let audioFilename = getDocumentsDirectory().appendingPathComponent("\(attachment.uniqueName!).m4a")
            descriptionTextField.text = audioDocumentation?.content!
            recordButton.isHidden = true
            activateAudioPlayer(withFile: audioFilename)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startRecording() {
        let uuidOfAudio = NSUUID().uuidString
        audioName = uuidOfAudio
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
        activateAudioPlayer(withFile: audioRecorder.url.absoluteURL)
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
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playButton.setTitle("Play", for: .normal)
    }
    
    func activateAudioPlayer(withFile: URL){
        print("Audiofile \(withFile.absoluteString)")
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: withFile)
            audioPlayer.delegate = self
            audioControlSlider.maximumValue = Float(audioPlayer.duration)
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSliderPosition), userInfo: nil, repeats: true)
            playButton.isHidden = false
            audioControlSlider.isHidden = false
        } catch {
            print("Could not load audiofile")
        }
    }
    
    @IBAction func audioControlSliderChanged(_ sender: UISlider) {
        audioPlayer.stop()
        audioPlayer.currentTime = TimeInterval(audioControlSlider.value)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        if(audioPlayer.isPlaying == true){
            audioPlayer.pause()
            playButton.setTitle("Play", for: .normal)
        } else {
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            playButton.setTitle("Pause", for: .normal)
        }
    }
    
    @objc func updateSliderPosition() {
        audioControlSlider.value = Float(audioPlayer.currentTime)
    }

}
