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
        case getAlbums(Int)
        
        var stringValue: String {
            
            switch self {
                case .getUsers:
                    return Endpoints.base + "/users"
                
                case .getAlbums(let userId):
                    return Endpoints.base + "/albums" + "?userId=\(userId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    @discardableResult private func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
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
    
    func getAlbums(for userId: Int, completion: @escaping ([Album], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getAlbums(userId).url, responseType: [Album].self) { response, error in
            if let albums = response {
                completion(albums, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    func getPhotos(for albums: [Album], completion: @escaping ([Photo], Error?) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "jsonplaceholder.typicode.com"
        components.path = "/photos"
        components.queryItems = [URLQueryItem]()
        
        for album in albums {
            components.queryItems?.append(URLQueryItem(name: "albumId",
                                                        value: String(album.id)))
        }
        let url = (components.url)!
        
        taskForGETRequest(url: url, responseType: [Photo].self) { response, error in
            if let photos = response {
                completion(photos, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    func downloadImage(path: String, completion: @escaping (Data?, Error?) -> Void) {
        if let url = URL(string: path){
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    completion(data, error)
                }
            }
            task.resume()
        }
    }
}
