//
//  TypeInferencer.swift
//  McccMacros
//
//  Created by qixin on 2025/5/23.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// 用于类型推导和语法判断
struct TypeHelpers {
    private init() { }
    
    
    static func unwrapOptionalType(from typeSyntax: TypeSyntax) -> (isOptional: Bool, typeDescription: String) {
        if let optional = typeSyntax.as(OptionalTypeSyntax.self) {
            return (true, optional.wrappedType.trimmedDescription)
        } else {
            return (false, typeSyntax.trimmedDescription)
        }
    }
}
