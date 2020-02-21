//
//  NetworkClient.swift
//  JSONPlaceholderTest
//
//  Created by dragdimon on 21/02/2020.
//

import Foundation

class NetworkClient {
    
    enum Endpoints {
        
        static let base = "https://jsonplaceholder.typicode.com"
        
        case getUsers
        case getAlbums
        case getPhotos
        
        var stringValue: String {
            
            switch self {
                case .getUsers:
                    return Endpoints.base + "/users"
                
                case .getAlbums:
                    return Endpoints.base + "/albums"
                
                case .getPhotos:
                    return Endpoints.base + "/photos"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    private func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                
            }
        }
        task.resume()
        
        return task
    }
    
    func getUsers(completion: @escaping ([User], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getUsers.url, responseType: [User].self) { response, error in
            if let users = response {
                completion(users, nil)
            } else {
                completion([], error)
            }
        }
    }
    
}
