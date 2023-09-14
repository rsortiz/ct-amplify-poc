//
//  PartnerService.swift
//  CTAmplify
//
//  Created by Rafael Ortiz on 11/09/2023.
//

import Foundation
import Amplify
import AmplifyPlugins

class PartnerService: ObservableObject {
    
    func listPartners(completion: @escaping ([Partner]) -> ()) {
        Amplify.DataStore.query(Partner.self) { event in
            switch event {
            case .success(let result):
                print("Partners: \(result)")
                completion(result)
            case .failure(let error):
                print("Error on query() for type Post - \(error.localizedDescription)")
            }
        }
    }
    
    func getPartnerJSON() {
        let request = RESTRequest(path: "/partner")
        Amplify.API.get(request: request) { result in
            switch result {
            case .success(let data):
                let str = String(decoding: data, as: UTF8.self)
                print("Success \(str)")
            case .failure(let apiError):
                print("Failed", apiError)
            }
        }
    }
    
    func getPartner(implementationID: String, completion: @escaping (Partner?) -> ()) {
        let booking = Partner.keys
        let predicate = booking.implementationID == implementationID
        Amplify.API.query(request: .paginatedList(Partner.self, where: predicate, limit: 1000)) { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let bookings):
                    print("Successfully retrieved list of todos: \(bookings)")
                    
                    var array = [Partner]()
                    for element in bookings { array.append(element) }
                    if let partner = array.first {
                        completion(partner)
                    }
                    
                case .failure(let error):
                    print("Got failed result with \(error.errorDescription)")
                    completion(nil)
                }
            case .failure(let error):
                print("Got failed event with error \(error)")
                completion(nil)
            }
        }
    }
}

protocol Loopable {
    func allProperties() -> [String: Any]
}

extension Loopable {
    func allProperties() -> [String: Any] {

        var result: [String: Any] = [:]

        let mirror = Mirror(reflecting: self)
        
        for (property, value) in mirror.children {
            guard let property = property else {
                continue
            }

            result[property] = value
        }

        return result
    }
    
    func allPropertiesString() -> [String: String] {
        var properties = [String: String]()
        let allProperties = self.allProperties()
        
        for key in allProperties.keys {
            if let value = allProperties[key] as? String, key != "id" {
                properties[key] = String(format: "%@", value)
            } else if let value = allProperties[key] as? Bool {
                properties[key] = String(format: "%d", value)
            }  else if let value = allProperties[key] as? NSArray {
                properties[key] = String(format: "%@", value)
            }
        }
        
        return properties
    }
}

extension Partner: Loopable {
    
}
