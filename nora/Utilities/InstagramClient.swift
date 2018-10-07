import Foundation

final class InstagramClient {
    private let instagramRequestBuilder: IGRequestBuilder

    init() {
        self.instagramRequestBuilder = IGRequestBuilder()
    }

    func searchInstagram(for hashtagName: String, completion: @escaping (_ hashtags: [Hashtag]) -> Void) {
        let searchHashtagRequest = instagramRequestBuilder.searchHashtag(by: hashtagName)
        let task = URLSession.shared.dataTask(with: searchHashtagRequest!) {(data, response, error) in

            guard error == nil else {
                print("error")
                return
            }

            guard let content = data else {
                print("no data")
                return
            }

            var hashtagResponse: Hashtag.SearchResponse?
            do {
                hashtagResponse = try JSONDecoder().decode(Hashtag.SearchResponse.self, from: content)
            } catch {
                print("cannot decode given data to HashtagResponse")
                return
            }

            var hashtagsResult = [Hashtag]()
            if let resp = hashtagResponse {
                hashtagsResult = resp.data.map { Hashtag(name: $0.name, usages: $0.mediaCount) }
            }

            DispatchQueue.main.async {
                completion(hashtagsResult)
            }
        }

        task.resume()
    }
}
