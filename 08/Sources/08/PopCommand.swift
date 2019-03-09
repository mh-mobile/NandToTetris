class PopCommand {
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

extension PopCommand: Command {

    func convert() -> String {
                let asm: String
        switch segment {
            case .constant:
                fatalError("no segment for pop")
            case .pointer:
               guard let pointerType = SegmentPointerType(rawValue: index) else { 
                    fatalError("index fatal error.") 
                }

                asm = """
                      // pop pointer \(index)
                      @SP
                      AM=M-1
                      D=M
                      @\(pointerType.symbol)
                      M=D
                      """
            case .temp:
              asm = """
                     // push temp \(index)
                     @R\(index+5)
                     D=A
                     @R13
                     M=D
                     @SP
                     AM=M-1
                     D=M
                     @R13
                     A=M
                     M=D
                     """
            case .argument, .this, .that, .local:
               asm = """
                     // pop \(segment.rawValue) \(index)
                     @\(index)
                     D=A
                     @\(segment.symbol)
                     D=M+D
                     @R13
                     M=D
                     @SP
                     AM=M-1
                     D=M
                     @R13
                     A=M
                     M=D
                     """
            case .`static`:
                asm = """
                      // push static \(index)
                      @SP
                      AM=M-1
                      D=M
                      @\(vmFileName).\(index)
                      M=D
                      """
        }

        return asm
    }

}