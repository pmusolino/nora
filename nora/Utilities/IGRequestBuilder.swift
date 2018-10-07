import Foundation

// Instagram Request Builder
final class IGRequestBuilder {
    let baseUrl = "https://api.instagram.com"
    let accessToken = "&access_token=\(InstagramSecret.accessToken)"

    func searchHashtag(by searchText: String) -> URL? {
        return URL(string: baseUrl + "/v1/tags/search?q=\(searchText)" + accessToken)
    }
}
