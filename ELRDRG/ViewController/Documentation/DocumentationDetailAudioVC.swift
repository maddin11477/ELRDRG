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
        audioPlayer.stop()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelAudioRecorder(_ sender: UIBarButtonItem) {
        if(audioPlayer != nil)
        {
            audioPlayer.stop()
            //audioPlayer = nil
        }
       
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
                            self.recordButton.isEnabled = true
                            self.recordButton.setTitleColor(UIColor.red, for: .normal)
                            self.recordButton.setTitle("", for: .normal)
                            self.recordButton.borderColor = UIColor.red
                            
                        } else {
                            print("Keine Erlaubnis für Audio")
                            self.recordButton.isEnabled = false
                            self.recordButton.setTitleColor(UIColor.lightGray, for: .normal)
                            self.recordButton.borderColor = UIColor.lightGray
                            self.recordButton.setTitle("", for: .normal)
                            let alertView = UIAlertController(title: "Keine Berechtigung", message: "Diese APP hat keine Berechtigung, um auf ihr Mikrofon zugreifen zu können", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertView.addAction(alertAction)
                            
                            //Directing to Settings
                            
                            
                            
                            var settingsAction = UIAlertAction(title: "Einstellungen", style: .default) { (_) -> Void in
                                let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                                UIApplication.shared.open(settingsUrl as! URL, options: [:], completionHandler: nil)
                                }
                            alertView.addAction(settingsAction)
                            
                            
                            self.present(alertView, animated: true, completion: nil)
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
            recordButton.setTitleColor(UIColor.lightGray, for: .normal)
            //recordButton.setTitle("", for: .normal)
           // recordButton.layer.borderColor = UIColor.lightGray.cgColor
            recordButton.borderColor = UIColor.lightGray
            
            recordButton.isEnabled = false
            
            
            activateAudioPlayer(withFile: audioFilename)
            //controlButton.titleLabel?.text = ""
            playButton.setTitle("", for: .normal)
            playButton.setTitleColor(UIColor(hue: 0.3889, saturation: 1, brightness: 0.59, alpha: 1.0), for: .normal)
            playButton.layer.borderColor =  UIColor(hue: 0.3889, saturation: 1, brightness: 0.59, alpha: 1.0).cgColor
            
            
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
            
            recordButton.setTitle("", for: .normal)
            recordButton.setTitleColor(UIColor.red, for: .normal)
            //recordButton.layer.borderColor = UIColor.red.cgColor
            recordButton.borderColor = UIColor.red
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
        //recordButton.isHidden = true
        recordButton.setTitleColor(UIColor.lightGray, for: .normal)
        recordButton.layer.borderColor = UIColor.lightGray.cgColor
        if success {
            playButton.setTitle("", for: .normal)
            playButton.setTitleColor(UIColor(hue: 0.3889, saturation: 1, brightness: 0.59, alpha: 1.0), for: .normal)
            playButton.layer.borderColor =  UIColor(hue: 0.3889, saturation: 1, brightness: 0.59, alpha: 1.0).cgColor
        } else {
            playButton.setTitle("", for: .normal)
            playButton.setTitleColor(UIColor(hue: 0.3889, saturation: 1, brightness: 0.59, alpha: 1.0), for: .normal)
            playButton.layer.borderColor =  UIColor(hue: 0.3889, saturation: 1, brightness: 0.59, alpha: 1.0).cgColor
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
        recordButton.borderColor = UIColor.lightGray
        recordButton.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playButton.setTitle("", for: .normal)
        playButton.setTitleColor(UIColor(hue: 0.3889, saturation: 1, brightness: 0.59, alpha: 1.0), for: .normal)
        playButton.layer.borderColor =  UIColor(hue: 0.3889, saturation: 1, brightness: 0.59, alpha: 1.0).cgColor
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
            //recordButton.setTitle("", for: .normal)
            //recordButton.layer.borderColor = UIColor.red.cgColor
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
            playButton.setTitle("", for: .normal)
            playButton.setTitleColor(UIColor(hue: 0.3889, saturation: 1, brightness: 0.59, alpha: 1.0), for: .normal)
            playButton.layer.borderColor =  UIColor(hue: 0.3889, saturation: 1, brightness: 0.59, alpha: 1.0).cgColor

        } else {
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            playButton.setTitle("", for: .normal)
            playButton.layer.borderColor = UIColor.red.cgColor
            playButton.setTitleColor(UIColor.red, for: .normal)
        }
    }
    
    @objc func updateSliderPosition() {
        if(audioPlayer != nil)
        {
            audioControlSlider.value = Float(audioPlayer.currentTime)
        }
        
    }

}
