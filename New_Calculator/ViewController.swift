//
//  ViewController.swift
//  New_Calculator
//
//  Created by AJ Radik on 11/19/19.
//  Copyright © 2019 AJ Radik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Operator.initializeOperations()
        for button in allButtons {
            button.titleLabel?.font = button.titleLabel?.font.withSize( (2.7/71) * UIScreen.main.bounds.height)
        }
    }

    var infixExpressionString = text.emptyString.rawValue
    
    @IBOutlet weak var expressionBox: UITextField!
    @IBOutlet weak var resultBox: UITextField!
    @IBOutlet var allButtons: [UIButton]!
    @IBOutlet weak var equalsButton: UIButton!
    var memory: Double? = nil
    var result: Double? = nil
    
    func updateBoxes() {
        resultBox.text = text.emptyString.rawValue
        expressionBox.text = infixExpressionString
    }
    
    @IBAction func digitButton(_ sender: UIButton) {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        infixExpressionString += sender.titleLabel!.text!
        
        if (Double(sender.titleLabel!.text!) == nil && sender.titleLabel?.text != text.decimal.rawValue) || sender.titleLabel?.text == text.negative.rawValue {
            infixExpressionString += text.openParenthesis.rawValue
              }
        
        updateBoxes()
    }
    
    @IBAction func opButton(_ sender: UIButton) {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        infixExpressionString += sender.titleLabel!.text!
        updateBoxes()
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        infixExpressionString = text.emptyString.rawValue
        updateBoxes()
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        if infixExpressionString.count > 0 {
            infixExpressionString = String(infixExpressionString.prefix(infixExpressionString.count-1))
            updateBoxes()
        }
    }
    
    @IBAction func equalsButton(_ sender: UIButton) {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
       
        if infixExpressionString.count == 0 {
            return
        }
        
        var tokenArr = parseStringToTokenArr(string: infixExpressionString)
        
        if tokenArr == nil {
            resultBox.text = text.invalid.rawValue
            return
        }
        
        tokenArr = shuntingYardAlgorithm(infixExpression: tokenArr!)
        
        if tokenArr == nil {
            resultBox.text = text.invalid.rawValue
            return
        }
        
        result = evaluateReversePolishNotation(rpn: tokenArr!)
        
        if result == nil {
            resultBox.text = text.invalid.rawValue
            return
        }
        
        resultBox.text = "\(result!)"
    }
    
    @IBAction func memoryAddButton(_ sender: Any) {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        if result != nil {
            memory = result
            return
        }
        resultBox.text = text.error.rawValue
        return
    }
    
    @IBAction func memoryRecallButton(_ sender: Any) {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        if memory != nil {
            infixExpressionString += "\(memory!)"
            updateBoxes()
            return
        }
        resultBox.text = text.error.rawValue
        return
    }
    
    @IBAction func secondMenuButton(_ sender: UIButton) {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        switch sender.titleLabel?.text {
            case text.first.rawValue:
                openFirstMenu()
            case text.second.rawValue:
                openSecondMenu()
            default:
                break
        }
        
    }
    
    @IBOutlet weak var secondMenuButton: UIButton!
    @IBOutlet weak var decimalButton: UIButton!
    @IBOutlet weak var zeroButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var oneButton: UIButton!
    
    @IBOutlet var changeButtons: [UIButton]!
    
    func openSecondMenu() {
        
        secondMenuButton.setTitle(text.first.rawValue, for: .normal)
        decimalButton.setTitle(text.ln.rawValue, for: .normal)
        zeroButton.setTitle(text.log.rawValue, for: .normal)
        nineButton.setTitle(text.exp.rawValue, for: .normal)
        eightButton.setTitle(text.pow.rawValue, for: .normal)
        sevenButton.setTitle(text.sqrt.rawValue, for: .normal)
        sixButton.setTitle(text.atan.rawValue, for: .normal)
        fiveButton.setTitle(text.acos.rawValue, for: .normal)
        fourButton.setTitle(text.asin.rawValue, for: .normal)
        threeButton.setTitle(text.tan.rawValue, for: .normal)
        twoButton.setTitle(text.cos.rawValue, for: .normal)
        oneButton.setTitle(text.sin.rawValue, for: .normal)
        
        for button in changeButtons {
            button.setTitleColor(UIColor.black, for: .normal)
            button.tintColor = UIColor.systemPink
        }
    }
    
    func openFirstMenu() {
        
        secondMenuButton.setTitle(text.second.rawValue, for: .normal)
        decimalButton.setTitle(text.decimal.rawValue, for: .normal)
        zeroButton.setTitle(text.zero.rawValue, for: .normal)
        nineButton.setTitle(text.nine.rawValue, for: .normal)
        eightButton.setTitle(text.eight.rawValue, for: .normal)
        sevenButton.setTitle(text.seven.rawValue, for: .normal)
        sixButton.setTitle(text.six.rawValue, for: .normal)
        fiveButton.setTitle(text.five.rawValue, for: .normal)
        fourButton.setTitle(text.four.rawValue, for: .normal)
        threeButton.setTitle(text.three.rawValue, for: .normal)
        twoButton.setTitle(text.two.rawValue, for: .normal)
        oneButton.setTitle(text.one.rawValue, for: .normal)
        
        for button in changeButtons {
           button.setTitleColor(UIColor.systemPink, for: .normal)
           button.tintColor = equalsButton.tintColor
        }
    }
}

enum text: String {
    case negative = "-"
    case error = "ERROR"
    case invalid = "INVALID"
    case openParenthesis = "("
    case emptyString = ""
    
    case second = "2nd"
    case decimal = "."
    case zero = "0"
    case nine = "9"
    case eight = "8"
    case seven = "7"
    case six = "6"
    case five = "5"
    case four = "4"
    case three = "3"
    case two = "2"
    case one = "1"
    
    case first = "1st"
    case ln = "ln"
    case log = "log"
    case exp = "exp"
    case pow = "^"
    case sqrt = "√"
    case atan = "atan"
    case acos = "acos"
    case asin = "asin"
    case tan = "tan"
    case cos = "cos"
    case sin = "sin"
}
