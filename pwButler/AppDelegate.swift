//
//  AppDelegate.swift
//  pwButler
//
//  Created by White on 2017/9/11.
//  Copyright © 2017年 White. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var blurView: UIVisualEffectView? = {
        let bV = UIVisualEffectView(frame: self.window!.bounds)
        bV.effect = UIBlurEffect(style: UIBlurEffectStyle.light)
        return bV
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let nav = UINavigationController.init(rootViewController: MainViewController())
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        if let blurView = self.blurView {
            self.window?.addSubview(blurView)
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        self.blurView?.removeFromSuperview()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

