protocol EndpointProvider {

    var scheme: String { get }
    var baseURL: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var token: String { get }
    var queryItems: [URLQueryItem]? { get }
    var body: [String: Any]? { get }
    var mockFile: String? { get }

    var multipart: MultipartRequest? { get }
}

extension EndpointProvider {

    var scheme: String { // 1
        return "https"
    }

    var baseURL: String { // 2
        return ApiConfig.shared.baseUrl
    }

    var token: String { //3
        return ApiConfig.shared.token?.value ?? ""
    }

    var multipart: MultipartRequest? {
        return nil
    }

    func asURLRequest() throws -> URLRequest { // 4

        var urlComponents = URLComponents() // 5
        urlComponents.scheme = scheme
        urlComponents.host =  baseURL
        urlComponents.path = path
        if let queryItems = queryItems {
            urlComponents.queryItems = queryItems
        }
        guard let url = urlComponents.url else {
            throw ApiError(errorCode: "ERROR-0", message: "URL error")
        }

        var urlRequest = URLRequest(url: url) // 6
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("true", forHTTPHeaderField: "X-Use-Cache")

        if !token.isEmpty {
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let body = body {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                throw ApiError(errorCode: "ERROR-0", message: "Error encoding http body")
            }
        }

        if let multipart = multipart {
            urlRequest.setValue(multipart.headerValue, forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("\(multipart.length)", forHTTPHeaderField: "Content-Length")
            urlRequest.httpBody = multipart.httpBody
        }
        
        return urlRequest
    }
}
