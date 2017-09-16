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
        formatter.numberStyle = .decimal
        adjustLayout(for: self.view, UIDevice.current.orientation.isLandscape)
    }
    
    var displayValue: Double {
        get{
            return (NumberFormatter().number(from: display.text!)!.doubleValue)
        }
        set{
            display.text = formatter.string(for: newValue)
        }
    }
    
    func setDescription(_ evaluate: (result: Double?, isPending: Bool, description: String)){
        history.text = evaluate.isPending ?
            evaluate.description + " ..." :
            evaluate.result != nil ?
                evaluate.description + " =" : " "
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if digit == "." && !display.text!.contains(".") || digit != "." || !userIsInTheMiddleOfTyping {
            if userIsInTheMiddleOfTyping {
                let textCurrentlyInDisplay = display.text!
                display.text = textCurrentlyInDisplay + digit
            } else {
                display.text = digit == "." ? "0." : digit
                userIsInTheMiddleOfTyping = true
            }
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
        let evaluate = brain.evaluate()
        if let result = evaluate.result{
            displayValue = result
        }
        setDescription(evaluate)
    }
    
    @IBAction func resetCalculator() {
        brain = CalculatorBrain()
        let result = brain.evaluate(using: Dictionary<String, Double>())
        displayValue = result.result ?? 0
        userIsInTheMiddleOfTyping = false
        setDescription(result)
    }
    
    private let landscapeFunctionalitiesTag = 98
    private let portraitFunctionalitiesTag = 99
    
    func adjustLayout(for view: UIView, _ isLandscape: Bool){
        for view in view.subviews{
            if view.tag == landscapeFunctionalitiesTag {
                view.isHidden = !isLandscape
            }
            else if view.tag == portraitFunctionalitiesTag {
                view.isHidden = isLandscape
            }
            else {
                adjustLayout(for: view, isLandscape)
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        adjustLayout(for: self.view, UIDevice.current.orientation.isLandscape)
    }
    
    @IBAction func undoAction() {
        if userIsInTheMiddleOfTyping {
            // backspace
            if display.text!.characters.count > 0 {
                let character = display.text!.characters.popLast()
                print("Removed " + String(character!))
            }
        }
        else {
            // undo not storing M's value, but undo setting of a variable as operand
            // ToDo: but undo setting of a variable as operand
            brain.undo()
        }
    }
    
    @IBAction func setMemory() {
        brain.setOperand(variable: "M")
        displayValue = brain.evaluate().result ?? displayValue
    }
    
    @IBAction func getMemory() {
        userIsInTheMiddleOfTyping = false
        displayValue = brain.evaluate(using: ["M" : displayValue]).result ?? displayValue
    }
}


