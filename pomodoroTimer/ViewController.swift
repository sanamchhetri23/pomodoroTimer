//
//  ViewController.swift
//  pomodoroTimer
//
//  Created by Peek A Boo on 2024-12-22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var timers: [String: Int] = ["Focus": 15, "Long": 9, "Short": 3]
    
    var totalTime = 0
    var secondPassed = 0
    var timer: Timer?
    var player: AVAudioPlayer?
    
    @IBOutlet var pomodoroText: UILabel!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var timesRemaining: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        // Invalidate the previous timer and reset values
        timer?.invalidate()
        totalTime = 0
        secondPassed = 0
        
        let currentTitle = sender.currentTitle!
        switch currentTitle {
        case "Focus":
            totalTime = timers["Focus"]!
        case "Long":
            totalTime = timers["Long"]!
        default:
            totalTime = timers["Short"]!
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        pomodoroText.text = "You have selected to \(currentTitle)"
    }
    
    func playSound(){
        let path = Bundle.main.path(forResource: "alarm", ofType: "wav")!
        let url = URL(fileURLWithPath: path)
        
        do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
    }
    
    @objc func updateCounter() {
       
        if secondPassed <= totalTime {
            timesRemaining.text = String(totalTime - secondPassed)
            let percentageProgress = Float(secondPassed) / Float(totalTime)
            progressBar.progress = percentageProgress
            secondPassed += 1
        } else {
            if timer?.isValid == true {
                DispatchQueue.main.async {
                    self.pomodoroText.text = "Time's Up"
                    self.playSound()
                    
                }
                timer?.invalidate()
            }
        }
    }
}
