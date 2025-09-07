class_name PaymentDefinition
extends KeywordDefinition

func verify_payment(args: Array) -> PaymentResult:
	if (!self.has_method(keyword)):
		push_error("Method '%s' does not exist in %s" % [keyword, self.name])
		return null

	if (arg_count != args.size()):
		push_error("Method '%s' called with incorrect number of arguments in %s" % [keyword, self.name])
		return null
	
	var result = self.callv(keyword, args)

	if result == null:
		push_error("Method '%s' returned null in %s" % [keyword, self.name])
		return null

	return result
