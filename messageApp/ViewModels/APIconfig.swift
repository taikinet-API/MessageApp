//
//  config.swift
//

import Foundation

struct APIconfig{
    
    static let publicID = "16.176.165.34"
    
    static var baseURL: URL {
        URL(string: "http://\(publicID):3000")!
    }
}
