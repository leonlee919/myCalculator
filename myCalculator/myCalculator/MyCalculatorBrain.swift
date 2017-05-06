//
//  myCalculatorBrain.swift
//  myCalculator
//
//  Created by Yang Li on 30/03/2017.
//  Copyright © 2017 Yang Li. All rights reserved.
//

import Foundation


struct MyCalculatorBrain {
    
    private var accumulator : Double?
    private var resultIsPending = false
    private var description = " "
 
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
        
    }
    
    private var operations: Dictionary<String, Operation> =
    [
        "π" : Operation.constant(Double.pi),
        "C" : Operation.constant(Double(0)),
        "e" : Operation.constant(M_E),
        "Rand" : Operation.constant(Double(arc4random_uniform(38))),
        "√" : Operation.unaryOperation(sqrt),
        "%" : Operation.unaryOperation({$0 / 100}),
        "cos" : Operation.unaryOperation(cos),
        "±" : Operation.unaryOperation({-$0}),
        "+" : Operation.binaryOperation({$0 + $1}),
        "−" : Operation.binaryOperation({$0 - $1}),
        "×" : Operation.binaryOperation({$0 * $1}),
        "÷" : Operation.binaryOperation({$0 / $1}),
        "xⁿ" : Operation.binaryOperation({pow($0, $1)}),
        "=" : Operation.equals
        
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
                if symbol == "C" {
                    description = " "
                } else {
                    description = symbol
                }
            case .unaryOperation(let function):
                if accumulator != nil {
                    if description == String(describing: accumulator!)  {
                        description = symbol + String(describing: accumulator!)
                        accumulator = function (accumulator!)
                    } else {
                        
                        if !resultIsPending {
                            description = symbol + "(" + description + ")"
                            
                        }
                        else {
                            description = description.replacingOccurrences(of: String(describing: accumulator!), with: symbol + String(describing: accumulator!))
                        }
                        accumulator = function (accumulator!)
                    }
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    description += symbol
                    if !resultIsPending {
                        pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand:accumulator!)
                        resultIsPending = true
                    } else {
                        performPendingBinaryOperation()
                        pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand:accumulator!)
                    }
                    accumulator = nil
                }
            case .equals:
                
                performPendingBinaryOperation()
                resultIsPending = false
                
                }
            }
        }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            
            
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    

    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand : Double
        func perform (with secondOperand: Double) -> Double {
            return function (firstOperand, secondOperand)
        }
    }

    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        description += String(describing: accumulator!)
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    var descriptionText: String! {
    
        get{
            return description
        }
    }
    
    var calcIsPending: Bool! {
        
        get {
            return resultIsPending
        }
    }
    
    
 

}

