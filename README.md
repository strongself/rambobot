# API Docs

## Методы для работы с игрой

1. Создать игру
```
@method - POST
@params - game_name
@url    - /v1/games
```

2. Данные о текущей игре
```
@method - GET
@params - nil
@url    - /v1/games
```
Ответ
```json
{
  "active": 1,
  "id": 5,
  "title": "Unknown Game"
}
```

---
## Методы раундов игр

1. Начать новый раунд игры для приёма нажатий
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

2. Получить текущий раунд
```
@method - GET
@params - nil
@url    - /v1/games/rounds
```
Ответ
```json
{
  "active": 1,
  "game_id": 1,
  "id": 5
}
```

3. Закрыть раунд игры
```
@method - PUT
@params - round_id
@url    - /v1/games/rounds/close
```

---
## Методы ответов для раунда

1. Добавить ответ
```
@method - POST
@params - round_id, user_id, answer=1|0
@url    - /v1/answers
```

2. Получить список пользователей для активного раунда
```
@method - GET
@params - nil
@url    - /v1/answers/users
```
Ответ
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
