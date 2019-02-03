//
//  Graph.swift
//  Calculator
//
//  Created by Guido Corazza on 9/19/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit

class Graph: UIView {

    let drawer = AxesDrawer(color: UIColor.black, contentScaleFactor: 1)
    
    var scale: CGFloat {
        return 15
    }
    
    private var graphicOrigin: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private var graphicArea: CGRect {
        return CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: bounds.height)
    }
    override func draw(_ rect: CGRect) {
        drawer.drawAxes(in: rect, origin: graphicOrigin, pointsPerUnit: scale)
    }

}
