//
//  AppDelegate.swift
//  KeyType
//
//  MIT License
//  Copyright (c) 2016 potsbo
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))

    func applicationDidFinishLaunching(_: Notification) {
        let menu = NSMenu()
        statusItem.title = "⌘"
        statusItem.highlightMode = true
        statusItem.menu = menu

        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        menu.addItem(withTitle: "About KeyType \(String(describing: version))", action: nil, keyEquivalent: "")
        menu.addItem(withTitle: "Quit", action: #selector(AppDelegate.quit(_:)), keyEquivalent: "")
        _ = KeyEventController()
    }

    func applicationWillTerminate(_: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func quit(_: NSButton) {
        NSApplication.shared.terminate(self)
    }
}
