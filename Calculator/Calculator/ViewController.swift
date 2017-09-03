//
//  ViewController.swift
//  Calculator
//
//  Created by Guido Corazza on 9/3/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfWritingANumber = false
    var digits = [Double]()
    
    var displayValue: Double{
        get{
            return Double(display.text!)!
        }
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfWritingANumber = false
        }
    }

    @IBAction func appendDigit(_ sender: UIButton) {
        if userIsInTheMiddleOfWritingANumber {
            display.text = display.text! + sender.currentTitle!
        }
        else{
            userIsInTheMiddleOfWritingANumber = true
            display.text = sender.currentTitle!
        }
    }

    @IBAction func enter() {
        let digit = Double(display.text!)
        digits.append(digit!)
        userIsInTheMiddleOfWritingANumber = false
        print("\(digits)")
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfWritingANumber{
            enter()
        }
        switch operation{
            case "+": operate { $0 + $1 } //Closure
            case "−": operate { $1 - $0 }
            case "×": operate { $0 * $1 }
            case "÷": operate { $1 / $0 }
            case "√": operateSingleParameter { sqrt($0) }
            default: break
        }
    }
    
    func operate(operation: (Double, Double) -> Double){
        if digits.count >= 2{
            displayValue = operation(digits.removeLast(), digits.removeLast())
            enter()
        }
    }
    
    func operateSingleParameter(operation: (Double) -> Double){
        if digits.count >= 1{
            displayValue = operation(digits.removeLast())
            enter()
        }
    }
    
}

