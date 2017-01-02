require 'test_helper'

class OrderMailerTest < ActionMailer::TestCase
  test "received" do
    mail = OrderMailer.received(orders(:one))
    assert_equal "Depot Order Confirmation", mail.subject
    assert_equal ["dedy.berastagi@gmail.com"], mail.to
    assert_equal ["from@example.com"], mail.from
  end

  test "shipped" do
    mail = OrderMailer.shipped(orders(:one))
    assert_equal "Depot Order Shipped", mail.subject
    assert_equal ["dedy.berastagi@gmail.com"], mail.to
    assert_equal ["from@example.com"], mail.from
  end

end
