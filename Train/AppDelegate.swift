//
//  AppDelegate.swift
//  Train
//
//  Created by 张昭 on 05/01/2017.
//  Copyright © 2017 Jmsp. All rights reserved.
//

import UIKit
import XCGLogger
import SVProgressHUD

var APP_LOG_PATH = ""
var APP_LOG_DIRECTORY = ""
let kScreenWidth: CGFloat = UIScreen.main.bounds.width
let kScreenHeight: CGFloat = UIScreen.main.bounds.height

let logger: XCGLogger = {
    
    let log = XCGLogger.default
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMddhhmm"
    let dateStr = dateFormatter.string(from: Date())
    
    let bundleId = Bundle.main.bundleIdentifier!
    let fileName = "\(bundleId).\(dateStr).txt"
    
    APP_LOG_DIRECTORY = "\(NSHomeDirectory())/Library/Logs/\(bundleId)/"
    APP_LOG_PATH = "\(APP_LOG_DIRECTORY)/\(fileName)"
    print(APP_LOG_PATH)
    
    let isExistDirectory:Bool = FileManager.default.fileExists(atPath: APP_LOG_DIRECTORY, isDirectory: nil)
    if !isExistDirectory {
        do{
            try FileManager.default.createDirectory(atPath: APP_LOG_DIRECTORY, withIntermediateDirectories: true, attributes: nil)
        }
        catch {
            print("createDirectoryAtPath fail,can't log")
        }
    }
    
    log.setup(level: .debug, showThreadName: false, showLevel: true, showFileNames: false, showLineNumbers: false, writeToFile: APP_LOG_PATH as AnyObject?)

    return log
}()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        SVProgressHUD.setMinimumDismissTimeInterval(2.0)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

