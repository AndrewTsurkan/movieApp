import UIKit

fileprivate enum NetworkError: Error {
    case invalidURL
    case noData
}

final class NetworkManager {
    static var shared = NetworkManager() ; private init() { }
    
    private let baseURL = "https://kinopoiskapiunofficial.tech"
    private let apiKey = "de1db718-950e-449d-88a1-39a41062cee6"
    func fetchRequest(page: Int, queryParams: [String: String] = [:], complection: @escaping (Result<MoviesResponse, Error>) -> ()) {
        let endPoint = "/api/v2.2/films"
        
        var allParams = queryParams
        allParams["page"] = "\(page)"
        
        guard let url = makeURL(endpoint: endPoint, queryParams: allParams) else {
            complection(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                complection(.failure(error))
                return
            }
            
            guard let data else {
                complection(.failure(NetworkError.noData))
                return
            }
            
            do {
                let moviesResponse = try JSONDecoder().decode(MoviesResponse.self, from: data)
                complection(.success(moviesResponse))
            } catch {
                complection(.failure(error))
            }
        }
        
        task.resume()
    }
    
    private func makeURL(endpoint: String, queryParams: [String: String]) -> URL? {
        var components = URLComponents(string: baseURL)
        components?.path = endpoint
        components?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components?.url
    }
    
    func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = ImageCache.shared.getImage(url: urlString) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data,
                  let image = UIImage(data: data) else { return }
            ImageCache.shared.save(url: urlString, image: image)
            DispatchQueue.main.async {
                completion(image)
            }
        }
        task.resume()
    }
}
