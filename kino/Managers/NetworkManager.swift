import UIKit

fileprivate enum NetworkError: Error {
    case invalidURL
    case noData
}

final class NetworkService {
    //MARK: - Singltone -
    
    static let shared = NetworkService(); private init() { }
    
    //MARK: - Private -
    private let apiKey = "de1db718-950e-449d-88a1-39a41062cee6"
    
    private func createURL(id: Int?, images: String?, queryParams: [String: String]?) -> URL? {
        let tunnel = "https://"
        let server = "kinopoiskapiunofficial.tech"
        let baseEndPoint = "/api/v2.2/films"
        let endPoint = "\(baseEndPoint)\(id.map { "/\($0)" } ?? "")\(images.map { "/\($0)" } ?? "")"
        let urlString = tunnel + server + endPoint
        var components = URLComponents(string: urlString)
        
        if let queryParams, !queryParams.isEmpty {
            components?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        return components?.url
    }
    
    func fetchData<T: Decodable>(id: Int? = nil, images: String? = nil, page: Int? = nil, queryParams: [String: String] = [:], decodingType: T.Type) async throws -> T {
        
        var allParams = queryParams
        
        if let page {
            allParams["page"] = "\(page)"
        }
        
        guard let url = createURL(id: id, images: images, queryParams: allParams) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let response = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(T.self, from: response.0)
        return result
    }
    
    func loadImage(urlString: String) async throws -> UIImage {
        
        if let cachedImage = ImageCache.shared.getImage(url: urlString) {
            return cachedImage
        }
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let response = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: response.0) else {
            throw NetworkError.noData
        }
        
        ImageCache.shared.save(url: urlString, image: image)
        return image
    }
}
