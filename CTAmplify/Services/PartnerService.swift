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
    
    func getPartner(implementationID: String, completion: @escaping (Partner?) -> ()) {
        let partner = Partner.keys
        let predicate = partner.implementationID == implementationID
//        Amplify.API.query(request: .paginatedList(Partner.self, where: predicate, limit: 1000)) { event in
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
    }
}
