class NegCommand {

    init() {

    }

}

extension NegCommand: Command {

    func convert() -> String {
        let asm: String 
        asm = """
        // neg
        @SP
        AM=M-1
        M=-M
        @SP
        M=M+1
        """
        return asm
    }

}