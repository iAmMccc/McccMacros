import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(McccMacrosMacros)
import McccMacrosMacros

let testMacros: [String: Macro.Type] = [
    "stringify": StringifyMacro.self,
    "UserDefault": UserDefaultMacro.self,
]
#endif

final class McccMacrosTests: XCTestCase {
    func testMacro() throws {
        #if canImport(McccMacrosMacros)
        assertMacroExpansion(
            """
            #stringify(a + b)
            """,
            expandedSource: """
            (a + b, "a + b")
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testMacroWithStringLiteral() throws {
        #if canImport(McccMacrosMacros)
        assertMacroExpansion(
            #"""
            #stringify("Hello, \(name)")
            """#,
            expandedSource: #"""
            ("Hello, \(name)", #""Hello, \(name)""#)
            """#,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testMacroWithUserDefault() throws {
        #if canImport(McccMacrosMacros)
        assertMacroExpansion(
            #"""
            struct Settings {
                @UserDefault(forKey: "kkkkkkk")
                var username: String = "Mccc111"
            }
            """#,
            expandedSource: #"""
            struct Settings {
                var username: String
                {
                    get {
                        (UserDefaults.standard.value(forKey: "username") as? String)!
                    }
                    set {
                        UserDefaults.standard.setValue(newValue, forKey: "username")
                    }
                }
            }

            """#,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
