# PlaydateUIKit

Design beautiful user interfaces for apps and games on **Playdate** with
PlaydateKit.

**PlaydateUIKit** is a complementary package that provides developers the
tools needed to built consistent user interfaces for apps and games on the
[Playdate](https://play.date) game console. It leverages the `PlaydateKit`
library and is designed to have a similar feel to Apple's UIKit library
for iOS, iPadOS, and tvOS.

> **Important**  
> PlaydateUIKit is still a work in progress and is considered pre-release
> software. APIs may change over time and are not representative of the
> final shipping build. Use at your own risk!

## Getting started

Start by adding the `PlaydateUIKit` dependency to your project:

```swift
dependencies: [
    .package(url: "https://source.marquiskurt.net/PDUniverse/PlaydateUIKit.git", branch: "main")
]
```

Then add `PlaydateUIKit` as a dependency to your Playdate game or app:

```swift
.target(
    ...
    dependencies: [
        ...
        .product(name: "PlaydateUIKit", package: "PlaydateUIKit"),
    ]
)
```

> **Note**  
> To use the PlaydateUIKit symbols library and other UI resources, you'll
> need to copy the resources directory in `Sources/PlaydateKit/Resources`
> into your Playdate game project for the time being until we can find a
> way to bundle these ✨automagically✨.

## Usage

> **Important**  
> Documentation for PlaydateUIKit is still a work in progress.

As an example, you can create a `PlaydateGame` that manages the lifecycle
of a `UIViewController`:

```swift
import PlaydateKit
import PlaydateUIKit

final class MyApp: PlaydateGame {
    let rootViewController: UIViewController

    init() {
        self.rootViewController = UIViewController()
    }

    func update() -> Bool {
        rootViewController.update()
        return true
    }
}

class ViewController: UIViewController {
    private lazy var label: UILabel = {
        let label = UILabel(
            text: "Hello, Playdate!",
            frame: Rect(
                at: Point(x: 16, y: 16),
                size: UISize(width: Display.width - 32, height: 20)
            )
        )
        label.font = .preferredFont(for: .body)
        return label
    }()

    init() {
        super.init()
        view.addSubview(label)
    }
}
```

## Contribute to PlaydateUIKit

This project is currently accepting contributions through GitHub until
Forgejo and other Git repository hosting services support federated pull
requests.

If you'd like to report a bug or request a feature, you can do so at
the links below.

[View issues &rsaquo;](https://youtrack.marquiskurt.net/youtrack/issues/PUK)  
[Report an issue &rsaquo;](https://youtrack.marquiskurt.net/youtrack/newIssue?project=PUK)

Please be sure to follow best coding practices for this project.

## Credits 

**PlaydateUIKit** is made possible thanks to the following open-source
projects:

- [PlaydateKit](https://github.com/finnvoor/PlaydateKit) - CC0 1.0 Universal
- [UTF8ViewExtensions](https://github.com/strawdynamics/UTF8ViewExtensions) - CC0 1.0 Universal

## License

PlaydateUIKit is free and open-source software licensed under the MIT
License. For more information, refer to LICENSE.txt.