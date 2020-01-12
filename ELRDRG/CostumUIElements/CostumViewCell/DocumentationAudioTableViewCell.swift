//
//  DocumentationAudioTableViewCell.swift
//  ELRDRG
//
//  Created by Martin Mangold on 13.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
import AVKit


class DocumentationAudioTableViewCell: UITableViewCell, AVAudioPlayerDelegate {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var controllSlider: UISlider!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var controlButton: RoundButton!
    public var alreadyLoaded : Bool = false
    private var isStopped : Bool = true
    public var attchment : Attachment?
    public var audioPlayer : AVAudioPlayer?
    @IBOutlet var content: UILabel!
    var audioName: String = ""
    var storageLocation: String = ""
      var timer: Timer?
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isStopped = true
        //pressed STOP
       if #available(iOS 13.0, *)
       {
           controlButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
           controlButton.setTitle("", for: .normal)
       }
       else
       {
           controlButton.setTitle("PLAY", for: .normal)
           controlButton.titleLabel?.tintColor = UIColor(hue: 0.3889, saturation: 1, brightness: 0.59, alpha: 1.0)
       }
       
       controlButton.setTitleColor(UIColor(hue: 0.3889, saturation: 1, brightness: 0.59, alpha: 1.0), for: .normal)
       controlButton.imageView?.tintColor = UIColor(hue: 0.3889, saturation: 1, brightness: 0.59, alpha: 1.0)
       controlButton.borderColor =  UIColor(hue: 0.3889, saturation: 1, brightness: 0.59, alpha: 1.0)
        
    }
    
    @IBAction func controlButtonPushed(_ sender: UIButton)
    {
        if(isStopped)
        {
            //pressed PLAY
            if #available(iOS 13.0, *) {
                controlButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
                controlButton.setTitle("", for: .normal)
            } else {
                controlButton.setTitle("STOP", for: .normal)
                controlButton.titleLabel?.tintColor = UIColor.red
            }
            
            
            controlButton.imageView?.tintColor = UIColor.red
         
            controlButton.borderColor = UIColor.red
            isStopped = false
            
            
            if let player = audioPlayer
            {
                //wurde zuvor schon geladen
               // player.prepareToPlay()
                player.play()
            }
            else
            {
                // muss noch geladen werden und anschließend gestartet werden
                reloadAudioData()
                if let player = audioPlayer
                {
                    player.prepareToPlay()
                    player.play()
                }
            }
            
        }
        else
        {
            //pressed STOP
            if #available(iOS 13.0, *)
            {
                controlButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                controlButton.setTitle("", for: .normal)
            }
            else
            {
                controlButton.setTitle("PLAY", for: .normal)
                controlButton.titleLabel?.tintColor = UIColor(hue: 0.3889, saturation: 1, brightness: 0.59, alpha: 1.0)
            }
            
            controlButton.setTitleColor(UIColor(hue: 0.3889, saturation: 1, brightness: 0.59, alpha: 1.0), for: .normal)
            controlButton.imageView?.tintColor = UIColor(hue: 0.3889, saturation: 1, brightness: 0.59, alpha: 1.0)
            controlButton.borderColor =  UIColor(hue: 0.3889, saturation: 1, brightness: 0.59, alpha: 1.0)
            isStopped = true
            if let player = audioPlayer
            {
                player.pause()
            }
        }
    }
    @IBAction func sliderPositionChanged(_ sender: Any) {
          if let player = audioPlayer
          {
            
            player.stop()
            player.currentTime = TimeInterval(controllSlider.value)
            player.prepareToPlay()
            if(isStopped == false)
            {
                player.play()
            }
            
          }
    }
    
   @objc func updateSliderPosition() {
        if(audioPlayer != nil)
        {
            controllSlider.value = Float(audioPlayer?.currentTime ?? 0.0)
        }
        
    }
    
    func reloadAudioData()
    {
        
       if let attach = self.attchment
       {
           print("Try to load: \(attach.uniqueName!).mp4")
           let audioFilename = getDocumentsDirectory().appendingPathComponent("\(attach.uniqueName!).m4a")
           activateAudioPlayer(withFile: audioFilename)
       }
       else
       {
           return
       }
       
    }
    
    func activateAudioPlayer(withFile: URL){
       
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: withFile)
            
            audioPlayer?.delegate = self
            controllSlider.maximumValue = Float(audioPlayer?.duration ?? 0.0)
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSliderPosition), userInfo: nil, repeats: true)
            
          
        } catch {
            print("Could not load audiofile")
        }
    }
    func getDocumentsDirectory() -> URL {
           let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
           return paths[0]
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //änderung der bestehenden aufnahme...
        
       
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
