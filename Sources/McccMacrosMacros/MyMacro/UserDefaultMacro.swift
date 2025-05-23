//
//  UserDefaultMacro.swift
//  McccMacros
//
//  Created by qixin on 2025/5/22.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct UserDefaultMacro: AccessorMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        
        
        // 获取属性名和类型，属性名就应该只有一个，因为这个是属性绑定宏
        guard let varDecl = declaration.as(VariableDeclSyntax.self),
              let binding = varDecl.bindings.first,
              let name = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
              let typeSyntax = binding.typeAnnotation?.type
        else {
            throw ASTError.variableRequiresExplicitType
        }
        

        let saveKey = extractUserDefaultKey(from: node, fallback: name)
        
        let (isOptional, type) = TypeHelpers.unwrapOptionalType(from: typeSyntax)

        let getter: AccessorDeclSyntax
        /// 是否可选类型
        if isOptional {
            getter = """
            get {
                UserDefaults.standard.value(forKey: "\(raw: saveKey)") as? \(raw: type)
            }
            """
        } else {
            let defaultValue = try PropertyResolver.defaultValue(for: binding, typeSyntax: typeSyntax)
            getter = """
            get {
                UserDefaults.standard.value(forKey: "\(raw: saveKey)") as? \(raw: type) ?? \(raw: defaultValue)
            }
            """
        }
        
        // ✅ 构造 setter
        let setter = AccessorDeclSyntax(
            """
            set {
                UserDefaults.standard.setValue(newValue, forKey: "\(raw: saveKey)")
            }
            """
        )

        return [getter, setter]
    }
    
    /// 获取存储的key
    static func extractUserDefaultKey(from node: AttributeSyntax, fallback proertyName: String) -> String {
        guard let arguments = node.arguments?.as(LabeledExprListSyntax.self) else { return proertyName }

        for arg in arguments {
            if let expression = arg.expression.as(StringLiteralExprSyntax.self) {
                if let content = expression.segments.first?.as(StringSegmentSyntax.self)?.content.text {
                   return content
                }
            }
        }
        return proertyName
    }
}


/**
 (lldb) po node
 AttributeSyntax
 ├─atSign: atSign
 ╰─attributeName: IdentifierTypeSyntax
   ╰─name: identifier("UserDefault")
 (lldb) po declaration
 VariableDeclSyntax
 ├─attributes: AttributeListSyntax
 │ ╰─[0]: AttributeSyntax
 │   ├─atSign: atSign
 │   ╰─attributeName: IdentifierTypeSyntax
 │     ╰─name: identifier("UserDefault")
 ├─modifiers: DeclModifierListSyntax
 ├─bindingSpecifier: keyword(SwiftSyntax.Keyword.var)
 ╰─bindings: PatternBindingListSyntax
   ╰─[0]: PatternBindingSyntax
     ├─pattern: IdentifierPatternSyntax
     │ ╰─identifier: identifier("username")
     ╰─typeAnnotation: TypeAnnotationSyntax
       ├─colon: colon
       ╰─type: IdentifierTypeSyntax
         ╰─name: identifier("String")
 
 */


/**
 (lldb) po type
 OptionalTypeSyntax
 ├─wrappedType: IdentifierTypeSyntax
 │ ╰─name: identifier("String")
 ╰─questionMark: postfixQuestionMark
 
 (lldb) po type
 IdentifierTypeSyntax
 ╰─name: identifier("String")
 
 */


/**
 trimmedDescription 和 description的区别
 这些 .description 实际上返回的是 SyntaxProtocol 实现的 带格式的源码字符串，通常会保留：
 你的源代码缩进
 行尾空格
 甚至注释或换行
 
 
 SwiftSyntax 提供了这个便捷方法 trimmedDescription，会自动去掉前后空格、换行和注释。

 */


/**
 initializer 初始化值的获取
 */
