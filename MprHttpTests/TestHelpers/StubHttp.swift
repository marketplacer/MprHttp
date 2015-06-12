//
// Shortcut methods for subbing HTTP requests with OHHTTPStubs.
//

import OHHTTPStubs
import YauShop

class StubHttp {
  class func withGreenImage(url: String) {
    withImage("greenImage.png", forUrlPart: url)
  }
  
  class func withRedImage(url: String) {
    withImage("redImage.png", forUrlPart: url)
  }
  
  class func withImage(imageName: String, forUrlPart url: String) {
    OHHTTPStubs.stubRequestsPassingTest(forUrlsContaining(url)) { _ in
      let imagePath = OHPathForFile(imageName, self)!
      
      return OHHTTPStubsResponse(fileAtPath: imagePath,
        statusCode: 200,
        headers: ["Content-Type": "image/png"])
    }
  }
  
  class func withJson(jsonFileName: String, forUrlPart url: String) {
    OHHTTPStubs.stubRequestsPassingTest(forUrlsContaining(url)) { _ in
      return self.jsonResponse(jsonFileName)
    }
  }
  
  class func withText(text: String, forUrlPart url: String, statusCode: Int32 = 200) {
    OHHTTPStubs.stubRequestsPassingTest(forUrlsContaining(url)) { _ in
      let data = text.dataUsingEncoding(NSUTF8StringEncoding)!
      
      return OHHTTPStubsResponse(data: data,
        statusCode: statusCode,
        headers: ["Content-Type": "application/json"])
    }
  }
  
  class func withError(error: NSError, forUrlPart url: String) {
    let errorResponse = OHHTTPStubsResponse(error: error)
    
    OHHTTPStubs.stubRequestsPassingTest(forUrlsContaining(url),
      withStubResponse: { _ in errorResponse }
    )
  }
  
  class func forScreen(requestType: TegRequestType) {
    OHHTTPStubs.stubRequestsPassingTest(forRequestType(requestType)) { _ in
      let jsonFileName = TegMockedHttpRequests.testJsonFile(requestType)!
      return self.jsonResponse(jsonFileName)
    }
  }
  
  class func forScreen(requestType: TegRequestType, withJsonFileName jsonFileName: String) {
    OHHTTPStubs.stubRequestsPassingTest(forRequestType(requestType)) { _ in
      return self.jsonResponse(jsonFileName)
    }
  }
  
  private class func jsonResponse(jsonFileName: String) -> OHHTTPStubsResponse {
    let filePath = NSBundle.appBundle.pathForResource(jsonFileName, ofType: nil)!
    
    return OHHTTPStubsResponse(fileAtPath: filePath,
      statusCode: 200,
      headers: ["Content-Type": "application/json"])
  }
  
  // MARK: - URL matchers
  
  class func forUrlsContaining(urlPart:String) -> (NSURLRequest->Bool) {
    return { req in
      TegString.contains(req.URL!.absoluteString!, substring: urlPart)
    }
  }
  
  class func forRequestType(requestType: TegRequestType) -> (NSURLRequest->Bool) {
    return { req in
      UrlTemplateMatcher.match(req.URL!.absoluteString!, withRequestType: requestType)
    }
  }
}

class StubHttpWithError {
  class func forScreen(requestType: TegRequestType) {
    OHHTTPStubs.stubRequestsPassingTest({
      UrlTemplateMatcher.match($0.URL!.absoluteString!, withRequestType: requestType)
      
      }) { _ in
        let error = NSError(domain: "test-domain", code: 200, userInfo: nil)
        return OHHTTPStubsResponse(error: error)
    }
  }
}
