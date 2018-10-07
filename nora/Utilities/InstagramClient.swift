import Foundation

final class InstagramClient {
    private let instagramRequestBuilder: IGRequestBuilder

    init() {
        self.instagramRequestBuilder = IGRequestBuilder()
    }

    /* TEMP INSTAGRAM FETCH */
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

            var hashtagResponse: SearchHashtagResponse?
            do {
                hashtagResponse = try JSONDecoder().decode(SearchHashtagResponse.self, from: content)
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

            // TEMP RESPONSE STRUCT //
            struct SearchHashtagResponse: Decodable {
                let data: [HashtagData]
                let meta: HashtagMeta

                struct HashtagData: Decodable {
                    let name: String
                    let mediaCount: Int

                    enum CodingKeys: String, CodingKey {
                        case name
                        case mediaCount = "media_count"
                    }
                }

                struct HashtagMeta: Decodable {
                    let code: Double
                }
            }
            // TEMP RESPONSE STRUCT //
        }

        task.resume()
    }
    /* TEMP INSTAGRAM FETCH */
}
