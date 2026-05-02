import Foundation

public enum CLIProbeSessionResetter {
    public static func resetAll() async {
        await CodexCLISession.shared.reset()
    }
}
