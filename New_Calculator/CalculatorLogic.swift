//
//  CalculatorLogic.swift
//  New_Calculator
//
//  Created by AJ Radik on 11/20/19.
//  Copyright © 2019 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class Stack<T> {
    
    var list: [T]
    
    init() {
        list = []
    }
    
    func isEmpty() -> Bool {
        if size() == 0 {
            return true
        }
        return false
    }
    
    func push(item: T) {
        list.append(item)
    }
    
    func pop() -> T? {
        if !isEmpty() {
            return list.removeLast()
        }
        return nil
    }
    
    func peek() -> T? {
        if !isEmpty() {
            return list[list.count-1]
        }
        return nil
    }
    
    func size() -> Int {
        return list.count
    }
}

class Queue<T> {
    
    class Node<T> {
        let data: T?
        var left: Node<T>?
        var right: Node<T>?
        
        init(data: T?, left: Node<T>?, right: Node<T>?) {
            self.data = data
            self.left = left
            self.right = right
        }
    }
    
    var size: Int
    let head: Node<T>
    let tail: Node<T>
    
    init() {
        size = 0
        head = Node<T>(data: nil, left: nil, right: nil)
        tail = Node<T>(data: nil, left: head, right: nil)
        head.right = tail
    }
    
    func enQueue(item: T) {
        let previous = tail.left
        let newNode = Node(data: item, left: previous, right: tail)
        tail.left = newNode
        previous!.right = newNode
        size+=1
    }
    
    func deQueue() -> T{
        let toExtractDataFrom = head.right
        head.right = head.right!.right!
        head.right!.left! = head
        size-=1
        return toExtractDataFrom!.data!
    }
    
}

class Operator{
    
    static let singleArguement = 1
    static let doubleArguement = 2
    let text: String
    let precedence: Int?
    let numberOfArguements: Int?
    let execute: ((_ arguments: Double...) -> (Double?))?
    static var stringToOperatorWrapperMap = [String : Operator]()
    
    init(text: String, precedence: Int?, numberOfArguements: Int?, execute: @escaping (_ arguments: Double...) -> Double?) {
        self.text = text
        self.precedence = precedence
        self.numberOfArguements = numberOfArguements
        self.execute = execute
        Operator.stringToOperatorWrapperMap[text] = self
    }
    
    init(text: String) {
        self.text = text
        self.precedence = nil
        self.numberOfArguements = nil
        self.execute = nil
        Operator.stringToOperatorWrapperMap[text] = self
    }
    
    static var openParenthesis: Operator!
    
    static var closeParenthesis: Operator!
    
    static func initializeOperations() {
        
        openParenthesis = Operator(text: "(")
        
        closeParenthesis = Operator(text: ")")
        
        _ = Operator(text: "+", precedence: 0, numberOfArguements: Operator.doubleArguement) { (_ arguements: Double...) -> Double? in
            if arguements.count > Operator.doubleArguement {
                return nil
            }
            return arguements[0] + arguements[1]
        }
        
        _ = Operator(text: "﹣", precedence: 0, numberOfArguements: Operator.doubleArguement) { (_ arguements: Double...) -> Double? in
            if arguements.count > Operator.doubleArguement {
               return nil
            }
            return arguements[0] - arguements[1]
        }
        
        _ = Operator(text: "/", precedence: 1, numberOfArguements: Operator.doubleArguement) { (_ arguements: Double...) -> Double? in
            if arguements.count > Operator.doubleArguement {
               return nil
            }
            return arguements[0] / arguements[1]
        }
        
        _ = Operator(text: "*", precedence: 1, numberOfArguements: Operator.doubleArguement) { (_ arguements: Double...) -> Double? in
            if arguements.count > Operator.doubleArguement {
               return nil
            }
            return arguements[0] * arguements[1]
        }
        
        _ = Operator(text: "√", precedence: 2, numberOfArguements: Operator.singleArguement) { (_ arguements: Double...) -> Double? in
            if arguements.count > Operator.singleArguement {
               return nil
            }
            return arguements[0].squareRoot()
        }
        
        _ = Operator(text: "-", precedence: 2, numberOfArguements: Operator.singleArguement) { (_ arguements: Double...) -> Double? in
            if arguements.count > Operator.singleArguement {
               return nil
            }
            return -1 * arguements[0]
        }
        
        _ = Operator(text: "^", precedence: 2, numberOfArguements: Operator.doubleArguement) { (_ arguements: Double...) -> Double? in
            if arguements.count > Operator.doubleArguement {
               return nil
            }
            return pow(arguements[0], arguements[1])
        }
        
        _ = Operator(text: "log", precedence: 2, numberOfArguements: Operator.singleArguement) { (_ arguements: Double...) -> Double? in
            if arguements.count > Operator.singleArguement {
               return nil
            }
            return log10(arguements[0])
        }
        
        _ = Operator(text: "ln", precedence: 2, numberOfArguements: Operator.singleArguement) { (_ arguements: Double...) -> Double? in
            if arguements.count > Operator.singleArguement {
               return nil
            }
            return log(arguements[0])
        }
        
        _ = Operator(text: "sin", precedence: 2, numberOfArguements: Operator.singleArguement) { (_ arguements: Double...) -> Double? in
            if arguements.count > Operator.singleArguement {
               return nil
            }
            return sin(arguements[0])
        }
        
        _ = Operator(text: "cos", precedence: 2, numberOfArguements: Operator.singleArguement) { (_ arguements: Double...) -> Double? in
            if arguements.count > Operator.singleArguement {
               return nil
            }
            return cos(arguements[0])
        }
        
        _ = Operator(text: "tan", precedence: 2, numberOfArguements: Operator.singleArguement) { (_ arguements: Double...) -> Double? in
            if arguements.count > Operator.singleArguement {
               return nil
            }
            return tan(arguements[0])
        }
        
        _ = Operator(text: "asin", precedence: 2, numberOfArguements: Operator.singleArguement) { (_ arguements: Double...) -> Double? in
            if arguements.count > Operator.singleArguement {
               return nil
            }
            return asin(arguements[0])
        }
        
        _ = Operator(text: "acos", precedence: 2, numberOfArguements: Operator.singleArguement) { (_ arguements: Double...) -> Double? in
            if arguements.count > Operator.singleArguement {
               return nil
            }
            return acos(arguements[0])
        }
        
        _ = Operator(text: "atan", precedence: 2, numberOfArguements: Operator.singleArguement) { (_ arguements: Double...) -> Double? in
            if arguements.count > Operator.singleArguement {
               return nil
            }
            return atan(arguements[0])
        }
        
        _ = Operator(text: "exp", precedence: 2, numberOfArguements: Operator.singleArguement) { (_ arguements: Double...) -> Double? in
            if arguements.count > Operator.singleArguement {
               return nil
            }
            return exp(arguements[0])
        }
        
        
    }
    
}

