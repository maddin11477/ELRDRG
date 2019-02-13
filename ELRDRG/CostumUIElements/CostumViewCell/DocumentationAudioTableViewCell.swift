//
//  DocumentationAudioTableViewCell.swift
//  ELRDRG
//
//  Created by Martin Mangold on 13.09.18.
//  Copyright © 2018 Martin Mangold. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class DocumentationAudioTableViewCell: UITableViewCell, AVAudioPlayerDelegate {

    var audioPlayer: AVAudioPlayer!
    var timer: Timer?
    var audiopath: String?
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var controllSlider: UISlider!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var controlButton: RoundButton!
    @IBAction func controlButtonPushed(_ sender: UIButton) {
        if(audioPlayer.isPlaying == true){
            audioPlayer.pause()
            controlButton.setTitle("Play", for: .normal)
        } else {
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            controlButton.setTitle("Pause", for: .normal)
        }
    }
    @IBAction func sliderValueCHanged(_ sender: Any) {
        audioPlayer.stop()
        audioPlayer.currentTime = TimeInterval(controllSlider.value)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            print("Try to load: \(audiopath!)")
            let audioFilename = getDocumentsDirectory().appendingPathComponent(audiopath!)
            activateAudioPlayer(withFile: audioFilename)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func activateAudioPlayer(withFile: URL){
        print("Audiofile \(withFile.absoluteString)")
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: withFile)
            audioPlayer.delegate = self
            controllSlider.maximumValue = Float(audioPlayer.duration)
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSliderPosition), userInfo: nil, repeats: true)
            controlButton.isHidden = false
            controllSlider.isHidden = false
        } catch {
            print("Could not load audiofile")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        controlButton.setTitle("Play", for: .normal)
    }
    
    @objc func updateSliderPosition() {
        controllSlider.value = Float(audioPlayer.currentTime)
    }

}
