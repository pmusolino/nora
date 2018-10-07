final class Hashtag {
    let name: String
    let usages: Int
    var state: State

    init(name: String, usages: Int, state: State = .none) {
        self.name = name
        self.usages = usages
        self.state = state
    }
}

extension Hashtag {

    enum State: String {
        case none = ""
        case added
        case selected
    }
}
