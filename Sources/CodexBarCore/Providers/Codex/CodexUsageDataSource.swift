import Foundation

public enum CodexUsageDataSource: String, CaseIterable, Identifiable, Sendable {
    case auto
    case oauth
    case cli

    public var id: String {
        self.rawValue
    }

    public var displayName: String {
        switch self {
        case .auto: "Auto"
        case .oauth: "HTTP API"
        case .cli: "CLI (RPC/PTY)"
        }
    }

    public var sourceLabel: String {
        switch self {
        case .auto:
            "auto"
        case .oauth:
            "http"
        case .cli:
            "cli"
        }
    }
}
