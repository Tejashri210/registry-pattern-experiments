//APPROACH: Switch-Case Enum

import Foundation

enum FormFieldType: String, CaseIterable {
    case text = "text"
    case email = "email"
    case password = "password"
    case number = "number"
    case date = "date"
    case dropdown = "dropdown"
    case checkbox = "checkbox"
    case radio = "radio"
    case textarea = "textarea"
    case phone = "phone"
    case creditCard = "creditCard"
    case url = "url"
    case slider = "slider"
    case toggle = "toggle"
    case file = "file"
}

enum FormField {
    case text(config: FieldConfiguration)
    case email(config: FieldConfiguration)
    case password(config: FieldConfiguration)
    case number(config: FieldConfiguration)
    case date(config: FieldConfiguration)
    case dropdown(config: FieldConfiguration)
    case checkbox(config: FieldConfiguration)
    case radio(config: FieldConfiguration)
    case textarea(config: FieldConfiguration)
    case phone(config: FieldConfiguration)
    case creditCard(config: FieldConfiguration)
    case url(config: FieldConfiguration)
    case slider(config: FieldConfiguration)
    case toggle(config: FieldConfiguration)
    case file(config: FieldConfiguration)
    
    // Factory method with switch
    static func create(type: FormFieldType, config: FieldConfiguration) -> FormField {
        switch type {
        case .text:
            return .text(config: config)
        case .email:
            return .email(config: config)
        case .password:
            return .password(config: config)
        case .number:
            return .number(config: config)
        case .date:
            return .date(config: config)
        case .dropdown:
            return .dropdown(config: config)
        case .checkbox:
            return .checkbox(config: config)
        case .radio:
            return .radio(config: config)
        case .textarea:
            return .textarea(config: config)
        case .phone:
            return .phone(config: config)
        case .creditCard:
            return .creditCard(config: config)
        case .url:
            return .url(config: config)
        case .slider:
            return .slider(config: config)
        case .toggle:
            return .toggle(config: config)
        case .file:
            return .file(config: config)
        }
    }
    
    func validate(_ value: Any?) -> ValidationResult {
        switch self {
        case .text(let config):
            if config.isRequired && (value as? String)?.isEmpty != false {
                return ValidationResult(isValid: false, errorMessage: "Field is required")
            }
            if let maxLength = config.metadata["maxLength"] as? Int,
               let text = value as? String,
               text.count > maxLength {
                return ValidationResult(isValid: false, errorMessage: "Too long")
            }
            return ValidationResult(isValid: true, errorMessage: nil)
            
        case .email(let config):
            if config.isRequired && (value as? String)?.isEmpty != false {
                return ValidationResult(isValid: false, errorMessage: "Field is required")
            }
            if let email = value as? String, !email.isEmpty {
                let isValid = email.contains("@") && email.contains(".")
                return ValidationResult(isValid: isValid,
                                      errorMessage: isValid ? nil : "Invalid email")
            }
            return ValidationResult(isValid: true, errorMessage: nil)
            
        case .password(let config):
            guard let password = value as? String else {
                return ValidationResult(isValid: !config.isRequired,
                                      errorMessage: "Field is required")
            }
            let minLength = config.metadata["minLength"] as? Int ?? 8
            if password.count < minLength {
                return ValidationResult(isValid: false,
                                      errorMessage: "Too short")
            }
            return ValidationResult(isValid: true, errorMessage: nil)
            
        case .number(let config):
            guard let _ = value as? Double else {
                return ValidationResult(isValid: !config.isRequired,
                                      errorMessage: "Invalid number")
            }
            return ValidationResult(isValid: true, errorMessage: nil)
            
        case .date(let config):
            guard let _ = value as? Date else {
                return ValidationResult(isValid: !config.isRequired,
                                      errorMessage: "Invalid date")
            }
            return ValidationResult(isValid: true, errorMessage: nil)
            
        case .dropdown(let config):
            if config.isRequired && value == nil {
                return ValidationResult(isValid: false, errorMessage: "Select an option")
            }
            return ValidationResult(isValid: true, errorMessage: nil)
            
        case .checkbox(let config):
            if config.isRequired && value as? Bool != true {
                return ValidationResult(isValid: false, errorMessage: "Must be checked")
            }
            return ValidationResult(isValid: true, errorMessage: nil)
            
        case .radio(let config):
            if config.isRequired && value == nil {
                return ValidationResult(isValid: false, errorMessage: "Select an option")
            }
            return ValidationResult(isValid: true, errorMessage: nil)
            
        case .textarea(let config):
            if config.isRequired && (value as? String)?.isEmpty != false {
                return ValidationResult(isValid: false, errorMessage: "Field is required")
            }
            return ValidationResult(isValid: true, errorMessage: nil)
            
        case .phone(let config):
            guard let phone = value as? String else {
                return ValidationResult(isValid: !config.isRequired,
                                      errorMessage: "Invalid phone")
            }
            let isValid = phone.count >= 10
            return ValidationResult(isValid: isValid,
                                  errorMessage: isValid ? nil : "Invalid phone")
            
        case .creditCard(let config):
            guard let card = value as? String else {
                return ValidationResult(isValid: !config.isRequired,
                                      errorMessage: "Invalid card")
            }
            let isValid = card.count >= 13 && card.count <= 19
            return ValidationResult(isValid: isValid,
                                  errorMessage: isValid ? nil : "Invalid card")
            
        case .url(let config):
            guard let urlString = value as? String else {
                return ValidationResult(isValid: !config.isRequired,
                                      errorMessage: "Invalid URL")
            }
            let isValid = URL(string: urlString) != nil
            return ValidationResult(isValid: isValid,
                                  errorMessage: isValid ? nil : "Invalid URL")
            
        case .slider:
            return ValidationResult(isValid: true, errorMessage: nil)
            
        case .toggle:
            return ValidationResult(isValid: true, errorMessage: nil)
            
        case .file(let config):
            if config.isRequired && value == nil {
                return ValidationResult(isValid: false, errorMessage: "File required")
            }
            return ValidationResult(isValid: true, errorMessage: nil)
        }
    }
    
    func getPlaceholder() -> String {
        switch self {
        case .text(let config), .email(let config), .password(let config),
             .number(let config), .date(let config), .dropdown(let config),
             .checkbox(let config), .radio(let config), .textarea(let config),
             .phone(let config), .creditCard(let config), .url(let config),
             .slider(let config), .toggle(let config), .file(let config):
            return config.placeholder
        }
    }
    
    func getLabel() -> String {
        switch self {
        case .text(let config), .email(let config), .password(let config),
             .number(let config), .date(let config), .dropdown(let config),
             .checkbox(let config), .radio(let config), .textarea(let config),
             .phone(let config), .creditCard(let config), .url(let config),
             .slider(let config), .toggle(let config), .file(let config):
            return config.label
        }
    }
    
    func isRequired() -> Bool {
        switch self {
        case .text(let config), .email(let config), .password(let config),
             .number(let config), .date(let config), .dropdown(let config),
             .checkbox(let config), .radio(let config), .textarea(let config),
             .phone(let config), .creditCard(let config), .url(let config),
             .slider(let config), .toggle(let config), .file(let config):
            return config.isRequired
        }
    }
}
