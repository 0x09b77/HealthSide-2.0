import Observation

@Observable
final class RootViewModel {
    private(set) var email = ""
    private(set) var password = ""
}

// MARK: - Events

extension RootViewModel {
    func emailChanged(_ email: String) {
        self.email = email
    }

    func passwordChanged(_ password: String) {
        self.password = password
    }
}
