//
//  FaceView.swift
//  Faceit
//
//  Created by Guido Corazza on 9/13/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {

    @IBInspectable
    var scale: CGFloat = 0.9
    @IBInspectable
    var mouthCurvature: Double = 1.0
    @IBInspectable
    var eyesOpen = true
    @IBInspectable
    var lineWidth: CGFloat = 5.0
    @IBInspectable
    var color: UIColor = UIColor.blue
    

    private var skullRadius: CGFloat{
        return min(bounds.width, bounds.height) / 2 * scale
    }
    
    private var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private func pathForSkull() -> UIBezierPath{
        let path = UIBezierPath()
        path.addArc(withCenter: skullCenter, radius: skullRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
        path.lineWidth = lineWidth
        return path
    }
    
    private enum Eye {
        case left
        case right
    }
    
    private func pathForEye(_ eye: Eye) -> UIBezierPath {
        var eyeCenter = skullCenter
        eyeCenter.y -= 55
        eyeCenter.x += ((eye == .right ? 1 : -1) * 55)
        
        let eyeRadius = skullRadius / 6
        let path: UIBezierPath
       
        
        if eyesOpen {
            path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
        }
        else {
            path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
        }
        path.lineWidth = lineWidth
        return path
    }
    
    private func pathForMouth() -> UIBezierPath {
        let squareWidth = skullRadius / Ratios.skullRadiusToMouthWidth
        let squareHeight = skullRadius / Ratios.skullRadiusToMouthHeight
        
        let mouthRect = CGRect(x: skullCenter.x - squareWidth / 2,
                            y: skullCenter.y + squareHeight / 2,
                            width: squareWidth,
                            height: squareHeight)
        
        let smileOffSet = CGFloat(mouthCurvature) * squareHeight
        
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
        
        let firstControl = CGPoint(x: mouthRect.minX + squareWidth / 3, y: mouthRect.midY + smileOffSet)
        
        let secondControl = CGPoint(x: mouthRect.maxX - squareWidth / 3, y: mouthRect.midY + smileOffSet)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.lineWidth = lineWidth
        path.addCurve(to: end, controlPoint1: firstControl, controlPoint2: secondControl)

        return path
    }
    
    override func draw(_ rect: CGRect) {
        color.set()
        pathForSkull().stroke()
        pathForEye(.left).stroke()
        pathForEye(.right).stroke()
        pathForMouth().stroke()
        
    }
    
    private struct Ratios{
        static let skullRadiusToMouthWidth: CGFloat = 1
        static let skullRadiusToMouthHeight: CGFloat = 3
        static let skullRadiusToMouthOffset: CGFloat = 3
    }

}
