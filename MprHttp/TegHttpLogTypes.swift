/**

Types of log messages.

*/
public enum TegHttpLogTypes: Int{
  case RequestUrlAndMethod
  case RequestBody
  case ErrorHttp
  case ErrorResponseBody
  case ResponseSuccessBody
}