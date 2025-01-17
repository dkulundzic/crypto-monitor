import Foundation
import Factory

protocol RequestDecorator {
    func decorate(request: inout URLRequest)
}

struct DefaultRequestDecorator: RequestDecorator {
    func decorate(
        request: inout URLRequest
    ) {
        request.addValue(apiKey, forHTTPHeaderField: "X-CoinAPI-Key")
    }

    private enum CustomHTTPField: String {
        case apiKey = "X-CoinAPI-Key"
    }
}

extension Container {
    var requestDecorator: Factory<RequestDecorator> {
        self {
            DefaultRequestDecorator()
        }.unique
    }
}
