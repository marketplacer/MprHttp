/**

Types of log messages.

*/
public enum TegHttpLogTypes: Int{
  /// String containing an HTTP methos and request URL separated with space
  case RequestMethodAndUrl
  
  /// Contains request body
  case RequestBody
  
  /// Contains response body
  case ResponseSuccessBody
  
  /// Contains reponse error message for HTTP error like "No internet connection"
  case ResponseHttpError
  
  /// Contains response error body
  case ResponseErrorBody
}