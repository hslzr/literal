# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Descendant(Enumerable) === Array
	assert _Descendant(Enumerable) === Set

	refute _Descendant(Enumerable) === []
	refute _Descendant(Enumerable) === String
end

test "hierarchy" do
	assert_subtype  _Descendant(Array), _Descendant(Enumerable)
	assert_subtype  _Descendant(Set), _Descendant(Enumerable)

	refute_subtype _Descendant(Enumerable), _Descendant(Array)
	refute_subtype _Descendant(String), _Descendant(Enumerable)
end
