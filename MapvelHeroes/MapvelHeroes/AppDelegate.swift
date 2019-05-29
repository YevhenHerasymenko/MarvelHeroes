//
//  AppDelegate.swift
//  MapvelHeroes
//
//  Created by YevhenHerasymenko on 5/28/19.
//  Copyright © 2019 YevhenHerasymenko. All rights reserved.
//

import UIKit
import MarvelHeroesCore

var mainStore: Store<AppState>! {
  return (UIApplication.shared.delegate as? AppDelegate)?.store
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  private(set) var store: Store<AppState>!
  private var sessionManager: NetworkSessionManager!
  private var persistentContainer: PersistentManager!

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    setupCore()
    return true
  }

  private func setupCore() {
    sessionManager = SessionManager()
    persistentContainer = createAndSetupCoreDataPersistenceStack()
    store = createStore(sessionManager, persistentContainer)
  }

  func applicationWillTerminate(_ application: UIApplication) {
    store.dispatch(AppState.clearData())
  }

}

