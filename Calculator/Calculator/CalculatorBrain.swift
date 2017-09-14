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
    
    var result: Double? {
        return accumulator?.value
    }
    var description: String {
        return resultIsPending ? pendingBinaryOperation!.description : accumulator?.description ?? " "
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    var resultIsPending: Bool {
        return pendingBinaryOperation != nil
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
        "+": Operation.binaryOperation(+, {$0 + " + "}),
        "−": Operation.binaryOperation(-, {$0 + " − "}),
        "×": Operation.binaryOperation(*, {$0 + " × "}),
        "÷": Operation.binaryOperation(/, {$0 + " ÷ "}),
        "=": Operation.equals,
        "Rad": Operation.random
    ]
    

    
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
        accumulator = (Double(arc4random()) / Double(UInt32.max), "RAD")
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
                    performPendingBinaryOperation()
                    pendingBinaryOperation = PendingBinaryOperation(function: mathFunction, firstOperand: accumulator!.value, description: setDescription(accumulator!.description))
                    accumulator = nil
                }
            case .equals(): performPendingBinaryOperation()
            case .random: calculateRandomNumber()
            }
        }
    }
    
    mutating func setOperand(_ operand: (Double, String)){
        accumulator = (operand.0, operand.1)
    }
    
    func setOperand(variable named: String){
    
    }
    
    func evaluate(using variables: Dictionary<String,Double>? = nil)
        -> (result: Double?, isPending: Bool, description: String){
            
            
            return (nil, false, "")
    }

}

