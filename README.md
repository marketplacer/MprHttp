# HTTP helper classes for iOS / Swift

## TegHttpText

This library is a collection of methods for loading text from remote source. It works as a wrapper around `NSURLSession` and provides shorter syntax.


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

Note: `load` function calls the `onSuccess`, `onError` and `onAlways` callbacks in the main queue. Use `loadAsync` function if you need them to be called asynchronously.


### Customizing HTTP request

You can supply custom request parameters by initializing the `TegHttpRequestIdentity` object.

```Swift
let header = TegHttpHeader(field: "myHeader", value: "my value")
let data = NSData()

let identity = TegHttpRequestIdentity(
  url: "http://server.com/",
  method: TegHttpMethod.Get,
  requestBody: data,
  contentType: TegHttpContentType.Json,
  httpHeaders: [header],
  mockedResponse: "test-mocked-response"
)
```

