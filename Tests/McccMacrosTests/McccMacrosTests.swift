import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(McccMacrosMacros)
import McccMacrosMacros

let testMacros: [String: Macro.Type] = [
    "UserDefault": UserDefaultMacro.self,
]
#endif

final class McccMacrosTests: XCTestCase {
    
    
    func testMacroWithUserDefault() throws {
        #if canImport(McccMacrosMacros)
        assertMacroExpansion(
            #"""
            struct Setting {
                
                @UserDefault
                var name: String = "Mccc"

                @UserDefault(forKey: "customKey")
                var age: Int = 111
            }
            """#,
            expandedSource: #"""
            struct Setting {

                var name: String {
                    get {
                        UserDefaults.standard.value(forKey: "name") as? String ?? "Mccc"
                    }
                    set {
                        UserDefaults.standard.setValue(newValue, forKey: "name")
                    }
                }
                var age: Int {
                    get {
                        UserDefaults.standard.value(forKey: "customKey") as? Int ?? 111
                    }
                    set {
                        UserDefaults.standard.setValue(newValue, forKey: "customKey")
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
