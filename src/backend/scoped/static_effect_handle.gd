class_name StaticEffectHandle
extends Resource

enum State {
    LATENT,
    ACTIVE,
    QUEUED_FOR_CLEANUP,
    CLEANED_UP
}

var _state: State = State.LATENT

## The host atom. This is the atom that the effect is attached to.
var host: Atom

## The scope in which the handle applies.
var scope: Scope

## The static effect associated with this handle.
var effect: StaticEffect

## The number of turns the effect has been alive. Only relevant for global effects.
var turns_alive: int = 0

## True after setup and before queue_cleanup
var is_active: bool:
    get:
        return _state == State.ACTIVE

## Marks this effect for cleanup.
var is_queued_for_cleanup: bool:
    get:
        return _state == State.QUEUED_FOR_CLEANUP

var is_cleaned_up: bool:
    get:
        return _state == State.CLEANED_UP


func _init(scope_: Scope, host_: Atom, effect_: StaticEffect) -> void:
    scope = scope_
    host = host_
    effect = effect_

func turn_tick() -> Array[EffectBlock]:
    if !is_active:
        return []
    turns_alive += 1

    if turns_alive == effect.turn_duration:
        return queue_cleanup()

    return []

func on_event(event: Event) -> Array[EffectBlock]:
    if !is_active:
        return []
    
    var triggered_effects = _on_event_internal(event)

    if (event.state_changed(host, "current_zone")):
        var cleanup_effects = queue_cleanup()

        triggered_effects.append_array(cleanup_effects)

    return triggered_effects

func setup():
    if _state != State.LATENT:
        push_error("StaticEffectHandle.setup() called more than once")
    _state = State.ACTIVE
    _setup_internal()

## This is called after each effect (keyword) has resolved (i.e. multiple times per effect block)
func update(game_state: GameState) -> void:
    if !is_active:
        return
    
    _update_internal(game_state)

## This is called when the effect ends, for any reason.
func queue_cleanup() -> Array[EffectBlock]:
    if is_queued_for_cleanup:
        return []

    _state = State.QUEUED_FOR_CLEANUP

    return _cleanup_internal()

## This is called during the cleanup step.
func finish_cleanup() -> void:
    if !is_queued_for_cleanup:
        push_error("StaticEffectHandle.finish_cleanup() called when not queued for cleanup")
        return

    _state = State.CLEANED_UP

func _setup_internal():
    pass

func _update_internal(_game_state: GameState) -> void:
    pass

func _on_event_internal(_event: Event) -> Array[EffectBlock]:
    return []

func _cleanup_internal() -> Array[EffectBlock]:
    return []
