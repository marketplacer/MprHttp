import XCTest
import MprHttp

class TegHttpSensitiveTextTests: XCTestCase {
  func testHideSensitiveContent() {
    let result = TegHttpSensitiveText.hideSensitiveContent("This is my secret token!")
    XCTAssertEqual("****** hidden ******", result)
  }
  
  func testShowNonSensitiveContent() {
    let result = TegHttpSensitiveText.hideSensitiveContent("Hello there!")
    XCTAssertEqual("Hello there!", result)
  }
  
  // MARK: - isSensitive
  
  func testCheckIfTextContainsSensitiveContent() {
    XCTAssert(TegHttpSensitiveText.isSensitive("my token"))
    XCTAssert(TegHttpSensitiveText.isSensitive("nonce"))
    XCTAssert(TegHttpSensitiveText.isSensitive("secretToken"))
  }
  
  func testCheckIfTextContainsSensitiveContent_NO() {
    XCTAssertFalse(TegHttpSensitiveText.isSensitive("not sensitive"))
  }
}