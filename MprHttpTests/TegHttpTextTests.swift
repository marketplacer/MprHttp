import XCTest
import MprHttp

class TegHttpTextSpec: XCTestCase {
  var obj: TegHttpText!
  
  override func setUp() {
    obj = TegHttpText()
  }
  
  func testHttpText() {
    var remoteText: String?
    var errorFired = false
    
    StubHttp.withText("Hello", forUrlPart: "server.com")
    let identity = TegHttpRequestIdentity(url: "http://server.com/")
    let expectation = expectationWithDescription("HTTP response received")
    
    obj.load(identity,
      onSuccess: { text in
        remoteText = text
      },
      onError: { error, reponse, body in
        errorFired = true
      },
      onAlways: {
        expectation.fulfill()
      }
    )
    
    waitForExpectationsWithTimeout(1) { error in }
    
    XCTAssertEqual("Hello", remoteText!)
    XCTAssertFalse(errorFired)
  }
  
  func testHttpText_error422() {
    var remoteText: String?
    var repoteError: NSError?
    var remoteResponse: NSHTTPURLResponse?
    var remoteErrorBody: String?
    
    StubHttp.withText("Hello", forUrlPart: "server.com", statusCode: 422)
    let identity = TegHttpRequestIdentity(url: "http://server.com/")
    let expectation = expectationWithDescription("HTTP response received")
    
    obj.load(identity,
      onSuccess: { text in
        remoteText = text
      },
      onError: { error, reponse, body in
        repoteError = error
        remoteResponse = reponse
        remoteErrorBody = body
      },
      onAlways: {
        expectation.fulfill()
      }
    )
    
    waitForExpectationsWithTimeout(1) { error in }
    
    XCTAssert(remoteText == nil)
    XCTAssertEqual("Hello", remoteErrorBody!)
    XCTAssertEqual(TegHttpError.Not200FromServer.rawValue, repoteError!.code)
    XCTAssertEqual("MprHttp", repoteError!.domain)
    XCTAssertEqual(422, remoteResponse!.statusCode)
  }
  
  func testLoadImage_noInternetConnectionError() {
    var remoteText: String?
    var repoteError: NSError?
    var remoteResponse: NSHTTPURLResponse?
    var remoteErrorBody: String?
    
    // Code: -1009
    let notConnectedErrorCode = Int(CFNetworkErrors.CFURLErrorNotConnectedToInternet.rawValue)
    
    let notConnectedError = NSError(domain: NSURLErrorDomain,
      code: notConnectedErrorCode, userInfo: nil)
    
    StubHttp.withError(notConnectedError, forUrlPart: "server.com")
    
    let identity = TegHttpRequestIdentity(url: "http://server.com/")
    let expectation = expectationWithDescription("HTTP response received")
    
    obj.load(identity,
      onSuccess: { text in
        remoteText = text
      },
      onError: { error, reponse, body in
        repoteError = error
        remoteResponse = reponse
        remoteErrorBody = body
      },
      onAlways: {
        expectation.fulfill()
      }
    )
    
    waitForExpectationsWithTimeout(1) { error in }
    
    XCTAssert(remoteText == nil)
    XCTAssertEqual(-1009, repoteError!.code)
    XCTAssertEqual("NSURLErrorDomain", repoteError!.domain)
    XCTAssert(remoteErrorBody == nil)
    XCTAssert(remoteResponse == nil)
  }
}