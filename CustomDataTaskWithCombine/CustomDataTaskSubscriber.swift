//
//  CustomDataTaskSubscriber.swift
//  CustomDataTaskWithCombine
//
//  Created by Xing Zhao on 2021/4/19.
//

import Foundation
import Combine


class CustomDataTaskSubscriber<Input: Decodable>: Subscriber {
    
    typealias Failure = Error
    
    //Subscriber has to retain the subscription
    var subscription: Subscription?
    
    func receive(subscription: Subscription) {
        print("Received subscription")
        self.subscription = subscription
        
        // subscriber ask data from subscription. .unlimited means the subscriber will receive data as much as possible
        subscription.request(.unlimited)
    }
    
    func receive(_ input: Input) -> Subscribers.Demand {
        print("Received input \(input)")
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Error>) {
        print("Received completion \(completion)")
        cancel()
    }
    
    // once compelte,we have to cancel the subscription to break the retain cycle
    func cancel() {
        subscription?.cancel()
        subscription = nil
    }
}
