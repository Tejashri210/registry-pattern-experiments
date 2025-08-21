//
//  MemoryMeasurer.swift
//  RegistryPerformance
//
//  Created by tejashri rote on 20/08/25.
//

// MARK: - Performance Test
import Foundation

public class FormFieldCreationPerformanceTester {
    let registry = FormFieldRegistry()
    public init () {
        registry.registerAllFields()
    }
    
    func createTestConfig(index: Int, type: String) -> FieldConfiguration {
        return FieldConfiguration(
            identifier: "field_\(index)",
            label: "Field \(index)",
            placeholder: "Enter \(type)",
            value: nil,
            isRequired: index % 2 == 0,
            metadata: [
                "maxLength": 100,
                "minLength": 8,
                "options": ["Option1", "Option2", "Option3"]
            ]
        )
    }
    
    func measureSwitchCasePerformance(iterations: Int) -> TimeInterval {
        let types = FormFieldType.allCases
        let start = CFAbsoluteTimeGetCurrent()
        
        for i in 0..<iterations {
            let type = types[i % types.count]
            let config = createTestConfig(index: i, type: type.rawValue)
            
            // Create FormField using switch-case factory
            let field = FormField.create(type: type, config: config)
            
            // Call methods that use switch statements
            _ = field.validate("test value")
            _ = field.getLabel()
            _ = field.getPlaceholder()
            _ = field.isRequired()
        }
        
        return CFAbsoluteTimeGetCurrent() - start
    }
    
    func measureRegistryPerformance(iterations: Int) -> TimeInterval {
        let types = FormFieldType.allCases.map { $0.rawValue }
        let start = CFAbsoluteTimeGetCurrent()
        
        for i in 0..<iterations {
            let type = types[i % types.count]
            let config = createTestConfig(index: i, type: type)
            
            // Create FormField using registry
            if let field = registry.createFormField(type: type, config: config) {
                // Call polymorphic methods (no switch statements)
                _ = field.validate("test value")
                _ = field.getLabel()
                _ = field.getPlaceholder()
                _ = field.isRequired()
            }
        }
        
        return CFAbsoluteTimeGetCurrent() - start
    }
    
    public func runPerformanceComparison(iterations: Int = 100) {
        print("Complete perfomrance Analysis")
        print("=====================================")
        print()
        
        var switchTimes: [TimeInterval] = []
        var registryTimes: [TimeInterval] = []
        
        for round in 1...5 {
            print("Round \(round):")
            
            let switchTime = measureSwitchCasePerformance(iterations: iterations)
            switchTimes.append(switchTime)
            print("  Switch-Case: \(String(format: "%.4f", switchTime))s")
            
            let registryTime = measureRegistryPerformance(iterations: iterations)
            registryTimes.append(registryTime)
            print("  Registry: \(String(format: "%.4f", registryTime))s")
            
            let speedup = switchTime / registryTime
            print("  Speedup:     \(String(format: "%.2fx", speedup))")
        }
        let avgSwitch = switchTimes.reduce(0, +) / Double(switchTimes.count)
        let avgRegistry = registryTimes.reduce(0, +) / Double(registryTimes.count)
        let overhead = ((avgRegistry - avgSwitch) / avgSwitch) * 100
        
        print("Switch cases average time = \(String(format: "%12.4f", avgSwitch))s")
        print("Registry average time = \(String(format: "%12.4f", avgRegistry))s")
        print("Performance difference: \(String(format: "%.5f%%", overhead))")
        
    }
}


