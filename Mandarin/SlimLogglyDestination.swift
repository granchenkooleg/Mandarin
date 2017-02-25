//
// Created by Mats Melke on 12/02/15.
// Copyright (c) 2015 Baresi. All rights reserved.
//

import Foundation
import UIKit

private let logglyQueue: DispatchQueue = DispatchQueue(
	label: "slimlogger.loggly", attributes: [])

class SlimLogglyDestination: LogDestination {

    var userid:String?
    fileprivate var buffer:[String] = [String]()
    fileprivate var backgroundTaskIdentifier: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    fileprivate var standardFields: [AnyHashable: Any] = [
        "lang": Locale.preferredLanguages[0],
        "appname": Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "",
        "appversion": Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "",
        "devicename": UIDevice.current.name,
        "devicemodel": UIDevice.current.model,
        "osversion": UIDevice.current.systemVersion
    ]

    fileprivate var observer: NSObjectProtocol?

    init() {
        observer = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "UIApplicationWillResignActiveNotification"), object: nil, queue: nil, using: {
            [unowned self] note in
            let tmpbuffer = self.buffer
            self.buffer = [String]()
            self.backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(withName: "saveLogRecords",
                expirationHandler: {
                    self.endBackgroundTask()
                })
            self.sendLogsInBuffer(tmpbuffer)
        })
    }

    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    fileprivate func toJson(_ dictionary: NSDictionary) -> Data? {

        var err: NSError?
        do {
            let json = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions(rawValue: 0))
            return json
        } catch let error1 as NSError {
            err = error1
            let error = err?.description ?? "nil"
            NSLog("ERROR: Unable to serialize json, error: %@", error)
            return nil
        }
    }

    fileprivate func toJsonString(_ data: Data) -> String {
        if let jsonstring = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
            return jsonstring as String
        } else {
            return ""
        }
    }


    func log<T>(_ message:@autoclosure () -> T, level:LogLevel, filename:String, line:Int) {
        if level.rawValue < SlimLogglyConfig.logglyLogLevel.rawValue {
            // don't log
            return
        }

        var jsonstr = ""
        let mutableDict = NSMutableDictionary(dictionary: standardFields)
        if let msgdict = message() as? [AnyHashable: Any] {
            mutableDict.addEntries(from: msgdict)
        } else {
            mutableDict.setObject("\(message())", forKey: "rawmsg" as NSCopying)
        }
        mutableDict.setObject(level.string, forKey: "level" as NSCopying)
        mutableDict.setObject(Date().timeIntervalSince1970, forKey: "timestamp" as NSCopying)
        mutableDict.setObject("\(filename):\(line)", forKey: "sourcelocation" as NSCopying)
//        mutableDict.setObject(User.uuid(), forKey: "userid")
        mutableDict.setObject(UIApplication.shared.applicationState.displayName(), forKey: "app_state" as NSCopying)
        mutableDict.setObject(BaseViewController.lastAppearedScreenName ?? "", forKey: "last_visited_screen" as NSCopying)

        if let jsondata = toJson(mutableDict) {
            jsonstr = toJsonString(jsondata)
        }
        addLogMsgToBuffer(jsonstr)
    }

    fileprivate func addLogMsgToBuffer(_ msg:String) {
        logglyQueue.async {
            self.buffer.append(msg)
            if self.buffer.count > SlimLogglyConfig.maxEntriesInBuffer {
                let tmpbuffer = self.buffer
                self.buffer = [String]()
                self.sendLogsInBuffer(tmpbuffer)
            }
        }
    }

    fileprivate func sendLogsInBuffer(_ stringbuffer:[String]) {
        let allMessagesString = stringbuffer.joined(separator: "\n")
        self.traceMessage("LOGGLY: will try to post \(allMessagesString)")
        if let allMessagesData = (allMessagesString as NSString).data(using: String.Encoding.utf8.rawValue) {
            var urlRequest = URLRequest(url: URL(string: SlimLogglyConfig.logglyUrlString)!)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = allMessagesData
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest, completionHandler: {(responsedata, response, error) in
                if let anError = error {
                    self.traceMessage("Error from Loggly: \(anError)")
                } else if let data = responsedata {
                    self.traceMessage("Posted to Loggly, status = \(NSString(data: data, encoding:String.Encoding.utf8.rawValue))")
                } else {
                    self.traceMessage("Neither error nor responsedata, something's wrong")
                }
                if self.backgroundTaskIdentifier != UIBackgroundTaskInvalid {
                    self.endBackgroundTask()
                }
            }) 
            task.resume()
        }
    }

    fileprivate func endBackgroundTask() {
        if self.backgroundTaskIdentifier != UIBackgroundTaskInvalid {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier)
            self.backgroundTaskIdentifier = UIBackgroundTaskInvalid
            print("Ending background task")
        }
    }

    fileprivate func traceMessage(_ msg:String) {
        if SlimConfig.enableConsoleLogging && SlimLogglyConfig.logglyLogLevel == LogLevel.trace {
            print(msg)
        }
    }
}

