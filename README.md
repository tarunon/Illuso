# Illuso
Illuso is JSON encoder for swift.

## Summary
```swift
let json = try! encode(CGRectZero)
print(try! json.stringify())
```
Illuso can encode Struct or Swift Class.  
Any code for encoding is not required in Illuso.  

## Custom Encoding
Unfortunately, Enum and some of Objective-C Class (e.g. NSURL, NSDate, UIView ...) is unsupported in Illuso.  
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
```ruby
git "https://github.com/tarunon/Illuso.git"
```

## Motivate
In swift, we may use awesome JSON decoding tools [Argo](https://github.com/thoughtbot/Argo "Argo"), or [Himotoki](https://github.com/ikesyo/Himotoki "Himotoki"), but these cannot encode.  
Illuso is required no coding because used Mirror, so we can use with Argo or Himotoki without conflict!!
