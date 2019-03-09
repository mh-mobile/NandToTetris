class NotCommand {

    init() {

    }

}

extension NotCommand: Command {

    func convert() -> String {
        let asm: String 
        asm = """
        // not
        @SP
        AM=M-1
        M=!M
        @SP
        M=M+1
        """
        return asm
    }

}