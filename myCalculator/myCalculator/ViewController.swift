//
//  ViewController.swift
//  myCalculator
//
//  Created by Yang Li on 30/03/2017.
//  Copyright © 2017 Yang Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var display: UILabel!
   
    @IBOutlet weak var descriptionDisplay: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    var userEnteredAPoint = false
    
    
    @IBAction func touchDigit(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if digit == "." && userEnteredAPoint {
                display.text = textCurrentlyInDisplay
                
            }
            else {
                display.text = textCurrentlyInDisplay + digit
                if digit == "." {
                    userEnteredAPoint = true
                }
            }
            
            
        } else {
            if digit != "." {
                display.text = digit
            }
            else {
                display.text = "0" + digit
                userEnteredAPoint = true
            }
            
            
            userIsInTheMiddleOfTyping = true
        }
        if !brain.calcIsPending && (descriptionDisplay.text == " ") {
            descriptionDisplay.text = display.text
            
        }
    }
    

    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
  
    
    
    private var brain = MyCalculatorBrain()
    
    
   
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
        }
        userIsInTheMiddleOfTyping = false
        userEnteredAPoint = false
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
            descriptionDisplay.text = brain.calcIsPending ? brain.descriptionText + "..." : brain.descriptionText + "="
        } else {
            descriptionDisplay.text = brain.descriptionText + "..."
        }
        
    }
    
}

