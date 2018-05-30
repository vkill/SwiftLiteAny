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

    static var allTests = [
        ("testJSONDecode", testJSONDecode),
        ("testJSONEncode", testJSONEncode),
    ]
}
