
struct FieldConfiguration {
    let identifier: String
    let label: String
    let placeholder: String
    let value: Any?
    let isRequired: Bool
    let metadata: [String: Any]
}

struct ValidationResult {
    let isValid: Bool
    let errorMessage: String?
}
