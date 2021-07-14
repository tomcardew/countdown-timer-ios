import Foundation

extension String {
    
    func padding(leftTo paddedLength: Int, withPad pad: String = " ", startingAt padStart: Int = 0) -> String{
        if count < paddedLength {
            let rightPadded = padding(toLength: max(count, paddedLength), withPad: pad, startingAt: padStart)
            return "".padding(toLength: paddedLength, withPad: rightPadded, startingAt: count % paddedLength)
        } else {
            return self
        }
    }
    
    func padding(rightTo paddedLength: Int, withPad pad: String = " ", startingAt padStart: Int = 0) -> String{
        if count < paddedLength {
            return padding(toLength: paddedLength, withPad: pad, startingAt: padStart)
        } else {
            return self
        }
    }
    
    func padding(sidesTo paddedLength: Int, withPad pad: String = " ", startingAt padStart: Int = 0) -> String {
        if count < paddedLength {
            let rightPadded = padding(toLength: max(count, paddedLength), withPad: pad, startingAt: padStart)
            return "".padding(toLength: paddedLength, withPad: rightPadded, startingAt: (paddedLength + count) / 2 % paddedLength)
        } else {
            return self
        }
    }
}
