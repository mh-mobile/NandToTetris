import Foundation

class PushCommand {
    let segment: SegmentType
    let index: Int

    init(segment: String, index: Int) {
        guard let segment = SegmentType(rawValue: segment) else { fatalError("convert segment error") }
        self.segment = segment
        self.index = index
    }

}

extension PushCommand: Command {

   func convert() -> String {
        let asm: String
        switch segment {
            case .constant:
                asm = """
                      // push constant \(index)
                      @\(index)
                      D=A
                      @SP
                      A=M
                      M=D
                      @SP
                      M=M+1
                      """
            case .pointer:
                asm = "pointer asm"
            case .temp:
                asm = "temp asm"
            case .local:
                asm = "local asm"
            case .argument:
                asm = "argument asm"
            case .this:
                asm = "this asm"
            case .that:
                asm = "that asm"
        }

        return asm
    }

}