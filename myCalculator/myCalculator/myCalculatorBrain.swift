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
    private var description : String?
    
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
                description? += symbol
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function (accumulator!)
                    description? += symbol
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand:accumulator!)
                    accumulator = nil
                    resultIsPending = true
                    description? += symbol
                }
            case .equals:
                performPendingBinaryOperation()
                resultIsPending = false
                description? += symbol
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
        description? += String(operand)
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
    var descriptionText: String? {
    
        get{
            return description
        }
    }
    
    
 

}

