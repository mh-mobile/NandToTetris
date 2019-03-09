import Foundation

class PushCommand {
    let segment: SegmentType
    let index: Int
    let vmFileName: String

    init(segment: String, index: Int, vmFileName: String) {
        guard let segment = SegmentType(rawValue: segment) else { fatalError("convert segment error") }
        self.segment = segment
        self.index = index
        self.vmFileName = vmFileName
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
                guard let pointerType = SegmentPointerType(rawValue: index) else { 
                    fatalError("index fatal error.") 
                }

                asm = """
                      // push pointer \(index)
                      @\(pointerType.symbol)
                      D=M
                      @SP
                      A=M
                      M=D
                      @SP
                      M=M+1
                      """
 
            case .temp:
              asm = """
                     // push temp \(index)
                     @R\(index+5)
                     D=M
                     @SP
                     A=M
                     M=D
                     @SP
                     M=M+1
                     """
  
            case .local, .argument, .this, .that:
               asm = """
                     // push \(segment.rawValue) \(index)
                     @\(index)
                     D=A
                     @\(segment.symbol)
                     A=M
                     A=D+A
                     D=M
                     @SP
                     A=M
                     M=D
                     @SP
                     M=M+1
                     """
            case .`static`:
                asm = """
                      // push static \(index)
                      @\(vmFileName).\(index)
                      D=M
                      @SP
                      A=M
                      M=D
                      @SP
                      M=M+1
                      """
  
        }

        return asm
    }

}