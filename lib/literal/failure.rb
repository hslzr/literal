# frozen_string_literal: true

class Literal::Failure < Literal::Result
	# @return [String]
	def inspect = "Literal::Failure(#{@value.inspect})"

	# @return [false]
	def success? = false

	# @return [true]
	def failure? = true

	# @return [Literal::NothingClass]
	def success = Literal::Nothing

	# @return [Literal::Some]
	def failure = Literal::Some(@value)

	def raise!
		raise @value
	end

	alias_method :value_or_raise!, :raise!

	def value_or
		yield(@value)
	end

	def fmap = self
	def map(type = nil) = self
	def bind = self
	def then(type = nil) = self
	def filter = self

	def deconstruct
		[@value]
	end

	def deconstruct_keys(_)
		{ failure: @value }
	end

	def lift(&)
		Literal::Failure::Lift.new(@value, &).call
	end

	def lift!(&)
		Literal::Failure::Lift.new(@value, &).call!
	end
end
