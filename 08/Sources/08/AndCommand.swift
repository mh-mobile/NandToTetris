class AndCommand {

    init() {

    }

}

extension AndCommand: Command {

    func convert() -> String {
        let asm: String 
        asm = """
        // and
        @SP
        AM=M-1
        D=M
        @SP
        AM=M-1
        M=D&M
        @SP
        M=M+1
        """
        return asm
    }

}