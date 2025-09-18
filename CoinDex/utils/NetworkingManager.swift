//
//  NetworkingManager.swift
//  CoinDex
//
//  Created by Pranav on 05/09/25.
//

import Foundation
import Combine

class NetworkingManager{
    
    enum NetworkingError:LocalizedError{
        case badUrlResponse(url:URL)
        case unknows
        
        var errorDescription: String?{
            switch self {
            case .badUrlResponse(url:let url):
                return "Bad response from URL: \(url):"
            case .unknows:
                return "Unknown error ocurred"
            }
        }
    }
    
    static func download(url:URL)->AnyPublisher<Data, Error>{
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap {try handleURLResponse(output: $0,url: url)}
            .retry(3)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output:URLSession.DataTaskPublisher.Output,url:URL)throws ->Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode>=200 && response.statusCode<300
        else{ throw NetworkingError.badUrlResponse(url: url) }
        return output.data
    }
    
    static func handleCompletion(completion:Subscribers.Completion<any Error>){
        switch completion{
        case .finished: break
        case .failure(let err): print(err.localizedDescription)
        }
    }
}
