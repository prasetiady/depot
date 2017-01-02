class Order < ApplicationRecord
  enum pay_type: {
    "Check"          => 0,
    "Credit cart"    => 1,
    "Purchase order" => 2
  }
end
