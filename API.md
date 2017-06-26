# API Docs

## Game

1. Create new game
```
@method - POST
@params - game_name
@url    - /v1/games
```

2. Return current game data
```
@method - GET
@params - nil
@url    - /v1/games
```
Result
```json
{
  "active": 1,
  "id": 5,
  "title": "Unknown Game"
}
```

---
## Rounds

1. Start new round
```
@method - POST
@params - game_id
@url    - /v1/games/rounds
```
Ответ
```json
{
  "active": 1,
  "game_id": 1,
  "id": 6
}
```

2. Return current round data
```
@method - GET
@params - nil
@url    - /v1/games/rounds
```
Result
```json
{
  "active": 1,
  "game_id": 1,
  "id": 5
}
```

3. Marks a round as close.
```
@method - PUT
@params - round_id
@url    - /v1/games/rounds/close
```

---
## Answers

1. Add answer for round
```
@method - POST
@params - round_id, user_id, answer=1|0
@url    - /v1/answers
```

2. Returns the current round users list
```
@method - GET
@params - nil
@url    - /v1/answers/users
```
Result
```json
[
  {
    "id": 1,
    "last_name": "Mejl",
    "name": "Sam",
    "photo_url": null
  },
  {
    "id": 2,
    "last_name": "Vasyra",
    "name": "Nastya",
    "photo_url": null
  }
]
```
