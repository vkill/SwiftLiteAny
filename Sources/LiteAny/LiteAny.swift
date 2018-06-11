public enum LiteAny: Codable, Equatable {
    case `nil`
    case bool(Bool)
    case int(Int)
    case double(Double)
    case string(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .nil
            return
        }
        do {
            self = .bool(try container.decode(Bool.self))
        } catch {
            do {
                self = .int(try container.decode(Int.self))
            } catch {
                do {
                    self = .double(try container.decode(Double.self))
                } catch {
                    do {
                        self = .double(Double(try container.decode(Float.self)))
                    } catch {
                        do {
                            self = .string(try container.decode(String.self))
                        }
                    }
                }
            }
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .nil:
            try container.encodeNil()
        case .bool(let val):
            try container.encode(val)
        case .int(let val):
            try container.encode(val)
        case .double(let val):
            try container.encode(val)
        case .string(let val):
            try container.encode(val)
        }
    }

    enum ToErrors: Error {
        case noMatch
        case isNil
    }

    // swiftlint:disable cyclomatic_complexity
    public func to<T>(_ type: T?.Type) throws -> T? where T: Decodable
    // swiftlint:enable cyclomatic_complexity
    {
        switch self {
        case .nil:
            switch type {
            case is Bool?.Type:
                return T?.none
            case is Int?.Type:
                return T?.none
            case is Double?.Type:
                return T?.none
            case is String?.Type:
                return T?.none
            default:
                ()
            }
        case .bool(let val):
            switch type {
            case is Bool?.Type:
                // swiftlint:disable force_cast
                return T?(val as! T)
                // swiftlint:enable force_cast
            default:
                ()
            }
        case .int(let val):
            switch type {
            case is Int?.Type:
                // swiftlint:disable force_cast
                return T?(val as! T)
                // swiftlint:enable force_cast
            default:
                ()
            }
        case .double(let val):
            switch type {
            case is Double?.Type:
                // swiftlint:disable force_cast
                return T?(val as! T)
                // swiftlint:enable force_cast
            default:
                ()
            }
        case .string(let val):
            switch type {
            case is String?.Type:
                // swiftlint:disable force_cast
                return T?(val as! T)
                // swiftlint:enable force_cast
            default:
                ()
            }
        }
        throw ToErrors.noMatch
    }

    // swiftlint:disable cyclomatic_complexity
    public func to<T>(_ type: T.Type) throws -> T where T: Decodable
    // swiftlint:enable cyclomatic_complexity
    {
        switch self {
        case .nil:
            throw ToErrors.isNil
        case .bool(let val):
            switch type {
            case is Bool.Type:
                // swiftlint:disable force_cast
                return val as! T
                // swiftlint:enable force_cast
            default:
                ()
            }
        case .int(let val):
            switch type {
            case is Int.Type:
                // swiftlint:disable force_cast
                return val as! T
                // swiftlint:enable force_cast
            default:
                ()
            }
        case .double(let val):
            switch type {
            case is Double.Type:
                // swiftlint:disable force_cast
                return val as! T
                // swiftlint:enable force_cast
            default:
                ()
            }
        case .string(let val):
            switch type {
            case is String.Type:
                // swiftlint:disable force_cast
                return val as! T
                // swiftlint:enable force_cast
            default:
                ()
            }
        }
        throw ToErrors.noMatch
    }
}
