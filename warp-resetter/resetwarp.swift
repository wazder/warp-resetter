import Foundation

/// Displays the main menu to the user
func printMenu() {
    print("\n=== Cloudflare WARP Factory Reset ===")
    print("1) Reset WARP")
    print("q) Quit")
    print("Your choice: ", terminator: "")
}

/// Executes the sequence of commands to reset WARP
func resetWarp() {
    let commands = [
        // Unload the WARP daemon
        "sudo launchctl unload /Library/LaunchDaemons/com.cloudflare.1dot1dot1dot1.macos.warp.daemon.plist",
        // Run the uninstall script
        "sudo /Applications/Cloudflare\\ WARP.app/Contents/Resources/uninstall.sh -f",
        // Remove leftover files and settings
        "sudo rm -rf /Library/Application\\ Support/Cloudflare",
        "rm -rf ~/Library/Logs/Cloudflare",
        "defaults delete com.cloudflare.1dot1dot1dot1 2>/dev/null || true",
        "rm -f ~/Library/LaunchAgents/com.cloudflare.*warp*.plist"
    ]

    for cmd in commands {
        print("→ Executing: \(cmd)")
        let process = Process()
        process.launchPath = "/bin/zsh"
        process.arguments = ["-c", cmd]
        process.launch()
        process.waitUntilExit()
        if process.terminationStatus != 0 {
            print("[!] Error: Command failed – \(cmd)")
            return
        }
    }
    print("✔️ Cloudflare WARP has been successfully reset.")
}

// Main loop
decimalLoop: while true {
    printMenu()
    guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() else {
        continue
    }
    switch input {
    case "1":
        resetWarp()
    case "q", "exit", "quit":
        print("Exiting. Goodbye!")
        break decimalLoop
    default:
        print("Invalid choice. Please enter 1 or q.")
    }
}