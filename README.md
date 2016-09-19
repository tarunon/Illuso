# Illuso
[![Build Status](https://travis-ci.org/tarunon/Illuso.svg?branch=master)](https://travis-ci.org/tarunon/Illuso)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Illuso is JSON encoder for swift.

## Summary
```swift
let json = try! encode(CGRectZero)
print(try! json.stringify())
```
Illuso can encode struct, class, enum.  
Any code for encoding is not required in Illuso.  

## Custom Encoding
Unfortunately, some of Objective-C Class (e.g. NSURL, NSDate, UIView ...) is unsupported in Illuso. (returned empty dictionary)  
If you want to encode these types, can use Encodable protocol.
```swift
extension NSURL: Encodable {
    func encode() throws -> JSON {
        return try encode(self.absoluteString)
    }
}
```
Of course Encodable can be implemented at Struct, and Class.

## Installation
Use Carthage.
```ruby
github "tarunon/Illuso"
```

## LICENSE
MIT

## Motivate
In swift, we may use awesome JSON decoding tools [Argo](https://github.com/thoughtbot/Argo "Argo"), or [Himotoki](https://github.com/ikesyo/Himotoki "Himotoki"), but these cannot encode.  
Illuso is required no coding because used Mirror, so we can use with Argo or Himotoki without conflict!!
