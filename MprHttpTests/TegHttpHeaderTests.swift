import XCTest
import MprHttp

class TegHttpHeaderTests: XCTestCase {
  func testInit() {
    let header = TegHttpHeader(field: "test-field", value: "test-value")
    
    XCTAssertEqual("test-field", header.field)
    XCTAssertEqual("test-value", header.value)
  }
  
  // MARK: Equatable
  
  func testEqualtable_shouldBeEqual() {
    let header = TegHttpHeader(field: "test-field", value: "test-value")
    let anotherHeader = TegHttpHeader(field: "test-field", value: "test-value")
    
    XCTAssertEqual(header, anotherHeader)
  }
  
  func testEqualtable_withDifferentField() {
    let header = TegHttpHeader(field: "test-field", value: "test-value")
    let anotherHeader = TegHttpHeader(field: "test-field-not-equal", value: "test-value")
    
    XCTAssertFalse(header == anotherHeader)
  }
  
  func testEqualtable_withDifferentValue() {
    let header = TegHttpHeader(field: "test-field", value: "test-value")
    let anotherHeader = TegHttpHeader(field: "test-field", value: "test-value-different")
    
    XCTAssertFalse(header == anotherHeader)
  }
}
