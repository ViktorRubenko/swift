import Foundation

struct Stack<Element> {
    private var storage: [Element] = []
}

extension Stack: CustomStringConvertible {
    var description: String {
        return storage.reversed().map({ "\($0)" }).joined(separator: " -> ")
    }
}

extension Stack {
    mutating func push(_ element: Element) {
        storage.append(element)
    }
    
    mutating func pop() -> Element? {
        return storage.popLast()
    }
}

var l = Stack<Int>()
for i in 0...10 {
    l.push(i)
}

print(l)
l.pop()
l.pop()
print(l)
