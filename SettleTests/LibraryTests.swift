import XCTest
@testable import Settle

final class LibraryTests: XCTestCase {
    func testFlightAndBedAreSeparate() {
        XCTAssertEqual(Library.flight.count, 10)
        XCTAssertEqual(Library.bed.count, 10)
        XCTAssertTrue(Library.flight.allSatisfy { $0.place == .flight })
        XCTAssertTrue(Library.bed.allSatisfy { $0.place == .bed })
    }

    func testEveryMoveHasItsOwnVideo() {
        let names = Library.all.map(\.video)
        XCTAssertEqual(Set(names).count, names.count)
        XCTAssertTrue(Library.all.allSatisfy { $0.video == $0.id })
    }

    func testSessionsStayInPlace() {
        XCTAssertEqual(Library.session(.flight).map(\.id), Library.flight.map(\.id))
        XCTAssertEqual(Library.session(.bed).map(\.id), Library.bed.map(\.id))
    }
}
