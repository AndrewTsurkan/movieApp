import UIKit

fileprivate enum NetworkError: Error {
    case invalidURL
    case noData
}

final class NetworkManager {
    
    static var shared = NetworkManager() ; private init() { }
    
    private let baseURL = "https://kinopoiskapiunofficial.tech"
    private let apiKey = "de1db718-950e-449d-88a1-39a41062cee6"
    
    func getFilms(endPoint: String = "/api/v2.2/films",
                  page: Int,
                  queryParams: [String: String] = [:],
                  completion: @escaping (Result<MoviesResponse, Error>) -> ()) {
        
        var allParams = queryParams
        allParams["page"] = "\(page)"
        
        guard let url = makeURL(endpoint: endPoint, queryParams: allParams) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let moviesResponse = try JSONDecoder().decode(MoviesResponse.self, from: data)
                completion(.success(moviesResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getStillsFilm(id: Int,
                       page: Int,
                       completion: @escaping (Result<DetailScreenStillsFilms, Error>) -> ()) {
        let allParam = ["page" : "\(page)"]
        
        guard let url = makeURL(endpoint: "/api/v2.2/films/\(id)/images", queryParams: allParam) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let stillsResponse = try JSONDecoder().decode(DetailScreenStillsFilms.self, from: data)
                completion(.success(stillsResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getDetailFilm(id: Int, completion: @escaping (Result<DetailScreenResponse, Error>) -> ()) {
        
        guard let url = makeURL(endpoint: "/api/v2.2/films/\(id)", queryParams: nil) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let detailResponse = try JSONDecoder().decode(DetailScreenResponse.self, from: data)
                completion(.success(detailResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func makeURL(endpoint: String, queryParams: [String: String]?) -> URL? {
        var components = URLComponents(string: baseURL)
        components?.path = endpoint
        
        if let queryParams = queryParams, !queryParams.isEmpty {
            components?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
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
