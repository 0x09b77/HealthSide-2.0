import XCTest

@MainActor
final class RootUITests: XCTestCase {
    func testRootShowsAppName() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["HealthSide"].waitForExistence(timeout: 5))
    }
}
