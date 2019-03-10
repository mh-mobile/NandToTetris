import Foundation

class GotoCommand {
    let label: String

    init(label: String) {
        self.label = label
    }

}

extension GotoCommand: Command {

    func convert() -> String {
        let asm = """
                  // goto
                  @\(label)
                  0;JMP
                  """
        return asm
    }

}