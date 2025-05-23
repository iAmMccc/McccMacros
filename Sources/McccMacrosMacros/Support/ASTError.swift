//
//  File.swift
//  McccMacros
//
//  Created by qixin on 2025/5/22.
//

import Foundation

struct ASTError: CustomStringConvertible, Error {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var description: String {
        text
    }
}
