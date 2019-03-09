class PopCommand {
    let segment: SegmentType
    let index: Int

    init(segment: String, index: Int) {
        guard let segment = SegmentType(rawValue: segment) else { fatalError("convert segment error") }
        self.segment = segment
        self.index = index
    }

}

extension PopCommand: Command {

    func convert() -> String {
                let asm: String
        switch segment {
            case .constant:
                fatalError("no segment for pop")
            case .pointer:
              asm = """
                     // push pointer \(index)
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
            case .s_static:
                asm = """
                     // push static \(index)
                """
        }

        return asm
    }

}