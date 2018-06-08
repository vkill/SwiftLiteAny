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

    enum ToErrors: Error {
        case NoMatch
        case IsNil
    }

    public func to<T>(_ type: Optional<T>.Type) throws -> Optional<T> where T: Decodable {
        switch self {
        case .nil:
            switch type {
            case is Optional<Bool>.Type:
                return Optional<T>.none
            case is Optional<Int>.Type:
                return Optional<T>.none
            case is Optional<Double>.Type:
                return Optional<T>.none
            case is Optional<String>.Type:
                return Optional<T>.none
            default:
                ()
            }
        case .bool(let v):
            switch type {
            case is Optional<Bool>.Type:
                return Optional<T>(v as! T)
            default:
                ()
            }
        case .int(let v):
            switch type {
            case is Optional<Int>.Type:
                return Optional<T>(v as! T)
            default:
                ()
            }
        case .double(let v):
            switch type {
            case is Optional<Double>.Type:
                return Optional<T>(v as! T)
            default:
                ()
            }
        case .string(let v):
            switch type {
            case is Optional<String>.Type:
                return Optional<T>(v as! T)
            default:
                ()
            }
        }
        throw ToErrors.NoMatch
    }

    public func to<T>(_ type: T.Type) throws -> T where T: Decodable {
        switch self {
        case .nil:
            throw ToErrors.IsNil
        case .bool(let v):
            switch type {
            case is Bool.Type:
                return v as! T
            default:
                ()
            }
        case .int(let v):
            switch type {
            case is Int.Type:
                return v as! T
            default:
                ()
            }
        case .double(let v):
            switch type {
            case is Double.Type:
                return v as! T
            default:
                ()
            }
        case .string(let v):
            switch type {
            case is String.Type:
                return v as! T
            default:
                ()
            }
        }
        throw ToErrors.NoMatch
    }
}
