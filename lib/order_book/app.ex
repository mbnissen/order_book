defmodule OrderBook.App do
  use Commanded.Application, otp_app: :order_book

  router(OrderBook.Router)
end
