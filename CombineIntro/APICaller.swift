//
//  APICaller.swift
//  CombineIntro
//
//  Created by Paulo Silva on 07/09/2021.
//
import Combine
import Foundation

class APICaller {
    static let shared = APICaller()
    
    // instead of a completion handler we will use Combine
    func fetchCompanies() -> Future<[String], Error> {
        // simulate network request
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                promise(.success(["Apple", "Google", "Microsoft", "Facebook"]))
            }
        }
    }
}
