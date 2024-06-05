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
