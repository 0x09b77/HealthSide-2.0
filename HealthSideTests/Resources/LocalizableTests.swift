@testable import HealthSide
import Testing

struct LocalizableTests {
    @Test func `healthside symbol resolves to app name`() {
        #expect(String(localized: .healthside) == "HealthSide")
    }
}
