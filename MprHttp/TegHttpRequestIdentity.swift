//
//  Describes an HTTP request: url, HTTP method, body data etc.
//

import Foundation

public struct TegHttpRequestIdentity
{
  public let url: String
  public let method: TegHttpMethod
  public let requestBody: NSData?
  public let contentType: TegHttpContentType
  public let httpHeaders: [TegHttpHeader]
  public let mockedResponse: String?
  
  /// An optional logger function that will be called during request and response
  public var logger: TegHttpLoggerCallback?

  public init(url: String,
    method: TegHttpMethod,
    requestBody: NSData?,
    contentType: TegHttpContentType,
    httpHeaders: [TegHttpHeader],
    mockedResponse: String?) {

    self.url = url
    self.method = method
    self.requestBody = requestBody
    self.contentType = contentType
    self.httpHeaders = httpHeaders
    self.mockedResponse = mockedResponse
  }

  public init(url: String) {
    self.url = url
    method = TegHttpMethod.Get
    requestBody = nil
    contentType = TegHttpContentType.Unspecified
    httpHeaders = []
    self.mockedResponse = nil
  }

  public init(identityToCopy: TegHttpRequestIdentity, httpHeaders: [TegHttpHeader]) {
    url = identityToCopy.url
    method = identityToCopy.method
    requestBody = identityToCopy.requestBody
    contentType = identityToCopy.contentType
    mockedResponse = identityToCopy.mockedResponse
    logger = identityToCopy.logger
    self.httpHeaders = httpHeaders
  }

  public var nsUrl: NSURL? {
    return NSURL(string: url)
  }
  
  public var urlRequest: NSURLRequest {
    let request = NSMutableURLRequest()
    request.URL = nsUrl
    request.HTTPMethod = method.rawValue
    request.HTTPBody = requestBody
    
    if contentType != TegHttpContentType.Unspecified {
      request.addValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
    }
    
    for httpHeader in httpHeaders {
      request.addValue(httpHeader.value, forHTTPHeaderField: httpHeader.field)
    }
    
    return request
  }
}
