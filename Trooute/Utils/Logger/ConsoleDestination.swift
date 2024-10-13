//
//  ConsoleDestination.swift
//  SmartID
//
//  Created by Muhammad Zafar on 2024-09-03.
//

import Foundation
import OSLog

open class ConsoleDestination: BaseDestination {
    public enum LogPrintWay {
        case logger(subsystem: String, category: String)
    }

    public var logPrintWay: LogPrintWay = .logger(subsystem: Bundle.main.bundleIdentifier!, category: "AppUILogs")

    override public var defaultHashValue: Int { return 1 }

    override public init() {
        super.init()
        levelColor.verbose = "✅ "
        levelColor.debug = "🔭 "
        levelColor.info = "ℹ️  "
        levelColor.warning = "⚠️ "
        levelColor.error = "🔴 "
        levelColor.critical = "⛔ "
        levelColor.fault = "🚨 "
    }

    // print to Xcode Console. uses full base class functionality
    override open func send(_ level: Logs.Level, msg: String, thread: String,
                            file: String, function: String, line: Int, context: Any? = nil) -> String? {
        let formattedString = super.send(level, msg: msg, thread: thread, file: file, function: function, line: line, context: context)

        if let message = formattedString {
            switch logPrintWay {
            case let .logger(subsystem, category):
                _logger(message: message, level: level, subsystem: subsystem, category: category)
            }
        }
        return formattedString
    }

    private func _logger(message: String, level: Logs.Level, subsystem: String, category: String) {
        let logger = Logger(subsystem: subsystem, category: category)
        switch level {
        case .verbose:
            logger.trace("\(message)")
        case .debug:
            logger.debug("\(message)")
        case .info:
            logger.info("\(message)")
        case .warning:
            logger.warning("\(message)")
        case .error:
            logger.error("\(message)")
        case .critical:
            logger.critical("\(message)")
        case .fault:
            logger.fault("\(message)")
        }
    }
}
