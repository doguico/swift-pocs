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
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    var brain = CalculatorBrain()
    
    var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }

    func setDescription(){
        history.text = brain.resultIsPending ? brain.description + " ..." : brain.description + " ="
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if digit == "." && display.text!.contains(".") && userIsInTheMiddleOfTyping{
            return
        }
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit == "." ? "0." : digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        } 
        if let symbol = sender.currentTitle {
            brain.performOperation(symbol)
        }
        if let result = brain.result{
            displayValue = result
        }
        
        setDescription()
    }
    
    @IBAction func resetCalculator() {
        brain = CalculatorBrain()
        print("\(brain.resultIsPending)")
        displayValue = 0
    }
}

