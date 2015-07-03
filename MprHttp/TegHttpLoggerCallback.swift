
/**

A logger closure.

Parameters:

1. Log message
2. Type of the log.
3. Http status code, if applicable.

*/
public typealias TegHttpLoggerCallback = (String, TegHttpLogTypes, Int?)->()