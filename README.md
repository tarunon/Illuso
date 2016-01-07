# JSONEncoder
@umakozが「何でもJSONに出来るツールが欲しいよね」と仰ったので作った。

## Summary
大凡のclass,structをJSONにエンコード出来ます。出来ない場合はエラーを吐きます。
```swift
class A {
    var text: String = "A"
    var number: Int = 100
}

let json = try! encode(A())
```
Tuple、SetはArrayとして解釈します。
Enumは後述のEncodableを定義していない場合はエラーです。

## Encodable
Encodableを実装することで独自にエンコードを定義できます。
EnumやObjective-C由来のクラスの多くはエラーになるので、定義しましょう。
```swift
extension NSURL: Encodable {
    func toJSON() -> JSON {
        return .STRING(self.absoluteString)
    }
}
```

## Installation
```ruby
git "http://git.linecorp.com/tarunon/JSONEncoder.git"
```

## Todo
Naming.
Write tests.
Upload public github.
