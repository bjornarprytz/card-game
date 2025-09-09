class_name PromptExpression
extends SimpleExpression

var prompt_key: String

func _init(prompt_key_: String):
    super._init("#%s" % prompt_key_)
    prompt_key = prompt_key_
