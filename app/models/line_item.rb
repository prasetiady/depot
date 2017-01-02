class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  def total_price
    product.price * quantity
  end

  def reduce_quantity
    if quantity > 1
      self.quantity -= 1
      self.save
    else
      self.destroy
    end
  end
end
