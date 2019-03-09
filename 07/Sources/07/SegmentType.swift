enum SegmentType: String {

    var symbol: String {
        switch self {
            case .constant:
                return ""
            case .pointer:
                return ""
            case .temp:
                return ""
            case .local:
                return "LCL"
            case .argument:
                return "ARG"
            case .this:
                return "THIS"
            case .that:
                return "THAT"
            case .`static`:
                return ""
        }
    }

    case constant
    case pointer
    case temp
    case local
    case argument
    case this
    case that
    case `static`
}

enum SegmentPointerType: Int {
    var symbol: String {
        switch self {
            case .this:
                return SegmentType.this.symbol
            case .that:
                return SegmentType.that.symbol
        }
    }

    case this 
    case that
}