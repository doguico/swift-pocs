//
//  ViewController.swift
//  Faceit
//
//  Created by Guido Corazza on 9/13/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {

    @IBOutlet weak var faceView: FaceView!{
        didSet{
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleEyes(byReactingTo:)))
            tapRecognizer.numberOfTapsRequired = 1
            
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHappiness))
            swipeUpRecognizer.direction = .up
            swipeUpRecognizer.numberOfTouchesRequired = 1
            
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHappiness))
            swipeDownRecognizer.direction = .down
            swipeDownRecognizer.numberOfTouchesRequired = 1
            
            let pinchRecognizer = UIPinchGestureRecognizer(target: faceView, action: #selector(FaceView.adjustScale(byReactingTo:)))
            
            faceView.addGestureRecognizer(pinchRecognizer)
            faceView.addGestureRecognizer(tapRecognizer)
            faceView.addGestureRecognizer(swipeUpRecognizer)
            faceView.addGestureRecognizer(swipeDownRecognizer)
            
            updateUI()
        }
    }

    func toggleEyes(byReactingTo tapRecognizer: UITapGestureRecognizer){
        if tapRecognizer.state == .ended {
            let eyes: FacialExpression.Eyes = (expression.eyes == .open) ? .closed : .open
            expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
        }
    }
    
    var expression = FacialExpression(eyes: .open, mouth: .neutral){
        didSet{
            updateUI()
        }
    }
    
    func increaseHappiness() {
        expression = expression.happier
    }
    
    
    func decreaseHappiness() {
        expression = expression.sadder
    }
    
    private func updateUI() {
        switch expression.eyes {
        case .open:
            faceView?.eyesOpen = true
        case .closed:
            faceView?.eyesOpen = false
        case .squinting:
            faceView?.eyesOpen = true
        }
        
        faceView?.mouthCurvature = mouthCurvature[expression.mouth] ?? 0.0
    }
    
    private let mouthCurvature = [FacialExpression.Mouth.frown: -0.5, FacialExpression.Mouth.grin: 0.5, FacialExpression.Mouth.neutral: 0.0, FacialExpression.Mouth.smile: 1.0, FacialExpression.Mouth.smirk: -1]
    
}

