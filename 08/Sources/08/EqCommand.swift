class EqCommand {

    let index: Int

    init(index: Int) {
        self.index = index
    }


}

extension EqCommand: Command {

    func convert() -> String {
        let asm: String 
        asm = """
        // eq
        @SP
        AM=M-1
        D=M
        @SP
        AM=M-1
        D=M-D
        @TRUE\(index)
        D;JEQ
        @SP
        A=M
        M=0
        @END\(index)
        0;JMP
        (TRUE\(index))
        @SP
        A=M
        M=-1
        (END\(index))
        @SP
        M=M+1
        """
        return asm
    }

}