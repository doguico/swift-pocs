//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Guido Corazza on 9/4/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import Foundation

func factorial(number value : Double) -> Double {
    if value == 0.0 {
        return 1
    }
    return value * factorial(number: value - 1)
}

struct CalculatorBrain{
    private var stack: [Operands] = []
    var result: Double? {
        return evaluate().result
    }
    var description: String {
        return evaluate().description
    }
    var resultIsPending: Bool {
        return evaluate().isPending
    }
    
    private enum Operation {
        case constant(Double, (String) -> String)
        case unaryOperation((Double) -> (Double), (String) -> String)
        case binaryOperation((Double, Double) -> Double, (String) -> String)
        case equals
        case random
    }
    
    private enum Operands {
        case number(Double)
        case variable(String)
        case operation(String)
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.constant(Double.pi, { $0 + "π"}),
        "e": Operation.constant(M_E, { $0 + "e"}),
        "√": Operation.unaryOperation(sqrt, {"√(" + $0 + ")"}),
        "±": Operation.unaryOperation({ -$0 }, { "-(" + $0 + ")"}),
        "cos": Operation.unaryOperation(cos, {"cos(" + $0 + ")"}),
        "cosh": Operation.unaryOperation(cosh, {"cosh(" + $0 + ")"}),
        "sin": Operation.unaryOperation(sin, {"sin(" + $0 + ")"}),
        "sinh": Operation.unaryOperation(sin, {"sinh(" + $0 + ")"}),
        "tan": Operation.unaryOperation(tan, {"tan(" + $0 + ")"}),
        "tanh": Operation.unaryOperation(tan, {"tanh(" + $0 + ")"}),
        "x²": Operation.unaryOperation({ pow($0, 2) }, {"(" + $0 + ")²"}),
        "x³": Operation.unaryOperation({ pow($0, 3) }, { "(" + $0 + ")³"}),
        "x!": Operation.unaryOperation({ factorial(number: $0) }, { "(" + $0 + ")!" }),
        "eˣ": Operation.unaryOperation({ pow(M_E, $0) } ,{ "e^(" + $0 + ")"}),
        "%": Operation.unaryOperation({ $0 / 100 }, { "(" + $0 + ")%"}),
        "10ˣ": Operation.unaryOperation({ pow(10, $0) }, {"10^(" + $0 + ")"}),
        "log10": Operation.unaryOperation(log10, {"log(" + $0 + ")" }),
        "ln": Operation.unaryOperation(log, { "ln(" + $0 + ")" } ),
        "xʸ": Operation.binaryOperation(pow, { "(" +  $0 + ")^"}),
        "+": Operation.binaryOperation(+, {$0 + " + "}),
        "−": Operation.binaryOperation(-, {$0 + " − "}),
        "×": Operation.binaryOperation(*, {$0 + " × "}),
        "÷": Operation.binaryOperation(/, {$0 + " ÷ "}),
        "=": Operation.equals,
        "Rand": Operation.random
    ]
    
    func calculateRandomNumber() -> Double{
        return Double(arc4random()) / Double(UInt32.max)
    }
    
    mutating func performOperation(_ symbol: String){
        stack.append(Operands.operation(symbol))
    }
    
    mutating func setOperand(_ operand: Double){
        stack.append(Operands.number(operand))
    }
    
    mutating func setOperand(variable named: String){
        stack.append(Operands.variable(named))
    }
    
    private struct PendingBinaryOperation{
        let function: (Double, Double) -> Double
        let firstOperand: Double
        let description: String
        
        func perform(with secondOperand: Double) -> Double{
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func undo(){
        stack.popLast()
    }
    
    func evaluate(using variables: Dictionary<String,Double>? = nil)
        -> (result: Double?, isPending: Bool, description: String){
            var result: Double?
            var description = ""
            var pendingBinaryOperation: PendingBinaryOperation?
            
            if variables != nil {
                VariablesDictionary.variables = variables
            }
            
            func performPendingBinaryOperation(){
                if result != nil && pendingBinaryOperation != nil {
                    result! = pendingBinaryOperation!.perform(with: result!)
                    description = pendingBinaryOperation!.description.appending(description)
                    pendingBinaryOperation = nil
                }
            }
            
            func operate(with operation: Operation){
                switch operation {
                case .constant(let value, let setDescription):
                    result = value
                    description = setDescription(description)
                    print()
                case .unaryOperation(let op, let setDescription):
                    if result != nil {
                        result = op(result!)
                        description = setDescription(description)
                    }
                case .binaryOperation(let op, let setDescription):
                    if result != nil {
                        performPendingBinaryOperation()
                        description = setDescription(description)
                        pendingBinaryOperation = PendingBinaryOperation(function: op, firstOperand: result!, description: description)
                    }
                case .equals:
                    performPendingBinaryOperation()
                case .random:
                    result = calculateRandomNumber()
                    description = "Rand"
                }
            }
            
            for operand in stack {
                switch operand {
                case .number(let value):
                    result = value
                    description = String(result!)
                case .variable(let variable):
                    result = VariablesDictionary.variables?[variable] ?? 0.0
                    description = "M"
                case .operation(let value):
                    if let operation = operations[value] {
                        operate(with: operation)
                    }
                }
            }
            
            return (result, pendingBinaryOperation != nil, description)
    }
    
}

struct VariablesDictionary {
    static var variables: Dictionary<String, Double>?
}

