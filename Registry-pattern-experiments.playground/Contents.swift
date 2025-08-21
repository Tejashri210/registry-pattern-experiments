

let iterations = 1000000

let memoryAnalyzer = MemoryAnalyzer()
memoryAnalyzer.runCompleteMemoryAnalysis(iterations: iterations)

let tester = FormFieldCreationPerformanceTester()
tester.runPerformanceComparison(iterations: iterations)


