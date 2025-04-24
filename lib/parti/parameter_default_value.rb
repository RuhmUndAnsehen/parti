# frozen_string_literal: true

module Parti
  ##
  # Provides a special value to indicate that a method
  # parameter is required.
  class ParameterDefaultValue; end

  ##
  # Special parameter default value to indicate that it is
  # optional.
  OPT = ParameterDefaultValue.new.freeze
  ##
  # Special parameter default value to indicate that it is
  # required.
  REQ = ParameterDefaultValue.new.freeze
end
