//
//  ViewController.swift
//  CustomDataTaskWithCombine
//
//  Created by Xing Zhao on 2021/4/19.
//

import UIKit
import Combine

struct DemoModel: Decodable {
    
    var config: ConfigModel?
    var version: String?
    var bundle_id: String?
    
    struct ConfigModel: Decodable{
        var fullscreen: String = ""
        var showbar: Int = 0
        var showads: Int = 0
        var screenbar: String = ""
    }
}



class ViewController: UIViewController {
    
    var customCancelable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestDemoData()
    }

    private func requestDemoData() {
        let urlRequest = URLRequest(url: URL(string: "https://jjgsapp.com/config")!)
        let publisher:URLSession.CustomDataTaskPubliser<DemoModel> = URLSession.shared.customDtaTaskPublisher(for: urlRequest)
        
        
        // we first use sink (built_in subscriber in Combine) to test our custom publisher and subscription
        customCancelable = publisher
            .receive(on: RunLoop.main) //  add this to the publisher to return to main thread for handling  UI updates
            .sink(receiveCompletion: { completion in
            print("Received completion \(completion)")
        }, receiveValue: { value in
            print("Received value: \(value)")
        })
        
        
        // Now we use our custom subscriber to test
        let subscriber = CustomDataTaskSubscriber<DemoModel>()
        publisher.subscribe(subscriber)
    }
}

