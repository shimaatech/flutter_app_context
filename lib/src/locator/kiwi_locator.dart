import 'package:kiwi/kiwi.dart' as kiwi;
import 'locator.dart';

class KiwiLocator implements Locator {

  static KiwiLocator _instance = KiwiLocator._internal();

  KiwiLocator._internal();

  factory KiwiLocator() {
    return _instance;
  }


  final kiwi.Container kiwiLocator = kiwi.Container();

  @override
  void clear() {
    kiwiLocator.clear();
  }

  @override
  T locate<T>([String name]) {
    return kiwiLocator.resolve<T>(name);
  }

  @override
  void registerFactory<S, T extends S>(Factory<S> factory, {String name}) {
    return kiwiLocator.registerFactory<S, T>(
        locatorFactoryToKiwiFactory(factory),
        name: name);
  }

  @override
  void registerInstance<S, T extends S>(S instance, {String name}) {
    return kiwiLocator.registerInstance<S, T>(instance, name: name);
  }

  @override
  void registerSingleton<S, T extends S>(Factory<S> factory, {String name}) {
    return kiwiLocator.registerSingleton<S, T>(locatorFactoryToKiwiFactory(factory),
        name: name);
  }

  @override
  void unregister<T>([String name]) {
    return kiwiLocator.unregister<T>(name);
  }

  kiwi.Factory<S> locatorFactoryToKiwiFactory<S>(Factory<S> factory) {
    return (kiwiContainer) => factory(this);
  }
}
