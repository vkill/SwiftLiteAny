import XCTest
@testable import LiteAny

final class LiteAnyTests: XCTestCase {
    func testJSONDecode() throws {
        let jsonString = """
        [null,true,1,1.1,"a"]
        """
        let jsonData = jsonString.data(using: .utf8)!

        let list = try JSONDecoder().decode([LiteAny].self, from: jsonData)

        XCTAssertEqual(
            list,
            [LiteAny.nil, LiteAny.bool(true), LiteAny.int(1), LiteAny.double(1.1), LiteAny.string("a")]
        )
    }

    func testJSONEncode() throws {
        let list = [
            LiteAny.nil, LiteAny.bool(true), LiteAny.int(1), LiteAny.double(1.1), LiteAny.string("a")
        ]

        print(list)

        let jsonData = try JSONEncoder().encode(list)
        let jsonString = String(data: jsonData, encoding: .utf8)!

        #if os(Linux)
        XCTAssertEqual(
            jsonString,
            """
            [null,true,1,1.1,"a"]
            """
        )
        #else
        XCTAssertEqual(
            jsonString,
            """
            [null,true,1,1.1000000000000001,"a"]
            """
        )
        #endif
    }

    func testTo() throws {
        XCTAssertEqual(try LiteAny.nil.to(Bool?.self), Bool?.none)
        XCTAssertEqual(try LiteAny.nil.to(Int?.self), Int?.none)
        XCTAssertEqual(try LiteAny.nil.to(Double?.self), Double?.none)
        XCTAssertEqual(try LiteAny.nil.to(String?.self), String?.none)

        XCTAssertEqual(try LiteAny.bool(true).to(Bool?.self), Bool?(true))
        XCTAssertEqual(try LiteAny.int(1).to(Int?.self), Int?(1))
        XCTAssertEqual(try LiteAny.double(1.1).to(Double?.self), Double?(1.1))
        XCTAssertEqual(try LiteAny.string("1").to(String?.self), String?("1"))

        XCTAssertEqual(try LiteAny.bool(true).to(Bool.self), true)
        XCTAssertEqual(try LiteAny.int(1).to(Int.self), 1)
        XCTAssertEqual(try LiteAny.double(1.1).to(Double.self), 1.1)
        XCTAssertEqual(try LiteAny.string("1").to(String.self), "1")

        XCTAssertThrowsError(try LiteAny.bool(true).to(Int.self)) { error in
            XCTAssertEqual(error as? LiteAny.ToErrors, LiteAny.ToErrors.noMatch)
        }
        XCTAssertThrowsError(try LiteAny.bool(true).to(Int?.self)) { error in
            XCTAssertEqual(error as? LiteAny.ToErrors, LiteAny.ToErrors.noMatch)
        }

        XCTAssertThrowsError(try LiteAny.nil.to(String.self)) { error in
            XCTAssertEqual(error as? LiteAny.ToErrors, LiteAny.ToErrors.isNil)
        }
    }

    func testEquation() {
        XCTAssertTrue(LiteAny.nil == nil)
        XCTAssertFalse(LiteAny.nil != nil)
        XCTAssertTrue(LiteAny.bool(true) == true)
        XCTAssertTrue(LiteAny.int(1) == 1)
        XCTAssertTrue(LiteAny.double(1.1) == 1.1)
        XCTAssertTrue(LiteAny.string("1") == "1")
    }

    static var allTests = [
        ("testJSONDecode", testJSONDecode),
        ("testJSONEncode", testJSONEncode),
        ("testTo", testTo),
        ("testEquation", testEquation)
    ]
}
