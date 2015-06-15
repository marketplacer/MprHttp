# HTTP helper classes for iOS / Swift

## TegHttpText

Loads text from remote.

```Swift
let identity = TegHttpRequestIdentity(url: "http://server.com/")
let httpText = TegHttpText()

httpText.load(identity,
  onSuccess: { text in
    // Text from remote
  },
  onError: { error, response, body in
    // Error occurred
  },
  onAlways: {
    // Always run for error or success
  }
)
```