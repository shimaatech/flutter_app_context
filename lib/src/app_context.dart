import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'locator/locator.dart';

abstract class AppContext {

  final bool devMode;

  Locator _locator;

  AppContext({this.devMode = false}) {
    _locator = setupLocator();
  }

  @protected
  Locator get locator => _locator;

  List<BeanConfig> get beans => [];

  List<BeanConfig> get devBeans => [];

  List<BeanConfig> get configs => devMode ? beans + devBeans : beans;

  @protected
  Locator setupLocator() {
    return KiwiLocator();
  }


  T locate<T>([String name]) => locator.locate<T>(name);

  Future<void> configure() async {
    await configureInstances();
    for (BeanConfig config in configs) {
      config.configure(locator, overrideOnConflict);
    }
  }

  Future<void> configureInstances() async {}

  @mustCallSuper
  Future<void> clear() async {
    locator.clear();
  }

  bool get overrideOnConflict => true;

}


abstract class BeanConfig<S, T extends S> {
  @protected
  void configure(Locator locator, [bool override=false]) {
    if (override) {
      try {
        locator.unregister<S>();
      } catch (e) {
        // ignore...
      }
    }
    register(locator);
  }

  @protected
  void register(Locator locator);

  T create(Locator locator);
}


abstract class SingletonBeanConfig<S, T extends S> extends BeanConfig<S, T> {
  @override
  @protected
  void register(Locator locator) {
    locator.registerSingleton<S,T>((locator) => create(locator));
  }
}


abstract class FactoryBeanConfig<S, T extends S> extends BeanConfig<S, T> {

  @override
  @protected
  void register(Locator locator) {
    locator.registerFactory<S,T>((locator) => create(locator));
  }

}



class StaticContextHolder {
  static AppContext _context;

  static void setContext(AppContext context) {
    _context = context;
  }

  static T locate<T>([String name]) => _context.locate<T>(name);

  static Future<void> configure() => _context.configure();

  static bool get devMode => _context.devMode;
}



abstract class AppStarter {

  final AppContext appContext;

  AppStarter(this.appContext);

  Future<void> start() async {
    StaticContextHolder.setContext(appContext);
    await _setup();
    runApp(createApp());
  }

  Future<void> _setup() async {
    await StaticContextHolder.configure();
  }

  Widget createApp();

}

