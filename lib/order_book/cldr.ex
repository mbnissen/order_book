defmodule OrderBook.Cldr do
  use Cldr,
    locales: [:en, :da],
    default_locale: :da,
    providers: [Cldr.Number]
end
