import Foundation

struct NewsResponse: Codable {
    let news: [News]
}

struct News: Codable {
    let id: Int
    let title: String
    let text: String
    let url: String
    let image: String
    let publishDate: String
    let author: String?
    let sourceCountry: String

    enum CodingKeys: String, CodingKey {
        case id, title, text, url, image
        case publishDate = "publish_date"
        case author
        case sourceCountry = "source_country"
    }
}

