// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that produces both a value and a string containing the
/// source code that generated the value. For example,
///
///     #stringify(x + y)
///
/// produces a tuple `(x + y, "x + y")`.
@freestanding(expression)
public macro stringify<T>(_ value: T) -> (T, String) = #externalMacro(module: "McccMacrosMacros", type: "StringifyMacro")




/// 给属性添加set和get方法，并将值存储到UserDefault
//@attached(accessor, names: arbitrary)
//public macro UserDefault() = #externalMacro(module: "McccMacrosMacros", type: "UserDefaultMacro")

@attached(accessor, names: arbitrary)
public macro UserDefault(forKey key: String? = nil) = #externalMacro(module: "McccMacrosMacros", type: "UserDefaultMacro")
