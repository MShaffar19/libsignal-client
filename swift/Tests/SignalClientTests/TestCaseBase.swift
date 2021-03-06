//
// Copyright 2020 Signal Messenger, LLC
// SPDX-License-Identifier: AGPL-3.0-only
//

import SignalClient
import XCTest

#if canImport(CocoaLumberjack)
import CocoaLumberjack
#endif

class TestCaseBase: XCTestCase {
    // Use a static stored property for one-time initialization.
    static let loggingInitialized: Bool = {
#if canImport(CocoaLumberjack)
        DDLog.add(DDOSLogger.sharedInstance)
#else
        signal_init_logger(SignalLogLevel_Trace, .init(
            enabled: { _, _ in true },
            log: { _, level, file, line, message in
                let file = file.map { String(cString: $0) } ?? "<unknown>"
                file.withCString {
                    NSLog("(%u) [%s:%u] %s", level.rawValue, $0, line, message!)
                }
            },
            flush: {}
        ))
#endif
        return true
    }()

    override class func setUp() {
        precondition(loggingInitialized)
    }
}
