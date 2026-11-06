# frozen_string_literal: true

class Service < ApplicationRecord
  CURRENCY = "USD"
  CURRENCY_SYMBOL = "$"

  scope :active, -> { where(active: true) }

  validates :name, presence: true
  validates :duration_minutes, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price_cents, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :active, inclusion: { in: [ true, false ] }

  # Human-readable attribute name for error messages
  def self.human_attribute_name(attribute_key_name, options = {})
    if attribute_key_name.to_s == "price_cents"
      "Price"
    else
      super
    end
  end

  # Returns price in decimal format (e.g. 25.00)
  def price
    return nil if price_cents.nil?

    price_cents / 100.0
  end

  # Accepts price as decimal/string/number and stores in integer cents
  def price=(val)
    if val.blank?
      self.price_cents = nil
    elsif val.is_a?(Numeric)
      self.price_cents = (val * 100).round
    else
      cleaned = val.to_s.tr(CURRENCY_SYMBOL, "").strip
      self.price_cents = (BigDecimal(cleaned) * 100).round
    end
  rescue ArgumentError
    self.price_cents = nil
  end

  def formatted_price
    return "" if price_cents.nil?

    format("%.2f", price)
  end

  def display_price
    return "" if price_cents.nil?

    "#{CURRENCY_SYMBOL}#{formatted_price}"
  end
end
