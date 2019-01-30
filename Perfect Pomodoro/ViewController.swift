//
//  ViewController.swift
//  Perfect Pomodoro
//
//  Created by Prudhvi Gadiraju on 1/28/19.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textField: UITextView!
    
    // 1500 and 300
    let lengthOfTime: Double = 1500
    let lengthOfBreakTime: Double = 300
    
    var timer: Timer = Timer()
    var time: Double = Double()
    
    var isOn: Bool = false {
        didSet {
            isOn ? button.setImage(#imageLiteral(resourceName: "StopButton"), for: .normal) : button.setImage(#imageLiteral(resourceName: "StartButton"), for: .normal)
            isOn ? (textField.text = "Focus") : (textField.text = "Ready?")
        }
    }
    var onBreak: Bool = false {
        didSet {
            if onBreak {
                textField.text = "Relax"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        time = lengthOfTime
        viewHeightConstraint.constant = 0
        button.setImage(#imageLiteral(resourceName: "StartButton"), for: .normal)
    }

    @IBAction func buttonAction(_ sender: Any) {
        if !isOn {
            time = lengthOfTime
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCall), userInfo: nil, repeats: true)
            isOn = true
        } else {
            timer.invalidate()
            isOn = false
            onBreak = false
        }
    }
    
    @objc func timerCall() {
        if time == 0 && !onBreak { startBreakTimer() }
        if time == 0 && onBreak { resetTimer() }
        
        time = time - 1
        
        updateLabel(time: time)
        animateView(time: time)
    }
    
    func updateLabel(time: Double) {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        timerLabel.text = String(format:"%02i:%02i", minutes, seconds)
    }
    
    func animateView(time: Double) {
        let frameHeight = view.frame.height
        var ratio: CGFloat {
            if isOn && !onBreak {
                return CGFloat(time/lengthOfTime)
            } else if onBreak {
                return CGFloat(time/lengthOfBreakTime)
            } else {
                return 1
            }
        }
        let height = (1-ratio)*frameHeight

        viewHeightConstraint.constant = height
        
        UIView.animate(
            withDuration: 1.0,
            delay: 0,
            options: .curveLinear,
            animations: {
                self.view.layoutIfNeeded()
        },
            completion: nil)
    }
    
    func startBreakTimer() {
        time = lengthOfBreakTime
        onBreak = true
    }
    
    func resetTimer() {
        time = lengthOfTime
        onBreak = false
        isOn = true
    }
}
