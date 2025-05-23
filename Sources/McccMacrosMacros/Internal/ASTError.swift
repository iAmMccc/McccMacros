//
//  File.swift
//  McccMacros
//
//  Created by qixin on 2025/5/22.
//

import Foundation

/// 自定义错误类型，用于抛出内部异常
enum ASTError: Error, CustomStringConvertible {
    
    /// 当属性没有显式指定类型时抛出此错误
    case variableRequiresExplicitType
    
    /// 当非可选属性缺少默认值，且无法推断出合理默认值时抛出此错误
    /// - Parameters:
    ///   - propertyName: 发生错误的属性名
    ///   - type: 属性的类型描述
    case missingDefaultValue(propertyName: String, type: String)
    
    /// 通用错误，允许传入自定义错误消息
    case generic(message: String)

    init(_ message: String) {
        self = .generic(message: message)
    }

    var description: String {
        switch self {
        case .variableRequiresExplicitType:
            return "UserDefault can only be applied to variables with explicit type"
        case let .missingDefaultValue(propertyName, type):
            return "Missing value for non-optional UserDefault key '\(propertyName)', and no default value can be inferred for type '\(type)'."
        case let .generic(message):
            return message
        }
    }
}
