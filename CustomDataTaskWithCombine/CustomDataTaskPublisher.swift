//
//  CustomDataTaskPublisher.swift
//  CustomDataTaskWithCombine
//
//  Created by Xing Zhao on 2021/4/19.
//

import Foundation
import Combine

extension URLSession {
    struct CustomDataTaskPubliser<Output: Decodable>: Publisher {
        
        
        typealias Failure = Error
        let urlRequest: URLRequest

        func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            let subscription = CustomDataTaskSubscription(urlRequest: urlRequest, subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }
    }
    
    func customDtaTaskPublisher<Output: Decodable>(for urlRequest: URLRequest) -> CustomDataTaskPubliser<Output> {
        return CustomDataTaskPubliser<Output>(urlRequest: urlRequest)
    }
}

extension URLSession.CustomDataTaskPubliser {
    class CustomDataTaskSubscription<Output: Decodable, S:Subscriber>:Subscription where S.Input == Output,S.Failure == Error{
        private let urlRequest: URLRequest
        // we can notice that the subscription retian the subscriber here.
        private var subscriber: S?
        
        init(urlRequest: URLRequest,subscriber: S) {
            self.urlRequest = urlRequest
            self.subscriber = subscriber
        }
        
        func cancel() {
            subscriber = nil
        }
        
        func request(_ demand: Subscribers.Demand) {
            if demand > 0 {
                URLSession.shared.dataTask(with: urlRequest){ [weak self] data,response,error in
                    
                    defer{ self?.cancel()}
                    if let data = data {
                        do {
                            let result = try JSONDecoder().decode(Output.self, from: data)
                            self?.subscriber?.receive(result)
                            self?.subscriber?.receive(completion: .finished)
                        } catch {
                            self?.subscriber?.receive(completion: .failure(error))
                        }
                    } else if let error = error {
                        self?.subscriber?.receive(completion: .failure(error))
                    }
                    
                }
                .resume()
            }
        }
    }
}
