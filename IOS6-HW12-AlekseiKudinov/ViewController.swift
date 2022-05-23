//
//  ViewController.swift
//  IOS6-HW12-AlekseiKudinov
//
//  Created by Алексей Кудинов on 21.05.2022.
//

import UIKit

class ViewController: UIViewController, CAAnimationDelegate {


    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    let foreProgressLayer = CAShapeLayer()
    let backProgressLayer = CAShapeLayer()
    let animation = CABasicAnimation(keyPath: "strokeEnd")

    var isWorkTime = true
    var timer = Timer()
    var isAnimationStarted = false
    var isStarted = false
    var time = 1500

    override func viewDidLoad() {
        super.viewDidLoad()
        drawBackLayer()
    }

    @IBAction func startButtonTapped(_ sender: Any) {
        cancelButton.isEnabled = true
        cancelButton.alpha = 1.0
        if !isStarted {
            drawForeLayer()
            startResumeAnimation()
            startTimer()
            isStarted = true
            startButton.setTitle("Pause", for: .normal)
            startButton.setTitleColor(UIColor.orange, for: .normal)

        } else {
            pauseAnimation()
            timer.invalidate()
            isStarted = false
            startButton.setTitle("Resume", for: .normal)
            startButton.setTitleColor(UIColor.green, for: .normal)
        }
    }


    @IBAction func cancelButtonTapped(_ sender: Any) {
        stopAnimation()
        isWorkTime = true
        cancelButton.isEnabled = false
        cancelButton.alpha = 0.5
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(UIColor.green, for: .normal)
        backProgressLayer.strokeColor = UIColor.white.cgColor
        timer.invalidate()
        time = 1500
        isStarted = false
        timeLabel.text = "25:00"

    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        if isWorkTime == true && time < 1 {
            isWorkTime = false
            cancelButton.isEnabled = false
            cancelButton.alpha = 0.5
            startButton.setTitle("Relax", for: .normal)
            startButton.setTitleColor(UIColor.systemCyan, for: .normal)
            backProgressLayer.strokeColor = UIColor.blue.cgColor
            timer.invalidate()
            time = 300
            isStarted = false
            timeLabel.text = "5:00"
        } else {
            time -= 1
            timeLabel.text = formatTime()
        }
        if isWorkTime != true && time < 1 {
            isWorkTime = true
            cancelButton.isEnabled = false
            cancelButton.alpha = 0.5
            startButton.setTitle("Start", for: .normal)
            startButton.setTitleColor(UIColor.green, for: .normal)
            backProgressLayer.strokeColor = UIColor.white.cgColor
            timer.invalidate()
            time = 1500
            isStarted = false
            timeLabel.text = "25:00"
        } else {
            timeLabel.text = formatTime()
        }

    }

    func formatTime() -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60

        return String(format: "%02i:%02i", minutes, seconds)

    }

    //background layer
    func drawBackLayer() {
        backProgressLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY), radius: 100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath

        backProgressLayer.strokeColor = UIColor.white.cgColor
        backProgressLayer.fillColor = UIColor.clear.cgColor
        backProgressLayer.lineWidth = 15
        view.layer.addSublayer(backProgressLayer)
    }

    // fore layer
    func drawForeLayer() {
        foreProgressLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY), radius: 100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath

        foreProgressLayer.strokeColor = UIColor.green.cgColor
        foreProgressLayer.fillColor = UIColor.clear.cgColor
        foreProgressLayer.lineWidth = 15
        view.layer.addSublayer(foreProgressLayer)
    }

    func startResumeAnimation() {
        if !isAnimationStarted && isWorkTime == true {
            startAnimation(with: 1500)
        } else {
            resumeAnimation()
        }
        if !isAnimationStarted && isWorkTime == false {
            startAnimation(with: 300)
        } else {
            resumeAnimation()
        }

    }

    func startAnimation(with duration: CFTimeInterval) {
        resetAnimation()
        foreProgressLayer.strokeEnd = 0.0
        animation.keyPath = "strokeEnd"
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = duration
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        foreProgressLayer.add(animation, forKey: "strokeEnd")
        isAnimationStarted = true
    }

    func resetAnimation() {
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        foreProgressLayer.strokeEnd = 0.0
        isAnimationStarted = false

    }

    func pauseAnimation() {
        let pausedTime = foreProgressLayer.convertTime(CACurrentMediaTime(),from: nil)
        foreProgressLayer.speed = 0.0
        foreProgressLayer.timeOffset = pausedTime
    }

    func resumeAnimation() {
        let pausedTime = foreProgressLayer.timeOffset
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        let timeSincePaused = foreProgressLayer.convertTime(CACurrentMediaTime(),from: nil) - pausedTime
        foreProgressLayer.beginTime = timeSincePaused
    }

    func stopAnimation() {
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        foreProgressLayer.strokeEnd = 0.0
        foreProgressLayer.removeAllAnimations()
        isAnimationStarted = false
    }

    internal func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        stopAnimation()
    }

}

extension Int {
    var degreesToRadians: CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
