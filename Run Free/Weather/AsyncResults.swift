//
//  AsyncResults.swift
//  Run Free
//
//  Created by Jordan Gallivan on 10/25/23.
//

import Foundation

enum AsyncResult<Success> {
    case empty
    case inProgress
    case success(Success)
    case failure(Error)
}
