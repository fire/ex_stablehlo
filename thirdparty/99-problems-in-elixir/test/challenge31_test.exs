defmodule Challenge31Test do
  use ExUnit.Case

  test "is_prime" do
    assert Challenge31.is_prime(1) == false
    assert Challenge31.is_prime(2) == true
    assert Challenge31.is_prime(3) == true
    assert Challenge31.is_prime(4) == false
    assert Challenge31.is_prime(5) == true
    assert Challenge31.is_prime(6) == false
    assert Challenge31.is_prime(7) == true
    assert Challenge31.is_prime(8) == false
    assert Challenge31.is_prime(9) == false
    assert Challenge31.is_prime(10) == false
    assert Challenge31.is_prime(25) == false
    assert Challenge31.is_prime(7919) == true
  end

  test "is_prime_another_impl" do
    assert Challenge31.is_prime_another_impl(1) == false
    assert Challenge31.is_prime_another_impl(2) == true
    assert Challenge31.is_prime_another_impl(3) == true
    assert Challenge31.is_prime_another_impl(4) == false
    assert Challenge31.is_prime_another_impl(5) == true
    assert Challenge31.is_prime_another_impl(6) == false
    assert Challenge31.is_prime_another_impl(7) == true
    assert Challenge31.is_prime_another_impl(8) == false
    assert Challenge31.is_prime_another_impl(9) == false
    assert Challenge31.is_prime_another_impl(10) == false
    assert Challenge31.is_prime_another_impl(25) == false
    assert Challenge31.is_prime_another_impl(7919) == true
  end

  test "is_prime_one_more_impl" do
    assert Challenge31.is_prime_one_more_impl(1) == false
    assert Challenge31.is_prime_one_more_impl(2) == true
    assert Challenge31.is_prime_one_more_impl(3) == true
    assert Challenge31.is_prime_one_more_impl(4) == false
    assert Challenge31.is_prime_one_more_impl(5) == true
    assert Challenge31.is_prime_one_more_impl(6) == false
    assert Challenge31.is_prime_one_more_impl(7) == true
    assert Challenge31.is_prime_one_more_impl(8) == false
    assert Challenge31.is_prime_one_more_impl(9) == false
    assert Challenge31.is_prime_one_more_impl(10) == false
    assert Challenge31.is_prime_one_more_impl(25) == false
    assert Challenge31.is_prime_one_more_impl(7919) == true
  end
end
