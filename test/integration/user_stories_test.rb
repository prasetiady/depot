require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products
  include ActiveJob::TestHelper

  # A user goes to index page. They select a product, adding it to their
  # cart, and check out, filling in their details on the checkout form. When
  # they submit, an order is created containing their information, along with
  # a single line item corresponding to the product they added to their cart.

  test "buying a product" do
    start_order_count = Order.count
    ruby_book = products(:ruby)

    # goes to index page
    get "/"
    assert_response :success
    assert_select 'h1', 'Depot Catalog'

    # select a product and adding it to cart
    post '/line_items', params: { product_id: ruby_book.id }, xhr: true
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product

    # check out
    get "/orders/new"
    assert_response :success
    assert_select 'legend', 'Please Enter Your Details'

    # filling details and submit checkout form
    perform_enqueued_jobs do
      post "/orders", params: {
        order: {
          name:     "Dedy Prasetiady",
          address:  "Berastagi",
          email:    "dedy.berastagi@gmail.com",
          pay_type: "Check"
        }
      }

      follow_redirect!

      assert_response :success
      assert_select 'h1', 'Depot Catalog'
      cart = Cart.find(session[:cart_id])
      assert_equal 0, cart.line_items.size

      # checking database
      assert_equal start_order_count + 1, Order.count
      order = Order.last

      assert_equal "Dedy Prasetiady", order.name
      assert_equal "Berastagi", order.address
      assert_equal "dedy.berastagi@gmail.com", order.email
      assert_equal "Check", order.pay_type

      assert_equal 1, order.line_items.size
      line_item = order.line_items[0]
      assert_equal ruby_book, line_item.product

      # checking mailer
      mail = ActionMailer::Base.deliveries.last
      assert_equal ["dedy.berastagi@gmail.com"], mail.to
      assert_equal 'Prasetiady <prasetiady22@gmail.com>', mail[:from].value
      assert_equal 'Depot Order Confirmation', mail.subject
    end
  end
end
