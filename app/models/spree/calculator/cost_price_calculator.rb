module Spree
  class Calculator::CostPriceCalculator < Calculator
    def self.description
      "Cost Price Calculator"
    end

    def compute(object=nil)
      # Returns the value after performing the required calculation
      object.price - object.product.cost_price rescue 0
    end
  end
end
