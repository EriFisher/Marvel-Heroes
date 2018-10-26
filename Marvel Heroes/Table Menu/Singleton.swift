//
//  Singleton.swift
//  Marvel Heroes
//
//  Created by Eric on 10/25/18.
//  Copyright © 2018 App Parents LLC. All rights reserved.
//
//creates singleton between tableviewcontroller and menuviewcontroller
import Foundation
protocol SingletonDelegate:class {
    func variableDidChange(newVariableValue value:Int)
}

class Singleton {
    
    var variable:Int = 0{
        didSet{
            delegate?.variableDidChange(newVariableValue: variable)
        }
    }
    
    private init(){}
    weak var delegate: SingletonDelegate?
    
    static let shared = Singleton()
}
