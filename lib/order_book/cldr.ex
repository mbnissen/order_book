defmodule OrderBook.Cldr do
  use Cldr,
    locales: [:en, :da],
    providers: [Cldr.Number]
end
