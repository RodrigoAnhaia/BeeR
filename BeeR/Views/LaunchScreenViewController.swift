//
//  LaunchScreenViewController.swift
//  BeeR
//
//  Created by Rodrigo Sanseverino de Anhaia on 04/02/24.
//

import UIKit
import AVFoundation

class LaunchScreenViewController: UIViewController {
    
    // MARK: - Propreties
    
    private var audioPlayer: AVAudioPlayer?
    
    private var logoImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 190, height: 186))
        imageView.image = UIImage(named: "launchScreen")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 0.2915426791, green: 0.5641855597, blue: 0.887370348, alpha: 1)
        
        self.view.addSubview(self.logoImageView)
        
        self.loadSound()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.playSoundAndNavigate()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.logoImageView.center = self.view.center
        
    }
    
    // MARK: - Private Methods
    
    fileprivate func loadSound() {
        guard let path = Bundle.main.path(forResource: "sfLaunchScreen", ofType: "wav") else {
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            self.audioPlayer?.prepareToPlay()
        } catch {
            print("Error loading sound file: \(error.localizedDescription)")
        }
    }
    
    fileprivate func playSoundAndNavigate() {
        self.audioPlayer?.play()
        
    }
}
