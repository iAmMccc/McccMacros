//
//  File.swift
//  McccMacros
//
//  Created by qixin on 2025/5/22.
//

import Foundation
import SwiftSyntax

/// 提供默认值推导逻辑
public enum DefaultValueProvider {
    /// 推导默认值表达式（用于宏中展开）
    public static func defaultValueCode(for type: TypeSyntax) -> String? {
        // Optional 类型：直接返回 nil
        if type.as(OptionalTypeSyntax.self) != nil {
            return "nil"
        }

        // Simple 类型：Int, String, Bool 等
        if let simple = type.as(IdentifierTypeSyntax.self) {
            return defaultForSimpleType(simple.name.text)
        }

        // Array 类型
        if type.is(ArrayTypeSyntax.self) || isArrayLikeGeneric(type) {
            return "[]"
        }

        // Dictionary 类型
        if type.is(DictionaryTypeSyntax.self) || isDictionaryLikeGeneric(type) {
            return "[:]"
        }

        // 联合类型 A & B，取第一个为主（如有需要）
        if let composition = type.as(CompositionTypeSyntax.self),
           let first = composition.elements.first?.type {
            return defaultValueCode(for: first)
        }

        return nil
    }

    private static func defaultForSimpleType(_ type: String) -> String? {
        switch type {
        case "Int", "Int8", "Int16", "Int32", "Int64",
             "UInt", "UInt8", "UInt16", "UInt32", "UInt64":
            return "0"

        case "Float", "Double", "CGFloat":
            return "0.0"

        case "Bool":
            return "false"

        case "String":
            return "\"\""

        case "Date":
            return "Date()"

        case "Data":
            return "Data()"

        case "Decimal":
            return "Decimal(0)"

        default:
            return nil
        }
    }

    // 识别 Array<T> 泛型写法
    private static func isArrayLikeGeneric(_ type: TypeSyntax) -> Bool {
        guard let generic = type.as(IdentifierTypeSyntax.self),
              generic.name.text == "Array",
              let args = generic.genericArgumentClause?.arguments,
              args.count == 1 else { return false }
        return true
    }

    // 识别 Dictionary<K, V> 泛型写法
    private static func isDictionaryLikeGeneric(_ type: TypeSyntax) -> Bool {
        guard let generic = type.as(IdentifierTypeSyntax.self),
              generic.name.text == "Dictionary",
              let args = generic.genericArgumentClause?.arguments,
              args.count == 2 else { return false }
        return true
    }
}



/**
 | 类型结构        | SwiftSyntax 类型                 | 示例                |
 | ----------- | ------------------------------ | ----------------- |
 | 基本类型        | `SimpleTypeIdentifierSyntax`   | `Int`, `String`   |
 | 可选类型        | `OptionalTypeSyntax`           | `String?`         |
 | 数组类型        | `ArrayTypeSyntax`              | `[Int]`           |
 | 字典类型        | `DictionaryTypeSyntax`         | `[String: Int]`   |
 | 泛型类型        | `GenericSpecializedTypeSyntax` | `Array<Int>`      |
 | 元组类型        | `TupleTypeSyntax`              | `(Int, String)`   |
 | 联合类型（A & B） | `CompositionTypeSyntax`        | `A & B`           |
 | 闭包类型        | `FunctionTypeSyntax`           | `(Int) -> String` |

 
 */
