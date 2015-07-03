import XCTest
import MprHttp

class TegHttpTextLoggerTests: XCTestCase {
  var obj: TegHttpText!
  
  override func setUp() {
    obj = TegHttpText()
  }
  
  func testHttpTextLogger_success() {
    StubHttp.withText("Hello", forUrlPart: "server.com")
    var identity = TegHttpRequestIdentity(url: "http://server.com/")
    
    var httpLogMessages = [String]()
    var logTypes = [TegHttpLogTypes]()
    var statusCodes = [Int?]()
    
    identity.logger = { message, logType, statusCode in
      httpLogMessages.append(message)
      logTypes.append(logType)
      statusCodes.append(statusCode)
    }
    
    let expectation = expectationWithDescription("HTTP response received")
    
    obj.load(identity,
      onSuccess: { text in },
      onError: { error, reponse, body in },
      onAlways: {
        expectation.fulfill()
      }
    )
    
    waitForExpectationsWithTimeout(1) { error in }
    
    XCTAssertEqual(2, httpLogMessages.count)
    
    XCTAssertEqual("GET http://server.com/", httpLogMessages[0])
    XCTAssertEqual(TegHttpLogTypes.RequestMethodAndUrl, logTypes[0])
    XCTAssert(statusCodes[0] == nil)
    
    XCTAssertEqual("Hello", httpLogMessages[1])
    XCTAssertEqual(TegHttpLogTypes.ResponseSuccessBody, logTypes[1])
    XCTAssertEqual(200, statusCodes[1]!)
  }
  
  func testHttpTextLogger_error() {
    StubHttp.withText("Test error", forUrlPart: "server.com", statusCode: 422)
    var identity = TegHttpRequestIdentity(url: "http://server.com/")
    
    var httpLogMessages = [String]()
    var logTypes = [TegHttpLogTypes]()
    var statusCodes = [Int?]()
    
    identity.logger = { message, logType, statusCode in
      httpLogMessages.append(message)
      logTypes.append(logType)
      statusCodes.append(statusCode)
    }
    
    let expectation = expectationWithDescription("HTTP response received")
    
    obj.load(identity,
      onSuccess: { text in },
      onError: { error, reponse, body in },
      onAlways: {
        expectation.fulfill()
      }
    )
    
    waitForExpectationsWithTimeout(1) { error in }
    
    XCTAssertEqual(2, httpLogMessages.count)
    
    XCTAssertEqual("GET http://server.com/", httpLogMessages[0])
    XCTAssertEqual(TegHttpLogTypes.RequestMethodAndUrl, logTypes[0])
    XCTAssert(statusCodes[0] == nil)
    
    XCTAssertEqual("Test error", httpLogMessages[1])
    XCTAssertEqual(TegHttpLogTypes.ResponseErrorBody, logTypes[1])
    XCTAssertEqual(422, statusCodes[1]!)
  }
  
  func testHttpTextLogger_httpError() {
    // Code: -1009
    let notConnectedErrorCode = Int(CFNetworkErrors.CFURLErrorNotConnectedToInternet.rawValue)
    
    let notConnectedError = NSError(domain: NSURLErrorDomain,
      code: notConnectedErrorCode, userInfo: nil)
    
    StubHttp.withError(notConnectedError, forUrlPart: "server.com")

    var identity = TegHttpRequestIdentity(url: "http://server.com/")
    
    var httpLogMessages = [String]()
    var logTypes = [TegHttpLogTypes]()
    var statusCodes = [Int?]()
    
    identity.logger = { message, logType, statusCode in
      httpLogMessages.append(message)
      logTypes.append(logType)
      statusCodes.append(statusCode)
    }
    
    let expectation = expectationWithDescription("HTTP response received")
    
    obj.load(identity,
      onSuccess: { text in },
      onError: { error, reponse, body in },
      onAlways: {
        expectation.fulfill()
      }
    )
    
    waitForExpectationsWithTimeout(1) { error in }
    
    XCTAssertEqual(2, httpLogMessages.count)
    
    XCTAssertEqual("GET http://server.com/", httpLogMessages[0])
    XCTAssertEqual(TegHttpLogTypes.RequestMethodAndUrl, logTypes[0])
    XCTAssert(statusCodes[0] == nil)
    
    XCTAssertEqual("Error Domain=NSURLErrorDomain Code=-1009 \"The operation couldn’t be completed. (NSURLErrorDomain error -1009.)\"", httpLogMessages[1])

    XCTAssertEqual(TegHttpLogTypes.ResponseHttpError, logTypes[1])
    XCTAssert(statusCodes[1] == nil)
  }
}

