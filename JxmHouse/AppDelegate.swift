//
//  AppDelegate.swift
//  JxmHouse
//
//  Created by XFXB on 17/5/17.
//  Copyright © 2017年 tcjxm6. All rights reserved.
//

import UIKit
import Alamofire
import UserNotificationsUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let vc = JxmHouseViewController()
        let nvc = UINavigationController.init(rootViewController: vc)
        self.window = UIWindow()
        self.window?.frame = UIScreen.main.bounds
        self.window?.rootViewController = nvc
        self.window?.makeKeyAndVisible()
        
        JPUSHService.register(forRemoteNotificationTypes: (UIUserNotificationType.badge.union(UIUserNotificationType.sound).union(UIUserNotificationType.alert)).rawValue, categories:nil)
        
        JPUSHService.setup(withOption: launchOptions, appKey:"42df7bcc3fdb7d647387efda", channel:"", apsForProduction:true)
        
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
        application.applicationIconBadgeNumber=0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application:UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken:Data) {
        
        JPUSHService.registerDeviceToken(deviceToken)
    
    }
    
    private func application(application:UIApplication, didReceiveRemoteNotification userInfo: [NSObject:AnyObject]) {
    
        print("接到通知")
    
        JPUSHService.handleRemoteNotification(userInfo)
    
        application.applicationIconBadgeNumber=0
    
        JPUSHService.resetBadge()
    
        if(application.applicationState == .active) {

            let alertView = UIAlertView(title: "消息", message: "您有一条新的消息", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "查看")
        
            alertView.show()
        
        }else{
            application.applicationIconBadgeNumber=0
        }
    
    }

}

