//
//  PartnerService.swift
//  CTAmplify
//
//  Created by Rafael Ortiz on 11/09/2023.
//

import Foundation
import Amplify
import AmplifyPlugins

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
    
//    func getPartner(implementationID: String, completion: @escaping (Partner?) -> ()) {
//        let partner = Partner.keys
//        let predicate = partner.implementationID == implementationID
//
//        Amplify.API.query(request: .paginatedList(Booking.self, where: predicate, limit: 1000)) { event in
//            switch event {
//            case .success(let result):
//                switch result {
//                case .success(let partner):
//                    completion(partner)
//                case .failure(let error):
//                    print("Got failed result with \(error.errorDescription)")
//                    completion(nil)
//                }
//            case .failure(let error):
//                print("Got failed event with error \(error)")
//                completion(nil)
//            }
//        }
//    }
    
    func iterate(object: AnyObject, parent: String = "") -> String {
        var propsString = ""
        var count: UInt32 = 0
        
        if let objectArray = object as? NSArray {
            for obj in objectArray {
                propsString += self.iterate(object: obj as AnyObject)
            }
        }

        guard let properties = class_copyPropertyList(object_getClass(object), &count) else {
            return propsString
        }
        
        propsString += "\n*************\n"
        if parent.count > 0 {
           propsString += "BEGIN - \(parent) -> "
        }
        propsString += "\(NSStringFromClass(type(of: object.self)))"
        propsString += "\n*************\n"
        
        for index in 0...count - 1 {
            let property1 = property_getName(properties[Int(index)])
            let result1 = String(cString: property1)
            let propertyObject = object.value(forKeyPath: result1) as AnyObject
            let propertyValue = String(describing: propertyObject)
            
            if let propArray = propertyObject as? NSArray {
                for prop in propArray {
                    propsString += self.iterate(object: prop as AnyObject, parent: result1)
                }
            } else if propertyValue.contains("<") &&
                propertyValue.contains(">") &&
                propertyValue.contains("0x") {
                propsString += self.iterate(object: propertyObject, parent: result1)
            } else {
                propsString += "\(result1): \(propertyValue)\n"
            }
        }
        
        if parent.count > 0 {
           propsString += "************* \n"
           propsString += "END - \(NSStringFromClass(type(of: object.self)))"
           propsString += "\n*************\n\n"
        }

        return propsString.replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")", with: "")
    }
}
