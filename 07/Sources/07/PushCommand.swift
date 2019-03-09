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
                asm = """
                      // push pointer \(index)
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
            case .s_static:
                asm = """
                      // push static \(index)
                      """
  
        }

        return asm
    }

}