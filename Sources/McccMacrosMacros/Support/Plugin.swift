//
//  File.swift
//  McccMacros
//
//  Created by qixin on 2025/5/22.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct McccMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        StringifyMacro.self,
        UserDefaultMacro.self,
    ]
}
