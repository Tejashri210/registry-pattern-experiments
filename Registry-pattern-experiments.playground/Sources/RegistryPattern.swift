//APPROACH: Registry
import Foundation

protocol PolymorphicFormField {
    var config: FieldConfiguration { get }
    func validate(_ value: Any?) -> ValidationResult
    func getPlaceholder() -> String
    func getLabel() -> String
    func isRequired() -> Bool
}

// Base implementation
class BaseFormField: PolymorphicFormField {
    let config: FieldConfiguration
    
    init(config: FieldConfiguration) {
        self.config = config
    }
    
    func validate(_ value: Any?) -> ValidationResult {
        if config.isRequired && (value == nil || (value as? String)?.isEmpty == true) {
            return ValidationResult(isValid: false, errorMessage: "Field is required")
        }
        return ValidationResult(isValid: true, errorMessage: nil)
    }
    
    func getPlaceholder() -> String {
        return config.placeholder
    }
    
    func getLabel() -> String {
        return config.label
    }
    
    func isRequired() -> Bool {
        return config.isRequired
    }
}

// Specific implementations
class TextFormField: BaseFormField {
    override func validate(_ value: Any?) -> ValidationResult {
        let baseResult = super.validate(value)
        guard baseResult.isValid else { return baseResult }
        
        if let maxLength = config.metadata["maxLength"] as? Int,
           let text = value as? String,
           text.count > maxLength {
            return ValidationResult(isValid: false, errorMessage: "Too long")
        }
        return ValidationResult(isValid: true, errorMessage: nil)
    }
}

class EmailFormField: BaseFormField {
    override func validate(_ value: Any?) -> ValidationResult {
        let baseResult = super.validate(value)
        guard baseResult.isValid else { return baseResult }
        
        if let email = value as? String, !email.isEmpty {
            let isValid = email.contains("@") && email.contains(".")
            return ValidationResult(isValid: isValid,
                                  errorMessage: isValid ? nil : "Invalid email")
        }
        return ValidationResult(isValid: true, errorMessage: nil)
    }
}

class PasswordFormField: BaseFormField {
    override func validate(_ value: Any?) -> ValidationResult {
        let baseResult = super.validate(value)
        guard baseResult.isValid else { return baseResult }
        
        guard let password = value as? String else {
            return ValidationResult(isValid: !config.isRequired,
                                  errorMessage: "Field is required")
        }
        
        let minLength = config.metadata["minLength"] as? Int ?? 8
        if password.count < minLength {
            return ValidationResult(isValid: false, errorMessage: "Too short")
        }
        return ValidationResult(isValid: true, errorMessage: nil)
    }
}

class NumberFormField: BaseFormField {
    override func validate(_ value: Any?) -> ValidationResult {
        let baseResult = super.validate(value)
        guard baseResult.isValid else { return baseResult }
        
        guard let _ = value as? Double else {
            return ValidationResult(isValid: !config.isRequired,
                                  errorMessage: "Invalid number")
        }
        return ValidationResult(isValid: true, errorMessage: nil)
    }
}

class DateFormField: BaseFormField {}
class DropdownFormField: BaseFormField {}
class CheckboxFormField: BaseFormField {}
class RadioFormField: BaseFormField {}
class TextAreaFormField: BaseFormField {}

class PhoneFormField: BaseFormField {
    override func validate(_ value: Any?) -> ValidationResult {
        let baseResult = super.validate(value)
        guard baseResult.isValid else { return baseResult }
        
        guard let phone = value as? String else {
            return ValidationResult(isValid: !config.isRequired,
                                  errorMessage: "Invalid phone")
        }
        let isValid = phone.count >= 10
        return ValidationResult(isValid: isValid,
                              errorMessage: isValid ? nil : "Invalid phone")
    }
}

class CreditCardFormField: BaseFormField {
    override func validate(_ value: Any?) -> ValidationResult {
        let baseResult = super.validate(value)
        guard baseResult.isValid else { return baseResult }
        
        guard let card = value as? String else {
            return ValidationResult(isValid: !config.isRequired,
                                  errorMessage: "Invalid card")
        }
        let isValid = card.count >= 13 && card.count <= 19
        return ValidationResult(isValid: isValid,
                              errorMessage: isValid ? nil : "Invalid card")
    }
}

class URLFormField: BaseFormField {
    override func validate(_ value: Any?) -> ValidationResult {
        let baseResult = super.validate(value)
        guard baseResult.isValid else { return baseResult }
        
        guard let urlString = value as? String else {
            return ValidationResult(isValid: !config.isRequired,
                                  errorMessage: "Invalid URL")
        }
        let isValid = URL(string: urlString) != nil
        return ValidationResult(isValid: isValid,
                              errorMessage: isValid ? nil : "Invalid URL")
    }
}

class SliderFormField: BaseFormField {}
class ToggleFormField: BaseFormField {}
class FileFormField: BaseFormField {}


// Registry
typealias FormFieldFactory = (FieldConfiguration) -> PolymorphicFormField

class FormFieldRegistry {
    private var factories: [String: FormFieldFactory] = [:]
    
    func register(_ type: String, factory: @escaping FormFieldFactory) {
        factories[type] = factory
    }
    
    func createFormField(type: String, config: FieldConfiguration) -> PolymorphicFormField? {
        return factories[type]?(config)
    }
    
    func registerAllFields() {
        register("text") { TextFormField(config: $0) }
        register("email") { EmailFormField(config: $0) }
        register("password") { PasswordFormField(config: $0) }
        register("number") { NumberFormField(config: $0) }
        register("date") { DateFormField(config: $0) }
        register("dropdown") { DropdownFormField(config: $0) }
        register("checkbox") { CheckboxFormField(config: $0) }
        register("radio") { RadioFormField(config: $0) }
        register("textarea") { TextAreaFormField(config: $0) }
        register("phone") { PhoneFormField(config: $0) }
        register("creditCard") { CreditCardFormField(config: $0) }
        register("url") { URLFormField(config: $0) }
        register("slider") { SliderFormField(config: $0) }
        register("toggle") { ToggleFormField(config: $0) }
        register("file") { FileFormField(config: $0) }
    }
}
