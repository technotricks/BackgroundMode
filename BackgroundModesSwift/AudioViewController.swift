//
//  AudioViewController.swift
//  BackgroundModesSwift
//
//  Created by Alex Nagy on 12/12/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

/* "Getting it Done" Kevin MacLeod (incompetech.com)
 Licensed under Creative Commons: By Attribution 3.0 License
 http://creativecommons.org/licenses/by/3.0/
 */

import TinyConstraints
import AVFoundation

class AudioViewController: UIViewController {
    
    lazy var player: AVQueuePlayer = self.makePlayer()
    
    private lazy var songs: [AVPlayerItem] = {
        let songNames = ["Getting it Done"]
        return songNames.map {
            let url = Bundle.main.url(forResource: $0, withExtension: "mp3")!
            return AVPlayerItem(url: url)
        }
    }()
    
    lazy var songLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 34)
        label.textColor = #colorLiteral(red: 0.1764705882, green: 0.2039215686, blue: 0.2117647059, alpha: 1)
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28)
        label.textColor = #colorLiteral(red: 0.1764705882, green: 0.2039215686, blue: 0.2117647059, alpha: 1)
        return label
    }()
    
    lazy var playPauseButton: UIButton = {
        var button = UIButton()
        button.setTitle(button.isSelected ? "Pause" : "Play", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.03529411765, green: 0.5176470588, blue: 0.8901960784, alpha: 1)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(playPauseAction(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func playPauseAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            player.play()
        } else {
            player.pause()
        }
        
        playPauseButton.setTitle(playPauseButton.isSelected ? "Pause" : "Play", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupViews()
        addPeriodicTimeObserver()
    }
    
    func setupViews() {
        view.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9411764706, blue: 0.9450980392, alpha: 1)
        
        view.addSubview(songLabel)
        view.addSubview(timeLabel)
        view.addSubview(playPauseButton)
        
        songLabel.centerInSuperview(offset: CGPoint(x: 0, y: -20))
        timeLabel.centerInSuperview(offset: CGPoint(x: 0, y: 30))
        playPauseButton.edgesToSuperview(excluding: .top, insets: .bottom(10) + .right(10) + .left(10), usingSafeArea: true)
        playPauseButton.height(50)
    }
    
    func addPeriodicTimeObserver() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                AVAudioSession.Category.playAndRecord,
                mode: .default,
                options: [])
        } catch {
            print("Failed to set audio session category. Error: \(error)")
        }
        
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 100, timescale: 100), queue: DispatchQueue.main) { [weak self] time in
            guard let self = self else { return }
            let timeString = String(format: "%02.2f", CMTimeGetSeconds(time))
            
            // TODO: check applicationState
            
          
            
             if UIApplication.shared.applicationState == .active{
                        
                        
                         print("FG LOcation==\(timeString)")
                    }
                    else {
                                                print("BG LOcation==\(timeString)")

                    }
            
        }
    }
    
    private func makePlayer() -> AVQueuePlayer {
        let player = AVQueuePlayer(items: songs)
        player.actionAtItemEnd = .advance
        player.addObserver(self, forKeyPath: "currentItem", options: [.new, .initial] , context: nil)
        return player
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem",
            let player = object as? AVPlayer,
            let currentItem = player.currentItem?.asset as? AVURLAsset {
            songLabel.text = currentItem.url.lastPathComponent
        }
    }
    
}


