protocol ApiProtocol {
    func asyncRequest<T: Decodable>(endpoint: EndpointProvider, responseModel: T.Type) async throws -> T
    func combineRequest<T: Decodable>(endpoint: EndpointProvider, responseModel: T.Type) -> AnyPublisher<T, ApiError>
    func asyncUpload<T: Decodable>(endpoint: EndpointProvider, responseModel: T.Type) async throws -> T
    func asyncDownload(fileURL: URL) async throws -> URL // 1
    func asyncDownload(endpoint: EndpointProvider) async throws -> URL // 2
}
