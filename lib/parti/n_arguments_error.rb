# frozen_string_literal: true

module Parti
  ##
  # Raised when a method created by Parti received an incorrect number of
  # arguments.
  #
  # More precisely, a required parameter was not passed.
  class NArgumentsError < ArgumentError
    def initialize(message = nil, given: nil, expected: nil)
      unless message
        given &&= "given #{given}"
        expected &&= "expected #{expected}"

        if given || expected
          explanation = "(#{[given, expected].compact.join(", ")})"
        end

        message = ['wrong number of arguments', explanation].compact.join(' ')
      end
      super(message)
    end
  end
end
