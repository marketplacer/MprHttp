import Foundation
import Quick
import Nimble
import MprHttp

class TegHttpRequestIdentitySpec: QuickSpec {
  override func spec() {
    var header: TegHttpHeader!
    var identity: TegHttpRequestIdentity!
    
    describe("init") {
      beforeEach {
        header = TegHttpHeader(field: "test-field", value: "test-value")
        identity = TegHttpRequestIdentity(url: "http://www.test-url.com", method: TegHttpMethod.Get, requestBody: NSData(), contentType: TegHttpContentType.Json, httpHeaders: [header], mockedResponse: "test-mocked-response")
      }
      
      it("should have an url") {
        expect(identity.url) == "http://www.test-url.com"
      }
      
      it("should have a method") {
        expect(identity.method) == TegHttpMethod.Get
      }
      
      it("should have a requestBody") {
        expect(identity.requestBody) == NSData()
      }
      
      it("should have a contentType") {
        expect(identity.contentType) == TegHttpContentType.Json
      }
      
      it("should have httpHeaders") {
        expect(identity.httpHeaders) == [header]
      }
      
      it("should have a mockedResponse") {
        expect(identity.mockedResponse) == "test-mocked-response"
      }
    }
    
    describe("initWithUrl") {
      beforeEach {
        identity = TegHttpRequestIdentity(url: "http://www.test-url.com")
      }
      
      it("should have an url") {
        expect(identity.url) == "http://www.test-url.com"
      }
      
      it("should have a method") {
        expect(identity.method) == TegHttpMethod.Get
      }
      
      it("should have no requestBody") {
        expect(identity.requestBody).to(beNil())
      }
      
      it("should have a contentType") {
        expect(identity.contentType) == TegHttpContentType.Unspecified
      }
      
      it("should have no httpHeaders") {
        expect(identity.httpHeaders) == []
      }
      
      it("should have no mockedResponse") {
        expect(identity.mockedResponse).to(beNil())
      }
    }
    
    describe("initWitIdentityToCopy") {
      beforeEach {
        let identityToCopy = TegHttpRequestIdentity(url: "http://www.test-url.com")
        header = TegHttpHeader(field: "test-field", value: "test-value")
        identity = TegHttpRequestIdentity(identityToCopy: identityToCopy, httpHeaders: [header])
      }
      
      it("should have an url") {
        expect(identity.url) == "http://www.test-url.com"
      }
      
      it("should have a method") {
        expect(identity.method) == TegHttpMethod.Get
      }
      
      it("should have no requestBody") {
        expect(identity.requestBody).to(beNil())
      }
      
      it("should have a contentType") {
        expect(identity.contentType) == TegHttpContentType.Unspecified
      }
      
      it("should have no httpHeaders") {
        expect(identity.httpHeaders) == [header]
      }
      
      it("should have no mockedResponse") {
        expect(identity.mockedResponse).to(beNil())
      }
    }
    
    describe("url") {
      context("with a valid url") {
        beforeEach {
          identity = TegHttpRequestIdentity(url: "http://www.test-url.com")
        }
        
        it("should have an url") {
          expect(identity.nsUrl?.absoluteString) == "http://www.test-url.com"
        }
      }
      
      context("with an invalid url") {
        beforeEach {
          identity = TegHttpRequestIdentity(url: "🍏")
        }
        
        it("should have an url") {
          expect(identity.nsUrl).to(beNil())
        }
      }
    }
    
    describe("urlRequest") {
      var request: NSURLRequest!
      
      context("without a content type and a custom header") {
        beforeEach {
          header = TegHttpHeader(field: "test-field", value: "test-value")
          identity = TegHttpRequestIdentity(url: "http://www.test-url.com", method: TegHttpMethod.Get, requestBody: NSData(), contentType: TegHttpContentType.Json, httpHeaders: [header], mockedResponse: "test-mocked-response")
          request = identity.urlRequest
        }
        
        it("should have an url") {
          expect(request.URL?.absoluteString) == "http://www.test-url.com"
        }
        
        it("should have an HTTP Method") {
          expect(request.HTTPMethod) == "GET"
        }
        
        it("should have an HTTP body") {
          expect(request.HTTPBody) == NSData()
        }
        
        it("should have a Content type") {
          expect(request.valueForHTTPHeaderField("Content-Type")) == "application/json"
        }
        
        it("should have a custom header field") {
          expect(request.valueForHTTPHeaderField("test-field")) == "test-value"
        }
        
        it("should have 2 header fields") {
          expect(request.allHTTPHeaderFields?.count) == 2
        }
      }
      
      context("with a content type and a custom header") {
        beforeEach {
          identity = TegHttpRequestIdentity(url: "http://www.test-url.com")
          request = identity.urlRequest
        }
        
        it("should have no header fields") {
          expect(request.allHTTPHeaderFields).to(beEmpty())
        }
      }
    }
  }
}
