String orderSqlEnum(Enum value) => value.name.replaceAllMapped(
  RegExp('[A-Z]'),
  (m) => '_${m[0]!.toLowerCase()}',
);
