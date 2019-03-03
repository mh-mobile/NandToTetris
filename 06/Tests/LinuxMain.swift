import XCTest

import assemblerTests

var tests = [XCTestCaseEntry]()
tests += assemblerTests.allTests()
XCTMain(tests)