import Foundation

extension URL: @retroactive ExpressibleByExtendedGraphemeClusterLiteral {}

extension URL: @retroactive ExpressibleByUnicodeScalarLiteral {}

extension URL: @retroactive ExpressibleByStringLiteral {
    public init(stringLiteral value: StaticString) {
        self = URL(string: "\(value)")!
    }
}
