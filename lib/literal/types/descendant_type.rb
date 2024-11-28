# frozen_string_literal: true

class Literal::Types::DescendantType
	include Literal::Type

	def initialize(type)
		@type = type
	end

	attr_reader :type

	def inspect
		"_Descendant(#{@type})"
	end

	def ===(value)
		Module === value && value < @type
	end

	def >=(other)
		case other
		when Literal::Types::DescendantType, Literal::Types::ClassType
			Literal.subtype?(other.type, of: @type)
		else
			false
		end
	end

	freeze
end
