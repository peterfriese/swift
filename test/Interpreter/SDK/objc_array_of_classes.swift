// RUN: %target-run-simple-swift
// REQUIRES: executable_test
// REQUIRES: objc_interop

import Foundation
import StdlibUnittest

var NSURLSessionConfigurationUsage = TestSuite("NSURLSessionConfigurationUsage")

// NSURLSessionConfiguration.protocolClasses is a prominent example of an
// NSArray<Class> * in Foundation. Make sure it works.
NSURLSessionConfigurationUsage.test("protocolClasses") {
  if let protocols = NSURLSessionConfiguration
    .defaultSessionConfiguration()
    .protocolClasses {

    for proto in protocols {
      // The protocol classes should all be subclasses of NSURLProtocol.
      _ = proto as! NSURLProtocol.Type
    }
  }
}

// Validate that Swift arrays of class objects can be bridged to NSArray
// and recovered as arrays of class objects.

var ArrayOfClassObjectBridging = TestSuite("ArrayOfClassObjectBridging")

ArrayOfClassObjectBridging.test("bridging class object array to NSArray") {
  let classes: [NSObject.Type] = [NSObject.self, NSString.self, NSArray.self]

  let classesBridged: NSArray = classes

  expectTrue(classesBridged.count == 3)
  expectTrue(classesBridged[0] === NSObject.self)
  expectTrue(classesBridged[1] === NSString.self)
  expectTrue(classesBridged[2] === NSArray.self)
}

ArrayOfClassObjectBridging.test("bridging NSArray of class objects to [AnyObject]") {
  let classes: [NSObject.Type] = [NSObject.self, NSString.self, NSArray.self]
  let classesBridged: NSArray = classes
  let classesUnbridgedAsAnyObject = classesBridged as [AnyObject]

  expectTrue(classesUnbridgedAsAnyObject.count == 3)
  expectTrue(classesUnbridgedAsAnyObject[0] === NSObject.self)
  expectTrue(classesUnbridgedAsAnyObject[1] === NSString.self)
  expectTrue(classesUnbridgedAsAnyObject[2] === NSArray.self)
}

ArrayOfClassObjectBridging.test("bridging NSArray of class objects to [AnyClass]") {
  let classes: [NSObject.Type] = [NSObject.self, NSString.self, NSArray.self]
  let classesBridged: NSArray = classes

  if let classesUnbridgedAsAnyClass = classesBridged as? [AnyClass] {
    expectTrue(classesUnbridgedAsAnyClass.count == 3)
    expectTrue(classesUnbridgedAsAnyClass[0] == NSObject.self)
    expectTrue(classesUnbridgedAsAnyClass[1] == NSString.self)
    expectTrue(classesUnbridgedAsAnyClass[2] == NSArray.self)
  } else {
    expectUnreachable()
  }
}

ArrayOfClassObjectBridging.test("bridging NSArray of class objects to [NSObject.Type]") {
  let classes: [NSObject.Type] = [NSObject.self, NSString.self, NSArray.self]
  let classesBridged: NSArray = classes

  if let classesUnbridgedAsNSObjectType = classesBridged as? [NSObject.Type] {
    expectTrue(classesUnbridgedAsNSObjectType.count == 3)
    expectTrue(classesUnbridgedAsNSObjectType[0] == NSObject.self)
    expectTrue(classesUnbridgedAsNSObjectType[1] == NSString.self)
    expectTrue(classesUnbridgedAsNSObjectType[2] == NSArray.self)
  } else {
    expectUnreachable()
  }
}

runAllTests()
