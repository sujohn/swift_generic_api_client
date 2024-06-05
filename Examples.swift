enum EventsEndpoints: EndpointProvider {

    case getEvents
    case attendEvent(id: String)
    case dismissEvent(id: String)

    var path: String {
        switch self {
        case .getEvents:
            return "/api/v2/activity/event"
        case .attendEvent:
            return "/api/v2/activity/event/attending"
        case .dismissEvent:
            return "/api/v2/activity/event/dismiss"
        }
    }

    var method: RequestMethod {
        switch self {
        case .getEvents:
            return .get
        case .attendEvent:
            return .put
        case .dismissEvent:
            return .post
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .dismissEvent(let eventId):
            return [URLQueryItem(name: "eventId", value: eventId)]
        default:
            return nil
        }
    }

    var body: [String: Any]? {
        switch self {
        case .attendEvent(let eventId):
            return ["eventId": eventId]
        default:
            return nil
        }
    }

    var mockFile: String? {
        switch self {
        case .getEvents:
            return "_getEventsMockResponse"
        case .attendEvent:
            return "_attendEventMockResponse"
        case .dismissEvent:
            return "_dismissEventMockResponse"
        }
    }
}
//======================================================
struct Password: Encodable {
    let password: String
}

enum UserEndpoints: EndpointProvider {
    case createPassword(password: Password)

  /// skipping other bits 

    var body: [String: Any]? {
        switch self {
        case .createPassword(let password):
            return password.toDictionary
        default:
            return nil
        }
    }
}

//=================================================

final class EventsViewModel: ObservableObject {

    let apiClient: ApiProtocol // 1

    init(apiClient: ApiProtocol = ApiClient()) { // MockApiClient()
         self.apiClient = apiClient // 2
     }

    @Published var userEvents: [Event] = []
    @Published var eventError: ApiError?
    private var cancellables: Set<AnyCancellable> = []

    @MainActor
    func getAsyncEvents() async { // 3
        let endpoint = EventsEndpoints.getEvents
        Task.init {
            do {
                let events = try await apiClient.asyncRequest(endpoint: endpoint, responseModel: [Event].self)
                userEvents = events
            } catch let error as ApiError {
                eventError = error
            }
        }
    }

    func getCombineEvents() { // 4
        let endpoint = EventsEndpoints.getEvents
        apiClient.combineRequest(endpoint: endpoint, responseModel: [Event].self)
            .receive(on: DispatchQueue.main) // 5
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.eventError = error
                }
            } receiveValue: { [weak self] events in
                guard let self = self else { return }
                self.userEvents = events
            }
            .store(in: &cancellables)
    }
}
