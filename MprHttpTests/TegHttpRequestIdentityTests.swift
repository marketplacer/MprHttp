import XCTest
import MprHttp

class TegHttpRequestIdentityTests: XCTestCase {
  
  // MARK: - Init
  
  func testInit() {
    let header = TegHttpHeader(field: "test-field", value: "test-value")
    let data = NSData()
    
    let identity = TegHttpRequestIdentity(url: "http://www.test-url.com",
      method: TegHttpMethod.Get, requestBody: data, contentType: TegHttpContentType.Json,
      httpHeaders: [header], mockedResponse: "test-mocked-response")
    
    XCTAssertEqual("http://www.test-url.com", identity.url)
    XCTAssertEqual(TegHttpMethod.Get, identity.method)
    XCTAssert(data === identity.requestBody!)
    XCTAssertEqual(TegHttpContentType.Json, identity.contentType)
    XCTAssertEqual(1, identity.httpHeaders.count)
    XCTAssert(header == identity.httpHeaders[0])
    XCTAssertEqual("test-mocked-response", identity.mockedResponse!)
  }
  
  
  func testInitWithUrl() {
    let identity = TegHttpRequestIdentity(url: "http://www.test-url.com")
    
    XCTAssertEqual("http://www.test-url.com", identity.url)
    XCTAssertEqual(TegHttpMethod.Get, identity.method)
    XCTAssert(identity.requestBody == nil)
    XCTAssertEqual(TegHttpContentType.Unspecified, identity.contentType)
    XCTAssertEqual(0, identity.httpHeaders.count)
    XCTAssert(identity.mockedResponse == nil)
  }
  
  func testWithIdentityToCopy() {
    let header = TegHttpHeader(field: "test-field", value: "test-value")
    let data = NSData()

    let identityToCopy = TegHttpRequestIdentity(url: "http://www.test-url.com",
      method: TegHttpMethod.Get, requestBody: data, contentType: TegHttpContentType.Json,
      httpHeaders: [], mockedResponse: "test-mocked-response")
    
    let identity = TegHttpRequestIdentity(identityToCopy: identityToCopy, httpHeaders: [header])
    
    XCTAssertEqual("http://www.test-url.com", identity.url)
    XCTAssertEqual(TegHttpMethod.Get, identity.method)
    XCTAssert(data === identity.requestBody!)
    XCTAssertEqual(TegHttpContentType.Json, identity.contentType)
    XCTAssertEqual(1, identity.httpHeaders.count)
    XCTAssert(header == identity.httpHeaders[0])
    XCTAssertEqual("test-mocked-response", identity.mockedResponse!)
  }
  
  // MARK: - URL
  
  func testURL_valid() {
    let identity = TegHttpRequestIdentity(url: "http://www.test-url.com")
    XCTAssertEqual("http://www.test-url.com", identity.nsUrl!.absoluteString)
  }
  
  func testURL_invalid() {
    let identity = TegHttpRequestIdentity(url: "🍏")
    XCTAssert(identity.nsUrl == nil)
  }
  
  // MARK: - URL request
  
  func testRequestWithoutContentType() {
    let header = TegHttpHeader(field: "test-field", value: "test-value")
    let data = NSData()
    
    let identity = TegHttpRequestIdentity(url: "http://www.test-url.com",
      method: TegHttpMethod.Get, requestBody: NSData(), contentType: TegHttpContentType.Json,
      httpHeaders: [header], mockedResponse: "test-mocked-response")
    
    let request = identity.urlRequest
    
    XCTAssertEqual("http://www.test-url.com", request.URL!.absoluteString)
    XCTAssertEqual("GET", request.HTTPMethod!)
    XCTAssert(request.HTTPBody === data)
    
    XCTAssertEqual(2, request.allHTTPHeaderFields!.count)
    XCTAssertEqual("application/json", request.valueForHTTPHeaderField("Content-Type")!)
    XCTAssertEqual("test-value", request.valueForHTTPHeaderField("test-field")!)
  }
  
  func testRequestWithNoHeader() {
    let identity = TegHttpRequestIdentity(url: "http://www.test-url.com")
    let request = identity.urlRequest
    
    XCTAssertEqual(0, request.allHTTPHeaderFields!.count)
  }
}
