//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Guido Corazza on 9/4/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import Foundation

struct CalculatorBrain{
    
    private var accumulator: (value: Double, description: String)?
    
    var result: Double?{
        get{
            return accumulator?.value
        }
    }
    
    var description: String{
        get{
            if resultIsPending {
                print("result is pending")
                return pendingBinaryOperation!.description
            }
            return accumulator?.description ?? " "
        }
    }
    
    private enum Operation {
        case constant(Double, () -> String)
        case unaryOperation((Double) -> (Double), (String) -> String)
        case binaryOperation((Double, Double) -> Double, (String) -> String)
        case equals
        case random
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.constant(Double.pi, {"π"}),
        "e": Operation.constant(M_E, {"e"}),
        "√": Operation.unaryOperation(sqrt, {"√(" + $0 + ")"}),
        "±": Operation.unaryOperation({ -$0 }, {$0}),
        "cos": Operation.unaryOperation(cos, {"cos(" + $0 + ")"}),
        "+": Operation.binaryOperation({ $0 + $1 }, {$0 + " + "}),
        "−": Operation.binaryOperation({ $0 - $1 }, {$0 + " − "}),
        "×": Operation.binaryOperation({ $0 * $1 }, {$0 + " × "}),
        "÷": Operation.binaryOperation({ $0 / $1 }, {$0 + " ÷ "}),
        "=": Operation.equals,
        "Rad": Operation.random
    ]
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    private struct PendingBinaryOperation{
        let function: (Double, Double) -> Double
        let firstOperand: Double
        let description: String
        
        func perform(with secondOperand: Double) -> Double{
            return function(firstOperand, secondOperand)
        }
    }
    
    private mutating func performPendingBinaryOperation(){
        if accumulator != nil && pendingBinaryOperation != nil {
            accumulator!.value = pendingBinaryOperation!.perform(with: accumulator!.value)
            accumulator!.description = pendingBinaryOperation!.description + accumulator!.description
            pendingBinaryOperation = nil
        }
    }
    
    private mutating func calculateRandomNumber(){
        let arc4randomMax = Double(UInt32.max)
        accumulator = (Double(arc4random()) / arc4randomMax, accumulator!.1.appending("Random number"))
    }
    
    mutating func performOperation(_ symbol: String){
        if let operation = operations[symbol]{
            switch operation{
            case .constant(let constant, let description):
                accumulator = (constant, description())
            case .unaryOperation(let mathFunction, let setDescription):
                if accumulator != nil {
                    accumulator = (mathFunction(accumulator!.value), setDescription(accumulator!.description))
                }
            case .binaryOperation(let mathFunction, let setDescription):
                if accumulator != nil  {
                    pendingBinaryOperation = PendingBinaryOperation(function: mathFunction, firstOperand: accumulator!.value, description: setDescription(accumulator!.description))
                    accumulator = nil
                }
            case .equals(): performPendingBinaryOperation()
            case .random: calculateRandomNumber()
            }
            
            print("performOperation")
            print("description: " + description)
        }
    }
    
    mutating func setOperand(_ operand: Double){
        accumulator = (operand, String(operand))
        print("setOperand")
        print("description: " + description)


//        if resultIsPending {
//            accumulator = (operand, accumulator!.1 + String(operand))
//        }
//        else{
//            accumulator = (operand, String(operand))
//        }
//        print("En set operand")
//        print("value " + "\(accumulator!.value)")
//        print("description " + accumulator!.description)
    }
}

