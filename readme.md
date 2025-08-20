# card-game

game on itch.io: [link](https://thewarlock.itch.io/card-game)

Stipulation: 3 color palette

Card game TODO:

- Triggered effects
- Static effects / Modifiers
  - ModifierProto
    - Duration / End Condition
- AtomCondition
  - Add context to the expression
- Scope
  - Create accessor shorthands for VariableProto
    - Try to figure out a nice syntax/API for aggregations ()
    - "|block.damage.total"
- Keyword Refactor
  - Complex Keyword variables (e.g. Delirium, Spells in graveyard)
  - More dynamic keyword/effect lookup?
  - Maybe separate keywords into different kinds:
    - Composite / Higher-Order
      - Always inject state so that card don't have to explicitly get it from the state
    - Simple
      - Acts on one atom, state isn't injected
- Activated abilities
- Operation Refactor
  - Create some special operations / results for
    - Creating atoms
    - Adding modifiers
- Check TODOs

## TODO

- Setup itch.io page for card-game [link](https://itch.io/game/new)
  - Set Project URL to card-game (can be changed later)
  - Set Kind to HTML
  - Hit the Save button
- Get Butler API key from [itch.io](https://itch.io/user/settings/api-keys)
- Add key to GitHub repository secrets as BUTLER_API_KEY [link](https://github.com/bjornarprytz/card-game/settings/secrets/actions)
- Push release with `./push_release.sh`
- Go [here](https://itch.io/game/new) and edit game:
  - Check "This file will be played in the browser"
  - Set viewport dimensions (normal: 1280x720)
  - Check SharedArrayBuffer

### Extra

- itch.io
  - Rename the game
  - Write a short description
  - Make a nice cover image (630x500)
  - Add screenshots (recommended: 3-5)
  - Pick a genre
  - Add a tag or two
  - Publish a devlog on instagram

### Meta

- Tackle multiplayer in HTML5
  - https://www.reddit.com/r/godot/comments/bux2hs/how_to_use_godots_high_level_multiplayer_api_with/
