//
//  PerformanceTester.swift
//  RegistryPerformance
//
//  Created by tejashri rote on 20/08/25.
//
import Foundation
// MARK: - Memory Analysis Tests

class MemoryMeasurer {
    /*
     ref: https://medium.com/@yatimistark/console-output-of-ios-swift-used-memory-size-e9a26e4cd4fb
     */
    static func getMemoryUsage() -> UInt64 {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            return info.resident_size
        } else {
            return 0
        }
    }
    
    /*
     app's memory state:[target operation] + [Leftover objects] + [System buffers] + [Random allocations]
     Autorelease pool cleans up all autorelease objects when this block ends. This triggers ARC to cleanup objects waiting to be deallocated. So we get more acurate delta without leftover objects.
     */
    static func measureMemoryDifference<T>( operation: () -> T ) -> (result: T, memoryDelta: Int64) {
        // Force garbage collection
        autoreleasepool {
            // Create some temporary objects to trigger cleanup
            _ = Array(0..<1000).map { "temp_\($0)" }
        }
        
        let beforeMemory = getMemoryUsage()
        let result = operation()
        let afterMemory = getMemoryUsage()
        
        let memoryDelta = Int64(afterMemory) - Int64(beforeMemory)
        return (result, memoryDelta)
    }
    
    static func formatBytes(_ bytes: Int64) -> String {
        let absBytes = abs(bytes)
        if absBytes < 1024 {
            return "\(bytes) bytes"
        } else if absBytes < 1024 * 1024 {
            return String(format: "%.1f KB", Double(bytes) / 1024.0)
        } else {
            return String(format: "%.1f MB", Double(bytes) / (1024.0 * 1024.0))
        }
    }
}

public class MemoryAnalyzer {
    public init() {}
    private func createTestConfig(index: Int, type: String) -> FieldConfiguration {
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
    
    func analyzeSwitchStatementMemory(iterations: Int = 100) {
        print("Analyzing Switch Statement Memory Usage...")
        
        let (fields, memoryDelta) = MemoryMeasurer.measureMemoryDifference {
            var fields: [FormField] = []
            let types = FormFieldType.allCases
            
            for i in 0..<iterations {
                let type = types[i % types.count]
                let config = createTestConfig(index: i, type: type.rawValue)
                let field = FormField.create(type: type, config: config)
                fields.append(field)
            }
            return fields
        }
        
        print("Switch-based fields created: \(fields.count)")
        print("Memory delta: \(MemoryMeasurer.formatBytes(memoryDelta))")
        print("Memory per field: \(MemoryMeasurer.formatBytes(memoryDelta / Int64(fields.count)))")
        print("-------------------------------------")
    }
    
    func analyzeRegistryMemory(iterations: Int = 100) {
        print(" Analyzing Registry Memory Usage...")
        
        // Measure registry creation
        let (registry, registryCreationMemory) = MemoryMeasurer.measureMemoryDifference {
            let registry = FormFieldRegistry()
            registry.registerAllFields()
            return registry
        }
        
        print("Registry creation memory: \(MemoryMeasurer.formatBytes(registryCreationMemory))")
        
        // Measure field creation using registry
        let (fields, fieldCreationMemory) = MemoryMeasurer.measureMemoryDifference {
            var fields: [PolymorphicFormField] = []
            let types = FormFieldType.allCases.map { $0.rawValue }
            
            for i in 0..<iterations {
                let type = types[i % types.count]
                let config = createTestConfig(index: i, type: type)
                if let field = registry.createFormField(type: type, config: config) {
                    fields.append(field)
                }
            }
            return fields
        }
        
        print("Registry-based fields created: \(fields.count)")
        print("Field creation memory delta: \(MemoryMeasurer.formatBytes(fieldCreationMemory))")
        print("Memory per field: \(MemoryMeasurer.formatBytes(fieldCreationMemory / Int64(fields.count)))")
        print("Total registry overhead: \(MemoryMeasurer.formatBytes(registryCreationMemory))")
        print("-------------------------------------")
    }
    
    func analyzeRegistryFactoryMemory() {
        print("Analyzing Registry Factory Storage...")
        
        let (factorySize, memoryDelta) = MemoryMeasurer.measureMemoryDifference {
            // Create just the factories dictionary without the registry wrapper
            var factories: [String: FormFieldFactory] = [:]
            
            factories["text"] = { TextFormField(config: $0) }
            factories["email"] = { EmailFormField(config: $0) }
            factories["password"] = { PasswordFormField(config: $0) }
            factories["number"] = { NumberFormField(config: $0) }
            factories["date"] = { DateFormField(config: $0) }
            factories["dropdown"] = { DropdownFormField(config: $0) }
            factories["checkbox"] = { CheckboxFormField(config: $0) }
            factories["radio"] = { RadioFormField(config: $0) }
            factories["textarea"] = { TextAreaFormField(config: $0) }
            factories["phone"] = { PhoneFormField(config: $0) }
            factories["creditCard"] = { CreditCardFormField(config: $0) }
            factories["url"] = { URLFormField(config: $0) }
            factories["slider"] = { SliderFormField(config: $0) }
            factories["toggle"] = { ToggleFormField(config: $0) }
            factories["file"] = { FileFormField(config: $0) }
            
            return factories.count
        }
        
        print("Factory dictionary entries: \(factorySize)")
        print("Factory dictionary memory: \(MemoryMeasurer.formatBytes(memoryDelta))")
        print("Memory per factory: \(MemoryMeasurer.formatBytes(memoryDelta / Int64(factorySize)))")
        print("-------------------------------------")
    }
    
    func debugMemoryMeasurement(iterations: Int = 100) {
        print("Detailed Memory Debug Analysis")
        
        // Measure just creating configs (baseline)
        let (configs, configMemory) = MemoryMeasurer.measureMemoryDifference {
            return (0..<iterations).map { createTestConfig(index: $0, type: "text") }
        }
        print("creating configs: \(MemoryMeasurer.formatBytes(configMemory))")
        
        // Measure enum storage specifically
        let (enumFields, enumMemory) = MemoryMeasurer.measureMemoryDifference {
            return configs.map { FormField.text(config: $0) }
        }
        print("enum fields: \(MemoryMeasurer.formatBytes(enumMemory))")
        
        // Measure class storage specifically
        let (classFields, classMemory) = MemoryMeasurer.measureMemoryDifference {
            return configs.map { TextFormField(config: $0) }
        }
        print("class fields: \(MemoryMeasurer.formatBytes(classMemory))")
        
        // Check if we're measuring creation vs storage
        print("Enum field count: \(enumFields.count)")
        print("Class field count: \(classFields.count)")
        print("-------------------------------------")
    }
    
    public func runCompleteMemoryAnalysis(iterations: Int = 100) {
        print("Complete Memory Footprint Analysis")
        print("=====================================")
        print()
        
        debugMemoryMeasurement(iterations: iterations)
        analyzeSwitchStatementMemory(iterations: iterations)
        analyzeRegistryMemory(iterations: iterations)
        analyzeRegistryFactoryMemory()
    }
}

