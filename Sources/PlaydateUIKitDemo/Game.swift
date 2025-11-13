import PlaydateKit
import PlaydateUIKit

final class ViewController: UIViewController {
    lazy var button: UIButton = {
        let button = UIButton(
            style: .plain,
            frame: .inferredContentSize(at: Point(x: 16, y: 16)))
        button.font = .preferredSystemFont(for: .body)
        button.setTitle("Back", for: .normal)
        button.setImage(UIImage(symbolName: "chevron.left", textStyle: .body), for: .normal)
        button.controlDelegate = self
        return button
    }()

    override init() {
        super.init()
        view.addSubview(button)
        focus(on: button)
    }
}

extension ViewController: UIControlDelegate {
    func controlPressed(_ sender: UIControl) {
        guard sender === button else {
            return
        }
        print("I was clicked!")
    }
}

final class Game: PlaydateGame {
    let rootViewController: UIViewController

    init() {
        self.rootViewController = ViewController()
    }

    func update() -> Bool {
        rootViewController.update()
        return true
    }
}