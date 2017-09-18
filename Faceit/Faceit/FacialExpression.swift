//
//  FacialExpression.swift
//  Faceit
//
//  Created by Guido Corazza on 9/17/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import Foundation

struct FacialExpression
{
    enum Eyes: Int {
        case open
        case closed
        case squinting
    }
    
    enum Mouth: Int {
        case frown
        case smirk
        case neutral
        case grin
        case smile
        
        var sadder: FacialExpression.Mouth {
            return Mouth(rawValue: rawValue - 1) ?? .grin
        }
        
        var happier: FacialExpression.Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .smile
        }
    }
    
    var sadder: FacialExpression {
        return FacialExpression(eyes: self.eyes, mouth: self.mouth.sadder)
    }
    
    var happier: FacialExpression {
        return FacialExpression(eyes: self.eyes, mouth: self.mouth.happier)
    }
    
    let eyes: Eyes
    let mouth: Mouth
}
