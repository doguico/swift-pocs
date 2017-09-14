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
    var formatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        formatter.maximumFractionDigits = 6
        //formatter.minimumFractionDigits = 0
        formatter.numberStyle = .decimal
    }
    
    var displayValue: Double {
        get{
            return (NumberFormatter().number(from: display.text!)!.doubleValue)
        }
        set{
            display.text = formatter.string(for: newValue)
        }
    }
    
    func setDescription(){
        history.text = brain.resultIsPending ? brain.description + " ..." : brain.result != nil ? brain.description + " =" : " "
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if digit == "." && display.text!.contains(".") && userIsInTheMiddleOfTyping {
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
        brain.setOperand(0.0)
        displayValue = 0
        userIsInTheMiddleOfTyping = false
        setDescription()
    }
    
    
}

