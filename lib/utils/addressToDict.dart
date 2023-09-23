Map addressToDict(List addr) {
  Map city = {};
  Map state = {};
  Map country = {};

  for (var line in addr) {
    print(line);
    country.update(
        line.country,
        (value) => ++value,
        ifAbsent: () => 1,
      );
      state.update(
        line.administrativeArea,
        (value) => ++value,
        ifAbsent: () => 1,
      );
      city.update(
        line.locality,
        (value) => ++value,
        ifAbsent: () => 1,
      );
  }
  return {
    'city': getMaxOccured(city),
    'state': getMaxOccured(state),
    'country': getMaxOccured(country)
  };
}

getMaxOccured(Map m) {
  List list = [];
  m.forEach((k, v) => list.add([k, v]));
  List s = list..sort((k, v) => v[1].compareTo(k[1]));
  return s[0][0];
}
