# Http helper classes for iOS / Swift

## TegHttpText

Loads text from remote.

```Swift
let identity = TegHttpRequestIdentity(url: "http://server.com/")
let httpText = TegHttpText()

httpText.load(identity,
  onSuccess: { text in
    // Text from remotr
  },
  onError: { error, reponse, body in
    // Error occured
  },
  onAlways: {
    // Always run for error or success
  }
)
```