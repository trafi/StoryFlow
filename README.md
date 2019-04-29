<h3 align="center">
<img src="Img/Logo.png" width="25%" alt="StoryFlow Logo"/>
</h3>

# StoryFlow

[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/trafi/StoryFlow/blob/master/LICENSE)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Functional view controllers automatic flow coordination ✨ ([As presented in UIKonf 📺](https://youtu.be/1r7r-mqaSuI))

<table>
    <tr>
        <th>Task</th>
        <th>With StoryFlow 😎</th>
        <th>Without StoryFlow 😱</th>
    </tr>
    <tr>
        <td>Create,</br>Inject,</br>Show</td>
        <td>
            <pre lang="swift">
typealias OutputType = String
&nbsp;
func doTask() {
    self.produce("Input")
}</pre>
        </td>
        <td>
            <pre lang="swift">
func doTask() {
    let nextVc = NextVc()
    nextVc.input = "Input"
    self.show(nextVc, sender: nil)
}</pre>
        </td>
    </tr>
    <tr valign="top">
        <td></td>
        <td>
            😎 completely <i>isolated</i> from other vcs.</br>
            🤓 gained <i>type-safe</i> <a href="#OutputProducing"><code>produce</code> func</a>.</br>
            😝 automatic <i>injection</i> of produced value.<br>
            😚 <a href="#CustomTransition">navigation <i>customizable</i></a> out of vc.</br>
            🥳 easy to <i>test</i> with mocked <code>produce</code>.</br></br>
        </td>
        <td>
            😳 knows the <i>type</i> of next vc.</br>
            😡 knows the <i>property</i> of next vc to inject.</br>
            😢 knows how to <i>navigate</i> to next vc.</br>
            🤯 easy to <i>break</i>, hard to test.</br></br>
        </td>
    </tr>
    <tr>
        <td>Update,</br>Unwind</td>
        <td>
            <pre lang="swift">
typealias OutputType = String
&nbsp;
func doTask() {
    self.produce("Update")
}</pre>
        </td>
        <td>
            <pre lang="swift">
func doTask() {
    let prevVc = self.presenting as! PrevVc
    prevVc.handle("Update")
    self.dismiss(animated: true)
}</pre>
        </td>
    </tr>
    <tr valign="top">
        <td></td>
        <td>
            😎 completely <i>isolated</i> from other vcs.</br>
            🤓 gained <i>type-safe</i> <a href="#OutputProducing"><code>produce</code> func</a>.</br>
            😝 automatic <i>update</i> with produced value.<br>
            😚 <a href="#CustomTransition">navigation <i>customizable</i></a> out of vc.</br>
            🥳 easy to <i>test</i> with mocked <code>produce</code>.</br></br>
        </td>
        <td>
            🤬 knows the <i>place in nav stack</i> of prev vc.</br>
            😳 knows the <i>type</i> of prev vc.</br>
            🥵 knows the <i>method</i> of prev vc for update.</br>
            😭 knows how to <i>unwind</i> to prev vc.</br>
            🤯 easy to <i>break</i>, hard to test.</br></br>
        </td>
    </tr>
    <tr>
        <td>Update,</br>Difficult</br>unwind</td>
        <td>
            <pre lang="swift">
typealias OutputType = Int
&nbsp;
func doTask() {
    self.produce(42)
}</pre>
        </td>
        <td>
            <pre lang="swift">
func doTask() {
    let nav = self.presenting as! NavC
    let prevVc = nav.vcs[2] as! PrevVc
    &nbsp;
    prevVc.handle(42)
    &nbsp;
    self.dismiss(animated: true)
    nav.popTo(preVc, animated: false)
}</pre>
        </td>
    </tr>
    <tr valign="top">
        <td></td>
        <td align="center">😎</td>
        <td align="center">😱😳😭🥵🤬🤯</td>
    </tr>
</table>

# Usage

StoryFlow **isolates** your view controllers from each other and **connects** them in a navigation flow using three simple generic protocols - [`InputRequiring`](#InputRequiring), [`OutputProducing`](#OutputProducing) and [`UpdateHandling`](#UpdateHandling). You can **customize** navigation transition styles using [`CustomTransition`](#CustomTransition) and routing using [`OutputTransform`](#OutputTransform).

## `InputRequiring`
	
StoryFlow contains `InputRequiring` protocol. What vc gets created, injected and shown after [producing an output](#OutputProducing) is determined by finding the exact type match to `InputType`.

This protocol has an extension that gives vc access to the produced output as its input. It is injected right after the init.

```swift
protocol InputRequiring {
    associatedtype InputType
}
extension InputRequiring {
    var input: InputType { return ✨ } // Returns 'output' produced by previous vc
}
```

<details>
<summary>🔎 see samples</summary><br>

```swift
class MyViewController: UIViewController, InputRequiring {

    typealias InputType = MyType

    override func viewDidLoad() {
        super.viewDidLoad()
        // StoryFlow provides 'input' that was produced as an 'output' by previous vc
        title = input.description
    }
}
```

```swift
class JustViewController: UIViewController, InputRequiring {

    // When vc doesn't require any input it should still declare it's 'InputType'.
    // Otherwise it's impossible for this vc to be opened using StoryFlow.
    struct InputType {}
}
```

Also there's a convenience initializer designed to make `InputRequiring` vcs easy.
```swift
extension InputRequiring {
    init(input: InputType) { ✨ }
}

// Example
let myType = MyType()
let myVc = MyViewController(input: myType)
myVc.input // myType
```
</details>

## `OutputProducing`

StoryFlow contains `OutputProducing` protocol. Conforming to it allows vcs to navigate to other vcs that are either in the nav stack and have the exact [`UpdateType`](#UpdateHandling) type or that have the exact [`InputType`](#InputRequiring) and will be initialized.

```swift
protocol OuputProducing {
    associatedtype OutputType
}
extension OuputProducing {
    func produce(_ output: OutputType) { ✨ } // Opens vc with matching `UpdateType` or `InputType`
}

typealias IO = InputRequiring & OutputProducing // For convenience
```

<details>
<summary>🔎 see samples</summary><br>
	
```swift
class MyViewController: UIViewController, OutputProducing {

    typealias OutputType = MyType

    @IBAction func goToNextVc() {
        // StoryFlow will go back to a vc in the nav stack with `UpdateType = MyType`
	// Or it will create, inject and show a new vc with `InputType = MyType`
        produce(MyType())
    }
}
```

To produce more than one type of output see the section about [`OneOfN`](#Multiple-types) enum.

Also there's a convenience initializer designed to make `OutputProducing` vcs easy.
```swift
extension OutputProducing {
    init(produce: @escaping (OutputType) -> ()) { ✨ }
}

// Example
let myType = MyType
let myVc = MyViewController(produce: { output in
    output == myType // true
})
myVc.produce(myType)

```
</details>

## `UpdateHandling`

StoryFlow contains `UpdateHandling` protocol. Conforming to it allows to navigate back to it and passing data. Unwind happens and `handle(update:)` gets called when `UpdateType` exactly matches the [produced output](#OutputProducing) type.

```swift
protocol UpdateHandling {
    associatedtype UpdateType
    func handle(update: UpdateType) // Gets called with 'output' of dismissed vc
}

typealias IOU = InputRequiring & OutputProducing & UpdateHandling // For convenience
```

<details>
<summary>🔎 see samples</summary><br>
	
```swift
class UpdatableViewController: UIViewController, UpdateHandling {

    func handle(update: MyType) {
        // Do something ✨
        // This gets called when a presented vc produces an output of `OutputType = MyType`
    }
}
```

To handle more than one type of output see the section about [`OneOfN`](#Multiple-types) enum.
</details>

## Multiple types

To [require](#InputRequiring), [produce](#OutputProducing) and [handle](#UpdateHandling) more than one type StoryFlow introduces a `OneOfN` enum. It's used to define `OutputType`, `InputType` and `UpdateType` typealiases. Enums for up to `OneOf8` are defined, but it's possible to nest them as much as needed.

```swift
enum OneOf2<T1, T2> {
    case t1(T1), t2(T2)
}
```

<details>
<summary>🔎 see samples</summary><br>
	
```swift
class ZooViewController: UIViewController, IOU {
    
    // 'OneOfN' with 'InputRequiring'
    typealias InputType = OneOf2<Jungle, City>

    override func viewDidLoad() {
        super.viewDidLoad()
	// Just use the 't1'...'tN' enum cases
	switch input {
	case .t1(let jungle):
	    title = jungle.name
	case .t2(let city):
	    title = city.countryName
	}
    }
    
    // 'OneOfN' with 'OutputProducing'
    typealias OutputType = OneOf8<Tiger, Lion, Panda, Koala, Fox, Dog, Cat, OneOf2<Pig, Cow>>
    
    @IBAction func openRandomGate() {
        // There are a few ways 'produce' can be called with 'OneOfN' type
	switch Int.random(in: 1...9) {
        case 1: produce(.t1(🐯)) // Use 't1' enum case to wrap 'Tiger' type
        case 2: produce(.value(🦁)) // Use convenience 'value' to wrap 'Lion' to 't2' case
        case 3: produce(🐼) // Use directly with 'Panda' type
        case 4: produce(🐨)
        case 5: produce(🦊)
        case 6: produce(🐶)
        case 7: produce(🐱)
        case 8: produce(.t8(.t1(🐷))) // Use 't8' and 't1' enum cases to double wrap it
        case 9: produce(.value(🐮)) // Use 'value' to wrap it only once
	}
    }
    
    // 'OneOfN' with 'UpdateHandling'
    typealias UpdateType = OneOf3<Day, Night, Holiday>
    
    func handle(update: UpdateType) {
	// Just use the 't1'...'tN' enum cases
	switch input {
	case .t1(let day):
	    subtitle = "Opened during \(day.openHours)"
	case .t2(let night):
	    subtitle = "Closed for \(night.sleepHours)"
	    openRandomGate() // 🙈
	case .t3(let holiday):
	    subtitle = "Discounts on \(holiday.dates)"
	}
    }
}
```
</details>

## `CustomTransition`

By default StoryFlow will show new vcs using `show` method and will unwind using relevant combination of `dismiss` and `pop` methods. This is customizable using static functions on `CustomTransition`.

```swift
extension CustomTransition {
    struct Context {
        let from, to: UIViewController
        let output: Any, outputType: Any.Type
        let isUnwind: Bool
    }
    typealias Attempt = (Context) -> Bool
    
    // All registered transitions will be tried before fallbacking to default behavior
    static func register(attempt: @escaping Attempt) { ✨ }
}
```

## `OutputTransform`

By default [`OutputType`](#OutputProducing) have to exactly match to [`InputType`](#InputRequiring) and [`UpdateType`](#UpdateHandling) for destination to be found and for navigation transitions to happen. This can be customized using a static funtion on `OutputTransform`. Note, that `To` can be a [`OneOfN`](#Multiple-types) type, allowing for easy AB testing or other navigation splits that are determined outside of vcs.

```swift
extension OutputTransform {
    // All relevant registered transforms will be applied before destination vc lookup
    static func register<From, To>(transform: @escaping (From) -> To) { ✨ } 
}
```

# Installation

[Using Carthage](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application) - just add the following line to your `Cartfile`:
```
github "Trafi/StoryFlow"
```

