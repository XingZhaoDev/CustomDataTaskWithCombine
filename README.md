# CustomDataTaskWithCombine
Create Custom Publisher &amp; Subscriber &amp; Subscription with iOS Combine Framework

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
