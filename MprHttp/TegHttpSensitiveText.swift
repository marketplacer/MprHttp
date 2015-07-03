public struct TegHttpSensitiveText {
  /**

  Hides the message if it contains any of the sensitive words listed in `sensitiveWords` array.

  - parameter text: Text to be analyzed for sensitive words.
  - parameter sensitiveWords: Arrays of sensitive words.
  - returns: Sanitized text.
  
  */
  public static func hideSensitiveContent(text: String, sensitiveWords: [String]) -> String {
    if isSensitive(text, sensitiveWords: sensitiveWords) {
      return "****** hidden ******"
    }
    
    return text
  }
  
  public static func isSensitive(text: String, sensitiveWords: [String]) -> Bool {
    for substring in sensitiveWords {
      if TegString.contains(text, substring: substring, ignoreCase: true) {
        return true
      }
    }
    
    return false
  }
}