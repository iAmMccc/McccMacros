//
//  PropertyResolver.swift
//  McccMacros
//
//  Created by qixin on 2025/5/23.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


/// 封装从属性声明中提取名称、类型、初始值等逻辑



struct PropertyResolver {
    
    private init() { }

    /// 解析并返回属性的默认值字符串表示。
    ///
    /// 该方法优先返回属性绑定中的初始化值（如果存在），
    /// 如果没有初始化值，则尝试通过全局默认值提供者获取默认值。
    /// 如果两者都不存在且属性类型非可选，将抛出异常。
    ///
    /// - Parameters:
    ///   - binding: 表示属性绑定的 `PatternBindingSyntax`，包含可能的初始化表达式。
    ///   - typeSyntax: 属性的类型信息，用于从默认值提供者获取匹配类型的默认值。
    ///
    /// - Returns: 返回一个 `String`，表示属性的默认值代码文本（如初始化表达式文本或全局默认值）。
    ///
    /// - Throws: 当属性为非可选类型且既没有初始化值，也没有全局默认值时，抛出 `ASTError`。
    static func defaultValue(for binding: PatternBindingSyntax, typeSyntax: TypeSyntax) throws -> String {
        
        // 判断是否可选
        if let _ = typeSyntax.as(OptionalTypeSyntax.self) {
            return "nil"
        }
        
        if let initializer = binding.initializer {
            return initializer.value.trimmedDescription
        }
        if let fallback = DefaultValueProvider.defaultValueCode(for: typeSyntax) {
            return fallback
        }
        
        let propertyName = (binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text) ?? "<unknown>"
        
        throw ASTError.missingDefaultValue(propertyName: propertyName, type: "\(typeSyntax)")
    }

    // 未来还可以放：解析属性名、解析属性类型、是否可选、包装器等
}
