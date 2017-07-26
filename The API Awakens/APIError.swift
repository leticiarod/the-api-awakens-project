//
//  APIError.swift
//  The API Awakens
//
//  Created by Leticia Rodriguez on 7/24/17.
//  Copyright © 2017 Leticia Rodriguez. All rights reserved.
//

import Foundation

enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case responseUnsuccessful
    case invalidData
    case jsonParsingFailure(message: String)
}
