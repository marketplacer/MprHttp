import XCTest
import MprHttp

class TegHttpSensitiveTextTests: XCTestCase {
  func testHideSensitiveContent() {
    let result = TegHttpSensitiveText.hideSensitiveContent("This is my secret token!", sensitiveWords: ["token"])
    XCTAssertEqual("****** hidden ******", result)
  }
  
  func testShowNonSensitiveContent() {
    let result = TegHttpSensitiveText.hideSensitiveContent("Hello there!", sensitiveWords: ["token"])
    XCTAssertEqual("Hello there!", result)
  }
  
  // MARK: - isSensitive
  
  func testCheckIfTextContainsSensitiveContent() {
    XCTAssert(TegHttpSensitiveText.isSensitive("my token", sensitiveWords: ["token", "nonce"]))
    XCTAssert(TegHttpSensitiveText.isSensitive("nonce", sensitiveWords: ["token", "nonce"]))
    XCTAssert(TegHttpSensitiveText.isSensitive("secretToken", sensitiveWords: ["token", "nonce"]))
  }
  
  func testCheckIfTextContainsSensitiveContent_NO() {
    XCTAssertFalse(TegHttpSensitiveText.isSensitive("not sensitive", sensitiveWords: ["token", "nonce"]))
  }
}