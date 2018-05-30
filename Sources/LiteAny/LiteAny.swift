import Foundation

public enum LiteAny: Codable, Equatable {
    case `nil`
    case bool(Bool)
    case int(Int)
    case double(Double)
    case string(String)

    public init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if c.decodeNil() {
            self = .nil
            return
        }
        do {
            let v = try c.decode(Bool.self)
            self = .bool(v)
        } catch {
            do {
                let v = try c.decode(Int.self)
                self = .int(v)
            } catch {
                do {
                    let v = try c.decode(Double.self)
                    self = .double(v)
                } catch {
                    do {
                        let v = try c.decode(Float.self)
                        self = .double(Double(v))
                    } catch {
                        do {
                            let v = try c.decode(String.self)
                            self = .string(v)
                        }
                    }
                }
            }
        }
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.singleValueContainer()
        switch self {
        case .nil:
            try c.encodeNil()
        case .bool(let v):
            try c.encode(v)
        case .int(let v):
            try c.encode(v)
        case .double(let v):
            try c.encode(v)
        case .string(let v):
            try c.encode(v)
        }
    }
}

