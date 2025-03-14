# frozen_string_literal: true

include Literal::Types

test "===" do
	Fixtures::Objects.each do |object|
		assert _Any === object
	end

	refute _Any === nil
end

test "hierarchy" do
	assert_subtype _Any, _Any
	assert_subtype String, _Any
	assert_subtype "Hello", _Any
	assert_subtype 1, _Any

	refute_subtype nil, _Any
	refute_subtype Object, _Any
	refute_subtype _Nilable(_Any), _Any
	refute_subtype _Nilable(String), _Any
end
