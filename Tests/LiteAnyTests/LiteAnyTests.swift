import XCTest
@testable import LiteAny

final class LiteAnyTests: XCTestCase {
    func testJSONDecode() throws {
        let jsonString = """
        [null,true,1,1.1,"a"]
        """
        let jsonData = jsonString.data(using: .utf8)!

        let list = try JSONDecoder().decode([LiteAny].self, from: jsonData)
        XCTAssert(list == [
            LiteAny.nil, LiteAny.bool(true), LiteAny.int(1), LiteAny.double(1.1), LiteAny.string("a")
        ])
    }

    func testJSONEncode() throws {
        let list = [
            LiteAny.nil, LiteAny.bool(true), LiteAny.int(1), LiteAny.double(1.1), LiteAny.string("a")
        ]

        let jsonData = try JSONEncoder().encode(list)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        #if os(Linux)
        XCTAssert(jsonString == """
        [null,true,1,1.1,"a"]
        """)
        #else
        XCTAssert(jsonString == """
        [null,true,1,1.1000000000000001,"a"]
        """)
        #endif
    }

    func testTo() throws {
        XCTAssert(try LiteAny.nil.to(Bool?.self) == Bool?.none)
        XCTAssert(try LiteAny.nil.to(Int?.self) == Int?.none)
        XCTAssert(try LiteAny.nil.to(Double?.self) == Double?.none)
        XCTAssert(try LiteAny.nil.to(String?.self) == String?.none)

        XCTAssert(try LiteAny.bool(true).to(Bool?.self) == Bool?(true))
        XCTAssert(try LiteAny.int(1).to(Int?.self) == Int?(1))
        XCTAssert(try LiteAny.double(1.1).to(Double?.self) == Double?(1.1))
        XCTAssert(try LiteAny.string("1").to(String?.self) == String?("1"))

        XCTAssert(try LiteAny.bool(true).to(Bool.self) == true)
        XCTAssert(try LiteAny.int(1).to(Int.self) == 1)
        XCTAssert(try LiteAny.double(1.1).to(Double.self) == 1.1)
        XCTAssert(try LiteAny.string("1").to(String.self) == "1")

        XCTAssertThrowsError(try LiteAny.nil.to(UInt?.self))
        XCTAssertThrowsError(try LiteAny.int(1).to(UInt?.self))
        XCTAssertThrowsError(try LiteAny.nil.to(String.self))
    }

    func testEquation() {
        XCTAssert(LiteAny.nil == nil)
        XCTAssert(LiteAny.bool(true) != nil)
        XCTAssert(LiteAny.bool(true) == true)
        XCTAssert(LiteAny.int(1) == 1)
        XCTAssert(LiteAny.double(1.1) == 1.1)
        XCTAssert(LiteAny.string("1") == "1")
    }

    static var allTests = [
        ("testJSONDecode", testJSONDecode),
        ("testJSONEncode", testJSONEncode),
        ("testTo", testTo),
        ("testEquation", testEquation)
    ]
}
