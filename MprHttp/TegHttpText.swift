//
//  Sends HTTP request and gets a text response.
//

import Foundation

public class TegHttpText {
  public init() { }
  
  public func load(identity: TegHttpRequestIdentity,
    onSuccess: (String)->(),
    onError: ((NSError?, NSHTTPURLResponse?, String?)->())? = nil,
    onAlways: (()->())? = nil) -> NSURLSessionDataTask? {
      
    return TegDownloaderMainQueue.load(identity,
      onSuccess: { [weak self] (data, response) in
        self?.handleSuccessResponse(data,
          response: response, onSuccess: onSuccess, onError: onError)
      },
      onError: { error, response in
        onError?(error, response, nil)
      },
      onAlways: onAlways
    )
  }
  
  public func handleSuccessResponse(data: NSData?, response: NSHTTPURLResponse,
    onSuccess: (String)->(),
    onError: ((NSError, NSHTTPURLResponse?, String?)->())? = nil) {
      
    let bodyText = dataToString(data)
      
    if response.statusCode != 200 {
      // Response is received successfully but its HTTP status is not 200
      logError(data, response: response)
      onError?(TegHttpError.Not200FromServer.nsError, response, bodyText)
      return
    }
    
    if let bodyText = bodyText {
      onSuccess(bodyText)
      logSuccessResponse(bodyText)
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
  
  public func logSuccessResponse(text: String) {
    let sanitizedText = TegHttpSensitiveText.hideSensitiveContent(text)
    print("\n----- HTTP Response ------")
    print(sanitizedText)
    print("-----\n")
  }
  
  public func logError(data: NSData?, response: NSHTTPURLResponse) {
    print("HTTP Error \(response.statusCode)")
    
    if let data = data,
      errorText = NSString(data: data, encoding: NSUTF8StringEncoding) as? String where
      !TegString.blank(errorText) {
        
      let sanitizedText = TegHttpSensitiveText.hideSensitiveContent(errorText)
        
      print("\n----- Error text ------")
      print(sanitizedText)
      print("-----\n")
    }
  }
}
