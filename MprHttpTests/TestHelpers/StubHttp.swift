//
// Shortcut methods for subbing HTTP requests with OHHTTPStubs.
//

import OHHTTPStubs

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
  
  
  // MARK: - URL matchers
  
  class func forUrlsContaining(urlPart: String) -> (NSURLRequest->Bool) {
    return { req in
      TegString.contains(req.URL!.absoluteString, substring: urlPart)
    }
  }
}
