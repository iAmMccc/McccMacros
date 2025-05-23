import McccMacros
import Foundation


struct Setting {
    
    @UserDefault
    var name: String = "Mccc"

    @UserDefault(forKey: "customKey")
    var age: Int = 111
}




