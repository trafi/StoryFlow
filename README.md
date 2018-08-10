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
    var input: InputType { return ✨ } // Returns 'output' of previous vc
}
```
```swift
protocol OuputProducing {
    associatedtype OutputType
}
extension OuputProducing {
    func produce(_ output: OutputType) { ✨ } // Opens vc with matching `UpdateType` or `InputType`
}
```
```swift
protocol UpdateHandling {
    associatedtype UpdateType
    func handle(update: UpdateType) // Gets called with 'output' of dismissed vc
}
```
```swift
typealias IO = InputRequiring & OutputProducing
typealias IOU = InputRequiring & OutputProducing & UpdateHandling

```
