# frozen_string_literal: true

module Parti
  ##
  # Raised when a method created by Parti was called with the same parameter
  # assigned twice (as both positional and keyword argument).
  class AssignedTwiceError < ArgumentError
    def initialize(message = nil, name: nil, values: nil)
      unless message
        name &&= "`#{name}`"
        values &&= "(#{values.join(", ")})"
        message =
          ['parameter', name, 'assigned twice', values].compact.join(' ')
      end
      super(message)
    end
  end
end
