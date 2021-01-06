import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SegmentedControllerTests.allTests),
    ]
}
#endif
