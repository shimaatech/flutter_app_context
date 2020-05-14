typedef T Factory<T>(Locator locator);

abstract class Locator {
  void registerInstance<S, T extends S>(
    S instance, {
    String name,
  });

  void registerFactory<S, T extends S>(
    Factory<S> factory, {
    String name,
  });

  void registerSingleton<S, T extends S>(
    Factory<S> factory, {
    String name,
  });

  void unregister<T>([String name]);

  T locate<T>([String name]);

  void clear();
}


