import Foundation

enum NewsError : Error {
    case requestFailed
    case decodeFailed
    case invalidURL
}

final class NewsService {
    
    private let key = "7dc44aff2c6f4b7d9c4ec14dda6cfe8f"
    
    func getNews(forQuery query: String, completion: @escaping (Result<NewsResponse, NewsError>) -> Void) {
        
        let fullURL = "https://api.worldnewsapi.com/search-news?api-key=\(key)&text=\(query)"
        
        guard let newsUrl = URL(string: fullURL) else {
            completion(.failure(.invalidURL))
            return }
        
        URLSession.shared.dataTask(with: newsUrl) { (data, _, error) in
            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let newsData = try decoder.decode(NewsResponse.self, from: data)
                completion(.success(newsData))
            } catch {
                completion(.failure(.decodeFailed))
            }
        }.resume()
    }
}
    
