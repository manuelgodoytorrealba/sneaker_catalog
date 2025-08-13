require "application_system_test_case"

class SneakersTest < ApplicationSystemTestCase
  setup do
    @sneaker = sneakers(:one)
  end

  test "visiting the index" do
    visit sneakers_url
    assert_selector "h1", text: "Sneakers"
  end

  test "should create sneaker" do
    visit sneakers_url
    click_on "New sneaker"

    fill_in "Brand", with: @sneaker.brand
    fill_in "Colorway", with: @sneaker.colorway
    fill_in "Condition", with: @sneaker.condition
    fill_in "Currency", with: @sneaker.currency
    fill_in "Description", with: @sneaker.description
    fill_in "Model", with: @sneaker.model
    fill_in "Price cents", with: @sneaker.price_cents
    check "Published" if @sneaker.published
    fill_in "Size", with: @sneaker.size
    fill_in "Sku", with: @sneaker.sku
    fill_in "Slug", with: @sneaker.slug
    fill_in "Stock", with: @sneaker.stock
    click_on "Create Sneaker"

    assert_text "Sneaker was successfully created"
    click_on "Back"
  end

  test "should update Sneaker" do
    visit sneaker_url(@sneaker)
    click_on "Edit this sneaker", match: :first

    fill_in "Brand", with: @sneaker.brand
    fill_in "Colorway", with: @sneaker.colorway
    fill_in "Condition", with: @sneaker.condition
    fill_in "Currency", with: @sneaker.currency
    fill_in "Description", with: @sneaker.description
    fill_in "Model", with: @sneaker.model
    fill_in "Price cents", with: @sneaker.price_cents
    check "Published" if @sneaker.published
    fill_in "Size", with: @sneaker.size
    fill_in "Sku", with: @sneaker.sku
    fill_in "Slug", with: @sneaker.slug
    fill_in "Stock", with: @sneaker.stock
    click_on "Update Sneaker"

    assert_text "Sneaker was successfully updated"
    click_on "Back"
  end

  test "should destroy Sneaker" do
    visit sneaker_url(@sneaker)
    accept_confirm { click_on "Destroy this sneaker", match: :first }

    assert_text "Sneaker was successfully destroyed"
  end
end
