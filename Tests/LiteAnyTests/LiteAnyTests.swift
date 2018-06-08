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
        XCTAssert(try LiteAny.nil.to(Bool?.self) == Optional<Bool>.none)
        XCTAssert(try LiteAny.nil.to(Int?.self) == Optional<Int>.none)
        XCTAssert(try LiteAny.nil.to(Double?.self) == Optional<Double>.none)
        XCTAssert(try LiteAny.nil.to(String?.self) == Optional<String>.none)

        XCTAssert(try LiteAny.bool(true).to(Bool?.self) == Optional<Bool>(true))
        XCTAssert(try LiteAny.int(1).to(Int?.self) == Optional<Int>(1))
        XCTAssert(try LiteAny.double(1.1).to(Double?.self) == Optional<Double>(1.1))
        XCTAssert(try LiteAny.string("1").to(String?.self) == Optional<String>("1"))

        XCTAssert(try LiteAny.bool(true).to(Bool.self) == true)
        XCTAssert(try LiteAny.int(1).to(Int.self) == 1)
        XCTAssert(try LiteAny.double(1.1).to(Double.self) == 1.1)
        XCTAssert(try LiteAny.string("1").to(String.self) == "1")

        XCTAssertThrowsError(try LiteAny.nil.to(UInt?.self))
        XCTAssertThrowsError(try LiteAny.int(1).to(UInt?.self))
        XCTAssertThrowsError(try LiteAny.nil.to(String.self))
    }

    static var allTests = [
        ("testJSONDecode", testJSONDecode),
        ("testJSONEncode", testJSONEncode),
        ("testTo", testTo),
    ]
}
