import McccMacros
import Foundation

let a = 17
let b = 25

let (result, code) = #stringify(a + b)

print("The value \(result) was produced by the code \"\(code)\"")


struct Setting {
    
    @UserDefault
    var name: String = "Mccc"

    @UserDefault(forKey: "mcccc")
    var age: Int = 111
    
    @UserDefault
    var dict: [String: Any] = [:]
}
