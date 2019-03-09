class AddCommand {

    init() {

    }

}

extension AddCommand: Command {

    func convert() -> String {
        let asm: String 
        asm = "add asm."
        return asm
    }

}