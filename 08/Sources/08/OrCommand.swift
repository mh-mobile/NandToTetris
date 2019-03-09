class OrCommand {

    init() {

    }

}

extension OrCommand: Command {

    func convert() -> String {
        let asm: String 
        asm = """
        // or
        @SP
        AM=M-1
        D=M
        @SP
        AM=M-1
        M=D|M
        @SP
        M=M+1
        """
        return asm
    }

}