class_name KeywordDependencies
extends Resource

var game_state: GameState
var keyword_provider: KeywordProvider

func _init(_game_state: GameState, _keyword_provider: KeywordProvider) -> void:
    game_state = _game_state
    keyword_provider = _keyword_provider