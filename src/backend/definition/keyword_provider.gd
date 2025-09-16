class_name KeywordProvider
extends Resource

var _dependencies: KeywordDependencies
var _definitions: Dictionary[String, KeywordDefinition] = {}
var _payment_definitions: Dictionary[String, PaymentDefinition] = {}

func _init(game_state: GameState):
    _dependencies = KeywordDependencies.new(game_state)
    _scan_definitions()

func add_definition(definition: KeywordDefinition) -> void:
    if (definition is PaymentDefinition):
        if (_payment_definitions.has(definition.keyword)):
            push_error("Payment definition for '%s' already exists in %s" % [definition.keyword, self.name])
            return
        _payment_definitions[definition.keyword] = definition
        return

    if (_definitions.has(definition.keyword)):
        push_error("Keyword definition for '%s' already exists in %s" % [definition.keyword, self.name])
        return

    _definitions[definition.keyword] = definition

## Bind the arguments to executable operations
func create_operation_tree(keyword: String, args: Array) -> KeywordNode:
    if (!_definitions.has(keyword)):
        push_error("No definition for keyword '%s' exists" % [keyword])
        return null

    var definition = _definitions[keyword]

    var injected_args = [_dependencies]
    injected_args.append_array(args)
    
    return definition.create_operation_tree(injected_args)

func verify_payment(keyword: String, args: Array) -> PaymentResult:
    if (!_payment_definitions.has(keyword)):
        push_error("No definition for payment keyword '%s' exists" % [keyword])
        return null

    var definition = _payment_definitions[keyword]

    var injected_args = [_dependencies]
    injected_args.append_array(args)
    
    return definition.verify_payment(injected_args)

func _scan_definitions() -> void:
    var scripts = Utility.scan_directory_for_scripts("res://backend/definition/concrete/")
    for script in scripts:
        var instance = script.new()
        if instance is KeywordDefinition:
            add_definition(instance)
        else:
            push_error("Script %s does not extend KeywordDefinition, skipping." % script.resource_path)
