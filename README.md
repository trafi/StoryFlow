<h3 align="center">
<img src="Img/Logo.png" width="25%" alt="StoryFlow Logo"/>
</h3>

# StoryFlow

[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/trafi/StoryFlow/blob/master/LICENSE)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Functional view controllers automatic flow coordination :sparkles:

[Watch this being presented at UIKonf 2018](https://youtu.be/1r7r-mqaSuI).

## Interfaces

```swift
protocol InputRequiring {
    associatedtype InputType
}
extension InputRequiring {
    var input: InputType { return ✨ }
}
```
```swift
protocol OuputProducing {
    associatedtype OutputType
}
extension OuputProducing {
    func produce(_ output: OutputType) { ✨ }
}
```
```swift
protocol UpdateHandling {
    associatedtype UpdateType
    func handle(update: UpdateType)
}
```
```swift
typealias IO = InputRequiring & OutputProducing
typealias IOU = InputRequiring & OutputProducing & UpdateHandling

```
