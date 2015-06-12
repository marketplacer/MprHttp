import Foundation
import Quick
import Nimble
import MprHttp

class TegHttpHeaderSpec: QuickSpec {
  override func spec() {
    var header: TegHttpHeader!
    
    describe("instantiation") {
      beforeEach {
        header = TegHttpHeader(field: "test-field", value: "test-value")
      }
      
      it("should have a valid field") {
        expect(header.field) == "test-field"
      }
      
      it("should have a valid value") {
        expect(header.value) == "test-value"
      }
    }
    
    describe("Equatable") {
      context("when equal") {
        it("should be equal") {
          let anotherHeader = TegHttpHeader(field: "test-field", value: "test-value")
          expect(header) == anotherHeader
        }
      }
      
      context("whit different fields") {
        it("should not be equal") {
          let anotherHeader = TegHttpHeader(field: "test-field-not-equal", value: "test-value")
          expect(header).toNot(equal(anotherHeader))
        }
      }
      
      context("whit different values") {
        it("should not be equal") {
          let anotherHeader = TegHttpHeader(field: "test-fieldl", value: "test-value-not-equa")
          expect(header).toNot(equal(anotherHeader))
        }
      }
    }
  }
}
