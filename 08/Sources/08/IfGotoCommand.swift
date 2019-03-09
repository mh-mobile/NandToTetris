import Foundation

class IfGotoCommand {
    let label: String

    init(label: String) {
        self.label = label
    }

}

extension IfGotoCommand: Command {

    func convert() -> String {
        let asm = """
                  // if-goto
                  @SP
                  AM=M-1
                  D=M
                  @\(label)
                  D;JGT
                  """
        return asm
    }

}