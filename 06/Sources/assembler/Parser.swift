import Foundation

enum commandType {
   case A_COMMAND 
   case C_COMMAND
   case L_COMMAND
}

class Parser {

    var commands = [String]()
    var pos = -1

    init(path: String) {
        if let text = try? String(contentsOfFile: path) {
            let array = text.components(separatedBy: "\n")
            for (_, data) in array.enumerated() {
                let componentsByComments = data.components(separatedBy: "//")
                guard componentsByComments.count > 0 else {
                    continue
                }
                let trim = componentsByComments[0].trimmingCharacters(in: .whitespacesAndNewlines)
                if trim == "" {
                    continue
                }
                commands.append(trim)
            }
        } else {
            print("no file path")
        }

    }

    func hasMoreCommands() -> Bool {
        return pos + 1 < commands.count        
    }

    func advance() {
        pos += 1
    }

    func commandType() -> commandType {
        let command = commands[pos]
        let aCommandDatas = command.components(separatedBy: "@")
        if aCommandDatas.count > 1 {
            return .A_COMMAND
        }

        let cCommandDatasForSemi = command.components(separatedBy: ";")
        if cCommandDatasForSemi.count > 1 {
            return .C_COMMAND
        }

        let cCommandDatasForEq = command.components(separatedBy: "=")
        if cCommandDatasForEq.count > 1 {
            return .C_COMMAND
        }

        return .L_COMMAND
    }

    func isLCommandType(symbol: String) -> Bool {
        let charSet = CharacterSet(charactersIn: "()")
        for command in commands {
            let lTypeCommands = command.components(separatedBy: charSet)
            guard lTypeCommands.count > 2 else {
                continue
            } 

            let lTypeCommand = lTypeCommands[1]
            if (lTypeCommand == symbol) {
                return true
            }
        }

        return false
    }

    func symbol() -> String {
        guard self.commandType() == .A_COMMAND || self.commandType() == .L_COMMAND else {
            return ""
        }

        let command = commands[pos]
        if self.commandType() == .A_COMMAND {
            let aTypeCommands = command.components(separatedBy: "@")
            guard aTypeCommands.count > 1 else {
                return ""
            }

            return aTypeCommands[1]
        }

        if self.commandType() == .L_COMMAND {
            let charSet = CharacterSet(charactersIn: "()")
            let lTypeCommands = command.components(separatedBy: charSet)
            guard lTypeCommands.count > 2 else {
                return ""
            }

            return lTypeCommands[1]
        }

        return ""

    }

    func dest() -> String {
        guard self.commandType() == .C_COMMAND else {
            return ""
        }

        let command = commands[pos]
        let cCommandDatasForEq = command.components(separatedBy: "=")
        if cCommandDatasForEq.count > 1 {
            return cCommandDatasForEq[0]
        }

        return ""
    }

    func comp() -> String {
        guard self.commandType() == .C_COMMAND else {
            return ""
        }

        let command = commands[pos]
        let cCommandDatasForSemi = command.components(separatedBy: ";")
        if cCommandDatasForSemi.count > 1 {
            return cCommandDatasForSemi[0]
        } 

        let cCommandDatasForEq = command.components(separatedBy: "=")
        if cCommandDatasForEq.count > 1 {
            return cCommandDatasForEq[1]
        }

        return ""
    }

    func jump() -> String {
        guard self.commandType() == .C_COMMAND else {
            return ""
        }

        let command = commands[pos]
        let cCommandDatasForSemi = command.components(separatedBy: ";")
        if cCommandDatasForSemi.count > 1 {
            return cCommandDatasForSemi[1]
        }
        
        return ""
    }

}