class Token {
    
    let double: Double?
    let op: Operator?
    
    init(double: Double) {
        self.double = double
        op = nil
    }
    
    init(op: Operator) {
        self.op = op
        double = nil
    }
    
    func toString() -> String {
        if op == nil {
            return "\(double!)"
        }
        return op!.text
    }
}




func parseStringToTokenArr(string: String) -> [Token]? {

    var tokenArr: [Token] = []
    var buildString: String = ""
    
    for character in string {
        let double = Double(String(character))
        let characterOp = Operator.stringToOperatorWrapperMap[String(character)]
        let buildStringOp = Operator.stringToOperatorWrapperMap[buildString]
        
        if buildStringOp != nil {
            tokenArr.append(Token(op: buildStringOp!))
            buildString = ""
        }
        
        if characterOp != nil {
            
            if buildString.count > 0 {
                tokenArr.append(Token(double: Double(buildString)!))
            }
            
            buildString = ""
            tokenArr.append(Token(op: characterOp!))
            continue
        }
        
        if double != nil {
            buildString += "\(character)"
            continue
        }
        
        buildString += "\(character)"
        
    }
    
    if buildString.count > 0 {
        let passThrough = Double(buildString)
        
        if passThrough == nil {
            return nil
        }
        
        tokenArr.append(Token(double: passThrough!))
    }
    
    return tokenArr
}

func shuntingYardAlgorithm(infixExpression: [Token]) -> [Token]? {
    let operatorStack = Stack<Token>()
    let rpnQueue = Queue<Token>()
   
    for token in infixExpression {
        if token.op == nil {
            rpnQueue.enQueue(item: token)
        }
        
        if token.op != nil && token.op !== Operator.openParenthesis && token.op !== Operator.closeParenthesis {

            while (!operatorStack.isEmpty() && operatorStack.peek()!.op!.precedence != nil && operatorStack.peek()!.op!.precedence! >= token.op!.precedence!) {
                rpnQueue.enQueue(item: operatorStack.pop()!)
            }
            operatorStack.push(item: token)
        }
        
        if token.op === Operator.openParenthesis {
            operatorStack.push(item: token)
        }
        
        if token.op === Operator.closeParenthesis {
            if operatorStack.isEmpty() {
                return nil
            }
            while operatorStack.peek()?.op !== Operator.openParenthesis && !operatorStack.isEmpty() {
                
                rpnQueue.enQueue(item: operatorStack.pop()!)
            }
            _ = operatorStack.pop()
        }
        
    }
    
    while !operatorStack.isEmpty() {
        rpnQueue.enQueue(item: operatorStack.pop()!)
    }
    
    var rpnToReturn : [Token] = []
    let iterarions = rpnQueue.size
    for _ in 0..<iterarions  {
        rpnToReturn.append(rpnQueue.deQueue())
    }
    
    return rpnToReturn
}


func evaluateReversePolishNotation(rpn: [Token]) -> Double? {
    
    let calculationStack = Stack<Token>()
    
    for token in rpn {
        
        if token.double != nil {
            calculationStack.push(item: token)
        }
        
        if token.op != nil {
            var result : Token? = nil
            
            if token.op?.numberOfArguements == Operator.singleArguement {
                let argument1 = calculationStack.pop()?.double
                
                if argument1 == nil {
                    return nil
                }
                
                result = Token(double: (token.op?.execute!(argument1!))!)
            }
            
            else if token.op?.numberOfArguements == Operator.doubleArguement {
                let argument2 = calculationStack.pop()?.double
                let argument1 = calculationStack.pop()?.double
                
                if argument1 == nil || argument2 == nil {
                    return nil
                }
                
                result = Token(double: (token.op?.execute!(argument1!, argument2!))!)
            }
            
            if result == nil {
                return nil
            }
            
            calculationStack.push(item: result!)
        }
    }
    
    if calculationStack.size() > 1 {
        return nil
    }
    return calculationStack.pop()!.double!
}
