//
//  HttpErrorMessage.swift
//  ExpenseTrack
//
//  Created by Thujeevan on 2023-09-23.
//

import Foundation

enum ErrorMessage: Codable {
    case single(String)
    case multiple([String])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let singleMessage = try? container.decode(String.self) {
            self = .single(singleMessage)
        } else if let multipleMessages = try? container.decode([String].self) {
            self = .multiple(multipleMessages)
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Failed to decode ErrorMessage"
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .single(let message):
            try container.encode(message)
        case .multiple(let messages):
            try container.encode(messages)
        }
    }
}
