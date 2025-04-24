# frozen_string_literal: true

require 'parti'

RSpec.describe Parti::Helper do
  using Parti::Helper

  let(:klass) do
    Class.new do
      def test(foo, bar) = "#{foo} #{bar}"
      pythonic_instance_method(:test)
    end
  end
  let(:object) { klass.new }

  it 'should not raise when invoked within spec' do
    expect { object.test(1, 2) }.to_not raise_error
    expect { object.test(foo: 1, bar: 2) }.to_not raise_error
    expect { object.test(1, bar: 2) }.to_not raise_error
    expect { object.test(1, foo: 2) }.to_not raise_error
  end

  it 'should reject incorrect usage' do
    expect { object.test(1, 2, 3) }.to raise_error(ArgumentError)
    expect { object.test(1, 2, foo: 3) }.to raise_error(ArgumentError)
    expect { object.test(1, bar: 2, foo: 3) }.to raise_error(ArgumentError)
    expect { object.test(1, baz: 4) }.to raise_error(ArgumentError)
  end

  it 'should pass parameters in correct order' do
    expect(object.test(1, 2)).to eq('1 2')
    expect(object.test(foo: 1, bar: 2)).to eq('1 2')
    expect(object.test(bar: 1, foo: 2)).to eq('2 1')
    expect(object.test(1, bar: 2)).to eq('1 2')
    expect(object.test(1, foo: 2)).to eq('2 1')
  end

  context 'with splats, blocks and keyword arguments' do
    let(:klass) do
      Class.new do
        def test(foo, bar, *args, baz:, **kwargs)
          yield [foo, bar, baz, *args, **kwargs]
        end
        pythonic_instance_method(:test)
      end
    end

    it 'should pass parameters in correct order' do
      expect(object.test(1, 2, 3, 4, baz: 42, bat: 1138, bay: 35, &:join))
        .to eq('124234{bat: 1138, bay: 35}')
      expect(object.test(3, 4, bat: 1138, foo: 1, baz: 42, bar: 2, bay: 35,
                         &:join))
        .to eq('124234{bat: 1138, bay: 35}')
      expect(object.test(1, 3, 4, bat: 1138, baz: 42, bar: 2, bay: 35, &:join))
        .to eq('124234{bat: 1138, bay: 35}')
    end
  end
end
