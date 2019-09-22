// LEARNING SWIFT
// Examples taken from
// https://docs.swift.org/swift-book/LanguageGuide/Functions.html

import Cocoa

// =========================================================
// ==========           EXAMPLE 1
// -----> Defining a function
// This function takes one argument type String and
// returns a String value.
func greet(person: String) -> String {
    let greeting = "Hello, " + person + "!"
    return greeting
}

// -----> Calling the function
print(greet(person: "Anna"))


// =========================================================
// ==========           EXAMPLE 2
// -----> Defining a function without parameters
// This function takes NO arguments (parameters) and
// returs a String value.
func sayHelloWorld() -> String {
    return "Hello world"
}

// -----> Calling the function
print(sayHelloWorld())


// =========================================================
// ==========           EXAMPLE 3
// -----> Defining a function witout returning values
func greetAgain(person: String) {
    print("Hello again, \(person)!")
}

// -----> Calling the function
// Observe that since the printing statement is called
// inside the function, there is no need to print again!
greet(person: "John")


// =========================================================
// ==========           EXAMPLE 4
// -----> Call a function, but ignore the returning values
// This is an option to consider when the printing will be
// inside the function (for example), so we are not
// interested in the returning value, just in the process
// performed inside the function.
let _ = greet(person: "Rita")


// =========================================================
// ==========           EXAMPLE 5
// -----> Defining a function
// This function will return two values as a tuple
func minMax(array: [Int]) -> (min: Int, max: Int) {
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count]{
        if value < currentMin{
            currentMin = value
        } else if value > currentMax{
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}

// -----> Calling the function
let bounds = minMax(array: [8, -6, 2, 109, 3, 71])
print("min is \(bounds.min) and max is \(bounds.max)")


// =========================================================
// ==========           EXAMPLE 6
// -----> Definine a function with optional return type
// If the array is empty, there is the possibility to return
// nil to indicate the function could not do its job.
func minMaxWithOptionalValue(array: [Int]) -> (min: Int, max: Int)? {
    if array.isEmpty { return nil}
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count]{
        if value < currentMin{
            currentMin = value
        } else if value > currentMax{
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}


// =========================================================
// ==========           EXAMPLE 7
// -----> Define a function specifying argument labels
func greet2(person: String, from hometown: String) -> String {
    return "Hello \(person)! Glad you could visit from \(hometown)."
}

// -----> Calling the function
// Look how specifiying labels improves readability
print( greet2(person: "Bill", from: "Ottawa"))


// =========================================================
// ==========           EXAMPLE 8
// -----> Defining a function with variadic parameters
// Variadic parameters accept zero or more values of a specified type
// The _ in the parameters means there is no need to specify the label
// when calling the function.
func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}

// -----> Calling the function
print( arithmeticMean(1, 2, 3, 4, 5) )


// =========================================================
// ==========           EXAMPLE 9
// -----> Defining a function with inout parameters
// InOut paramenters let you modify the arguments inside the function
// and keep those changes after the function returns.
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}

// -----> Calling the function
var A : Int = 10
var B : Int = 5
print("Before the function call: A = \(A), B = \(B)")
swapTwoInts(&A, &B)
print("After the function call: A = \(A), B = \(B)")
