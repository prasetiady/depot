class Order < ApplicationRecord
  enum pay_tipe: {
    "Check"          => 0,
    "Credit card"    => 1,
    "Purchase order" => 2
  }
end
