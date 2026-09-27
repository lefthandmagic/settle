import XCTest
@testable import Settle

final class LibraryTests: XCTestCase {
    func testModulesCoverTheLibrary() {
        XCTAssertEqual(Library.session(.flight).count, 10)
        XCTAssertEqual(Library.session(.bed).count, 10)
        XCTAssertEqual(Library.session(.desk).count, 8)
        XCTAssertEqual(Library.session(.hotel).count, 6)
        XCTAssertEqual(Library.session(.wakeup).count, 6)
        XCTAssertEqual(Library.all.count, 24)
    }

    func testEveryMoveNamesItsMusclesAndClip() {
        XCTAssertTrue(Library.all.allSatisfy { !$0.muscles.isEmpty && $0.video == $0.id })
        let female = Library.all.map { $0.clip(.female) }
        let male = Library.all.map { $0.clip(.male) }
        XCTAssertEqual(Set(female).count, female.count)
        XCTAssertTrue(female.allSatisfy { $0.hasSuffix("-f") })
        XCTAssertTrue(male.allSatisfy { $0.hasSuffix("-m") })
    }

    func testMuscleFilterAndBodyMapAgree() {
        let glutes = Library.matching(.glutes)
        XCTAssertFalse(glutes.isEmpty)
        XCTAssertTrue(glutes.allSatisfy { $0.muscles.contains(.glutes) })
        let mapped = Set(BodyZone.all.flatMap(\.muscles))
        let used = Set(Library.all.flatMap(\.muscles))
        XCTAssertEqual(mapped, used)
    }

    func testPlaylistsResolve() {
        for module in Module.allCases {
            let session = Library.session(module)
            XCTAssertEqual(session.count, Library.playlists[module]?.count)
            XCTAssertTrue(session.allSatisfy { $0.modules.contains(module) })
        }
    }
}
