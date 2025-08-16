# card-game

game on itch.io: [link](https://thewarlock.itch.io/card-game)

Stipulation: 3 color palette

Card game TODO:

- Resolution Protocol
  - Preamble:
    - Pay costs
    - Move card to resolution zone (stack)
  - Cleanup:
    - Move card to destination (usually discard_pile)
- Scope
  - Create accessor shorthands for VariableProto
    - Try to figure out a nice syntax/API for aggregations ()
    - "%block.damage.total"
  - Static effects / Modifiers
    - ModifierProto
      - Scope
      - Value
      - PropertyName
      - Modifier Type
      - Target(s) (affected atoms)
      - Duration / End Condition (in addition to scope)
- AtomCondition
  - Add context to the expression
- Triggered effects
- Keyword Refactor
  - Keyword variables (e.g. Delirium, Cards in hand, Spells in graveyard)
  - More dynamic keyword/effect lookup?
  - Maybe separate keywords into different kinds:
    - Composite / Higher-Order
      - Always inject state so that card don't have to explicitly get it from the state
    - Simple
      - Acts on one atom, state isn't injected

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
