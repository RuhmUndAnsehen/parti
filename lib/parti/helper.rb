# frozen_string_literal: true

module Parti
  ##
  # Provides a Module refinement providing decorator methods to make methods
  # support the Python way of assigning positional parameters through keyword
  # arguments.
  module Helper
    refine Module do
      def make_method_pythonic(method) # rubocop: disable Metrics/*
        # TODO: remove rubocop magic comment
        # def foo(a, b = nil, *args, c:, d: nil, **kwargs, &block);end
        # method(:foo).parameters
        # => [[:req, :a], [:opt, :b], [:rest, :args],
        #     [:keyreq, :c], [:key, :d], [:keyrest, :kwargs],
        #     [:block, :block]]

        # positional parameters of `method`
        positionals = method.parameters
                            .select { it in [:req | :opt, name] }
        argnames = positionals.map(&:last)

        # parameter lists for the new method signature
        unless positionals.empty?
          kwargs = positionals.map do |required, name|
            "#{name}: Parti::#{required.to_s.upcase}"
          end.join(', ')
        end

        # Parameter handling:
        # - If a parameter equals Parti::REQ, it was not passed to the
        #   method.
        arg_handlers = argnames.map do |name|
          <<~RUBY
            if #{name}.is_a?(Parti::ParameterDefaultValue)
              if !args.empty?
                newargs << args.shift
              elsif #{name} == Parti::REQ
                raise Parti::NArgumentsError,
                      given: newargs.size, expected: #{argnames.size}
              end
            else
              newargs << #{name}
            end
          RUBY
        end

        # override method
        signature = ['*args', kwargs, '**kwargs'].compact.join(', ')
        mod = Module.new do
          module_eval (<<~RUBY.tap { puts it }), __FILE__, __LINE__ + 1
            def #{method.name}(#{signature}, &)
              newargs = []
              #{arg_handlers.join}
              super(*newargs, *args, **kwargs, &)
            end
          RUBY
        end

        prepend mod
      end

      def pythonic_method(name) = make_method_pythonic(method(name))

      def pythonic_instance_method(name)
        make_method_pythonic(instance_method(name))
      end
    end
  end
end
