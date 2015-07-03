

import Foundation

/**

Sends HTTP request and gets a text response.

*/
public class TegHttpText {
  public init() { }
  
  /// Loads text from remote source. The callbacks are called in the main queue.
  public func load(identity: TegHttpRequestIdentity,
    onSuccess: (String)->(),
    onError: ((NSError?, NSHTTPURLResponse?, String?)->())? = nil,
    onAlways: (()->())? = nil) -> NSURLSessionDataTask? {
      
    return TegDownloaderMainQueue.load(identity,
      onSuccess: { [weak self] (data, response) in
        self?.handleSuccessResponse(identity, data: data,
          response: response, onSuccess: onSuccess, onError: onError)
      },
      onError: { error, response in
        onError?(error, response, nil)
      },
      onAlways: onAlways
    )
  }
  
  /// Loads text from remote source. The callbacks are called asynchronously.
  public func loadAsync(identity: TegHttpRequestIdentity,
    onSuccess: (String)->(),
    onError: ((NSError?, NSHTTPURLResponse?, String?)->())? = nil,
    onAlways: (()->())? = nil) -> NSURLSessionDataTask? {
      
    return TegDownloaderAsync.load(identity,
      onSuccess: { [weak self] (data, response) in
        self?.handleSuccessResponse(identity, data: data,
          response: response, onSuccess: onSuccess, onError: onError)
      },
      onError: { error, response in
        onError?(error, response, nil)
      },
      onAlways: onAlways
    )
  }
  
  public func handleSuccessResponse(identity: TegHttpRequestIdentity,
    data: NSData?, response: NSHTTPURLResponse,
    onSuccess: (String)->(),
    onError: ((NSError, NSHTTPURLResponse?, String?)->())? = nil) {
      
    let bodyText = dataToString(data)
      
    if response.statusCode != 200 {
      // Response is received successfully but its HTTP status is not 200
      logError(identity, data: data, response: response)
      onError?(TegHttpError.Not200FromServer.nsError, response, bodyText)
      return
    }
    
    if let bodyText = bodyText {
      onSuccess(bodyText)
      logSuccessResponse(identity, bodyText: bodyText, statusCode: response.statusCode)
    } else {
      onError?(TegHttpError.FailedToConvertResponseToText.nsError, response, nil)
    }
  }
  
  public func dataToString(data: NSData?) -> String? {
    if let data = data {
      return NSString(data: data, encoding: NSUTF8StringEncoding) as? String
    }
    
    return nil
  }
  
  // MARK: - Logging
  // ---------------------
  
  public func logSuccessResponse(identity: TegHttpRequestIdentity, bodyText: String, statusCode: Int) {
    identity.logger?(bodyText, .ResponseSuccessBody, statusCode)
  }
  
  public func logError(identity: TegHttpRequestIdentity, data: NSData?, response: NSHTTPURLResponse) {
    var reponseText = "Empty response"
    
    if let data = data,
      errorText = NSString(data: data, encoding: NSUTF8StringEncoding) as? String where
      !TegString.blank(errorText) {
        
      reponseText = errorText
    }
    
    identity.logger?(reponseText, .ResponseErrorBody, response.statusCode)
  }
}
