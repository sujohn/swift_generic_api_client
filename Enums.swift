enum RequestMethod: String {

    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

enum FileType: String {
    /// image/webm, audio/ogg, audio/mpeg, audio/mp4, video/mpeg, video/quicktime, video/webm
    /// application/msword, application/excel, application/powerpoint, application/x-zip
    case jpeg = "image/jpeg"
    case png = "image/png"
    case gif = "image/gif"
    case tiff = "image/tiff"
    case bmp = "image/bmp"
    case quickTime = "video/quicktime"
    case mov = "video/mov"
    case mp4 = "video/mp4"
    case pdf = "application/pdf"
    case vnd = "application/vnd"
    case plainText = "text/plain"
    case anyBinary = "application/octet-stream"
}
