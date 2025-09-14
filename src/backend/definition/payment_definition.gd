class_name PaymentDefinition
extends KeywordDefinition

func verify_payment(args: Array) -> PaymentResult:
	if (_validate_args(args) == false):
		return null
	
	var result = self.callv(keyword, args)

	if result == null:
		push_error("Method '%s' returned null in %s" % [keyword, self.name])
		return null

	return result
