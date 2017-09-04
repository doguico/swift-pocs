//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Guido Corazza on 9/4/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import Foundation

struct CalculatorBrain{
    
    private var accumulator: Double?
    
    var result: Double?{
        get{
            return accumulator
        }
    }
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "±": Operation.unaryOperation({ -$0 }),
        "cos": Operation.unaryOperation(cos),
        "+": Operation.binaryOperation({ $0 + $1 }),
        "−": Operation.binaryOperation({ $0 - $1 }),
        "×": Operation.binaryOperation({ $0 * $1 }),
        "÷": Operation.binaryOperation({ $0 / $1 }),
        "=": Operation.equals
        ]
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation{
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double{
            return function(firstOperand, secondOperand)
        }
    }
    
    private mutating func performPendingBinaryOperation(){
        if accumulator != nil && pendingBinaryOperation != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    mutating func performOperation(_ symbol: String){
        if let operation = operations[symbol]{
            switch operation{
            case .constant(let constant): accumulator = constant
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil  {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case.equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    mutating func setOperand(_ operand: Double){
        accumulator = operand
    }
    
    
    
}

