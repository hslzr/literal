# frozen_string_literal: true

require "forwardable"

class Literal::Array
	class Generic
		include Literal::Type

		def initialize(type)
			@type = type
		end

		attr_reader :type

		def new(*value)
			Literal::Array.new(value, type: @type)
		end

		alias_method :[], :new

		def ===(value)
			Literal::Array === value && Literal.subtype?(value.__type__, of: @type)
		end

		def <=>(other)
			case other
			when Literal::Array::Generic
				@type <=> other.type
			else
				-1
			end
		end

		def inspect
			"Literal::Array(#{@type.inspect})"
		end
	end

	include Enumerable
	extend Forwardable

	def initialize(value, type:)
		collection_type = Literal::Types::ArrayType.new(type)

		Literal.check(actual: value, expected: collection_type) do |c|
			c.fill_receiver(receiver: self, method: "#initialize")
		end

		@__type__ = type
		@__value__ = value
		@__collection_type__ = collection_type
	end

	def __initialize_without_check__(value, type:, collection_type:)
		@__type__ = type
		@__value__ = value
		@__collection_type__ = collection_type
		self
	end

	# Used to create a new Literal::Array with the same type and collection type but a new value. The value is not checked.
	def __with__(value)
		Literal::Array.allocate.__initialize_without_check__(
			value,
			type: @__type__,
			collection_type: @__collection_type__
		)
	end

	attr_reader :__type__, :__value__

	def_delegators :@__value__,
		:all?,
		:any?,
		:at,
		:bsearch,
		:clear,
		:count,
		:each,
		:empty?,
		:filter!,
		:first,
		:last,
		:length,
		:one?,
		:pop,
		:sample,
		:shift,
		:size,
		:sort!

	def &(other)
		case other
		when ::Array
			__with__(@__value__ & other)
		when Literal::Array
			__with__(@__value__ & other.__value__)
		else
			raise ArgumentError.new("Cannot perform bitwise AND with #{other.class.name}.")
		end
	end

	def <<(value)
		Literal.check(actual: value, expected: @__type__) do |c|
			c.fill_receiver(receiver: self, method: "#<<")
		end

		@__value__ << value
		self
	end

	def [](index)
		@__value__[index]
	end

	def []=(index, value)
		Literal.check(actual: value, expected: @__type__) do |c|
			c.fill_receiver(receiver: self, method: "#[]=")
		end

		@__value__[index] = value
	end

	def filter(...)
		__with__(@__value__.filter(...))
	end

	def freeze
		@__value__.freeze
		super
	end

	def map(type, &block)
		my_type = @__type__
		transform_type = Literal::TRANSFORMS.dig(my_type, block)

		if transform_type && Literal.subtype?(transform_type, of: my_type)
			Literal::Array.allocate.__initialize_without_check__(
				@__value__.map(&block),
				type:,
				collection_type: Literal::Types::ArrayType.new(type),
			)
		else
			Literal::Array.new(@__value__.map(&block), type:)
		end
	end

	def max(n = nil, &)
		if n
			__with__(@__value__.max(n, &))
		else
			@__value__.max(&)
		end
	end

	def min(n = nil, &)
		if n
			__with__(@__value__.min(n, &))
		else
			@__value__.min(&)
		end
	end

	def minmax(...)
		__with__(@__value__.minmax(...))
	end

	def push(*value)
		Literal.check(actual: value, expected: @__collection_type__) do |c|
			c.fill_receiver(receiver: self, method: "#push")
		end

		@__value__.push(*value)
		self
	end

	alias_method :append, :push

	def reject(...)
		__with__(@__value__.reject(...))
	end

	def reject!(...)
		@__value__.reject!(...)
		self
	end

	def sort(...)
		__with__(@__value__.sort(...))
	end

	def to_a
		@__value__.dup
	end

	alias_method :to_ary, :to_a

	def unshift(value)
		Literal.check(actual: value, expected: @__type__) do |c|
			c.fill_receiver(receiver: self, method: "#unshift")
		end

		@__value__.unshift(value)
		self
	end
end
