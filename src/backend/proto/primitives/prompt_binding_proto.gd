class_name PromptBindingProto
extends Resource

## Must be unique within the context (effect block)
var binding_key: String

var is_collection: bool

## Fail if fewer than minimum choices are provided.
var strict_min_count: bool = false

var min_count: int = 1
var max_count: int = 1

var description: String = ""
var _candidate_conditions: AtomConditionProto = null
var _candidates_expression: ContextExpression = null

func _init(binding_key_: String, count_spec: CountSpec, description_: String, candidates_expression_: ContextExpression, candidate_conditions_: AtomConditionProto) -> void:
    binding_key = binding_key_
    min_count = count_spec.min_count
    max_count = count_spec.max_count
    is_collection = count_spec.is_collection
    description = description_
    _candidates_expression = candidates_expression_
    _candidate_conditions = candidate_conditions_

func get_candidates(context: Context) -> Array[Atom]:
    var verified_candidates: Array[Atom] = []

    for candidate in _candidates_expression.evaluate(context):
        if not candidate is Atom:
            push_warning("Candidate '%s' is not an Atom" % str(candidate))
            continue
        var is_valid = true
        for condition in _candidate_conditions:
            if condition.evaluate(candidate) != true:
                is_valid = false
        if is_valid:
            verified_candidates.append(candidate)

    return verified_candidates

func validate_binding(context: Context, binding: Array) -> bool:
    if (binding.size() < min_count or binding.size() > max_count):
        push_error("Response size is out of bounds: %d (min: %d, max: %d)" % [binding.size(), min_count, max_count])
        return false
    
    var candidates = get_candidates(context)
    for choice in binding:
        if not choice in candidates:
            push_error("Choice '%s' is not in the candidates: %s" % [choice, candidates])
            return false
    return true

static func from_dict(key: String, dict: Dictionary) -> PromptBindingProto:
    var binding_key_ = key
    var count_spec = CountSpec.from_string(str(dict.get("count", "1")))

    var description_ = dict["description"]
    if (description_ == null):
        push_error("Description cannot be null for PromptBindingProto")
    
    var candidates_expression = ContextExpression.from_string(dict.get("candidates", "[]"))
    var candidate_conditions = AtomConditionProto.from_expressions(dict.get("conditions", []))

    return PromptBindingProto.new(
        binding_key_,
        count_spec,
        description_,
        candidates_expression,
        candidate_conditions
    )

static func from_target_shorthand(target: Dictionary) -> PromptBindingProto:
    var binding_key_ = "targets"
    var count_spec_: CountSpec

    if (target.get("optional", false) == false):
        count_spec_ = CountSpec.required()
    else:
        count_spec_ = CountSpec.optional()

    var atom_condition_expressions: Array[String] = target.get("conditions", [])

    if (target.has("type")): # Shorthand for type
        atom_condition_expressions.append("atom.atom_type == %s" % target["type"])
            
    var candidate_conditions = AtomConditionProto.from_expressions(atom_condition_expressions)

    var zone_expression: String = ":battlefield.atoms"
    if (target.has("zone")): # Shorthand for zone
        zone_expression = ":%s.atoms" % target["zone"]
    var candidates_expression = ContextExpression.from_string(zone_expression)

    return PromptBindingProto.new(
        binding_key_,
        count_spec_,
        "Targets",
        candidates_expression,
        candidate_conditions
    )

func _to_string() -> String:
    return "%s(%d-%d)" % [binding_key, min_count, max_count]

class CountSpec:
    var min_count: int
    var max_count: int
    var is_collection: bool

    func _init(min_count_: int, max_count_: int):
        min_count = min_count_
        max_count = max_count_
        
        is_collection = max_count > 1
        
        assert(min_count >= 0 and max_count >= min_count, "Invalid count specification: (0 <= min <= max) vs (%d <= %d)" % [min_count, max_count])

    static func optional():
        return CountSpec.new(0, 1)
    
    static func required():
        return CountSpec.new(1, 1)

    static func from_string(type_str: String):
        var min_count_ = 1
        var max_count_ = 1

        var parts = type_str.split("-")
        if parts.size() == 1:
            min_count_ = int(parts[0])
            max_count_ = min_count_
        elif parts.size() == 2:
            min_count_ = int(parts[0])
            max_count_ = int(parts[1])

        return CountSpec.new(min_count_, max_count_)
