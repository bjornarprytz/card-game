# card-game

game on itch.io: [link](https://thewarlock.itch.io/card-game)

Stipulation: 3 color palette

Card game TODO:

- Prompt:
  - Allow for lax min-requirements (e.g. Mind Rot should work when there's only one card left in hand)
- Cost
  - CostProto, or some way to express costs and bind it to state changing effect
  - Payment must be validated at some point. It should probably be a part of GameActions, because it's a natural way to limit the player's action, and wouldn't make sense as part of any other effect block (as far as I can see right now.).
  - Maybe one solution would be for the payment to be validate once when the GameLoop receives the action. At that point the payment effects are prepended to the EffectBlock and resolved with the rest of the block. It's possible it should be done immediately, just like in magic, but that seems overly complicated/imitational for a single player setting.
- Track source of effects
- More dynamic keyword/effect lookup?
  - This one
- Event History
  - And scope
- Triggered effects
- Keyword variables (e.g. Delirium, Cards in hand, Spells in graveyard)
- AtomCondition
  - Add context to the expression

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
