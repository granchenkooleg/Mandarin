//
//  ContexForValidation.swift
//  Mandarin
//
//  Created by Oleg on 12/18/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Foundation

//MARK: Pattern Strategy for validation
// Class Context
class ContexForValidation {
    
    // property
    var text: String
    var textValidator: InputValidator?
    
    // initializer
    init(text: String) {
        
        self.text = text
    }
    
    init(text: String, validator: InputValidator) {
        
        self.text = text
        self.textValidator = validator
    }
    
    // Context Interface
    func validate() -> Bool {
        
        var error: NSError?
        if let result = textValidator?.validateInput(text: text, error: &error) {
            return result
        }
        return false
    }
}

// Protocol Strategy
protocol InputValidator {
    func validateInput(text: String, error: inout NSError?) -> Bool
}
