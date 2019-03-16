class GtCommand {

    let index: Int
    let functionName: String?

    init(index: Int, functionName: String?) {
        self.index = index
        self.functionName = functionName
    }


}

extension GtCommand: Command {

    func convert() -> String {
        var convertedName: (String) -> String = { label in
            if let functionName = self.functionName {
                return "\(functionName)$\(label)"
            } else {
                return label
            }
        }

        let trueIndex = convertedName("TRUE\(index)")
        let endIndex = convertedName("END\(index)")

        let asm: String 
        asm = """
        // eq
        @SP
        AM=M-1
        D=M
        @SP
        AM=M-1
        D=M-D
        @\(trueIndex)
        D;JGT
        @SP
        A=M
        M=0
        @\(endIndex)
        0;JMP
        (\(trueIndex))
        @SP
        A=M
        M=-1
        (\(endIndex))
        @SP
        M=M+1
        """
        return asm
    }

}