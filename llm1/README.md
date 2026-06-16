
Youtube-запись от `2026-05-15`: https://youtu.be/c9pLgg0w488

# Используем C для обращений к LLM?!
<img width="575" height="363" alt="stream-monkey" src="https://github.com/user-attachments/assets/255d6f19-14e9-46fd-b32b-e81bacef6c00" />

## Что мы видим

### Магическое впечатление

```mermaid
flowchart LR
req(Вопрос):::white
llm(LLM):::black
answ(Ответ):::green

req -.-> llm -.-> answ

classDef white fill:#FDF9EC,stroke:#FDF9EC,color:#282828;
classDef black fill:#282828,stroke:#282828,color:#FFFFFF;
classDef green fill:#9A9A00,stroke:#9A9A00,color:#FDF9EC;
```

<img width="1280" height="720" alt="stream-karlsson" src="https://github.com/user-attachments/assets/89869730-c9a6-43db-af3e-52c0292a329b" />

### Занудная реальность

```mermaid
flowchart LR
text(Текст):::white
llm(LLM):::black
word(+1 слово):::green

text -.-> llm -.-> word

classDef white fill:#FDF9EC,stroke:#FDF9EC,color:#282828;
classDef black fill:#282828,stroke:#282828,color:#FFFFFF;
classDef green fill:#9A9A00,stroke:#9A9A00,color:#FDF9EC;
```

(картинки с троечником не нашлось — вот ведь интересно как)


### Но откуда же тогда впечатление?!

```mermaid
flowchart LR
sentence(Длинный текст)
llm(LLM)

subgraph слово_за_слово
w1(слово)
w2(слово)
w3(…)
end

sentence ==> llm ==> w1
w1 ==> sentence
sentence -.-> llm -.-> w2
w2 -.-> sentence
```

> [!TIP]
> Мы сами себе придумали, что тут есть вопрос и ответ

> мы шли по лесу вдруг аркадий  
> остановился у сосны  
> и воровато оглянувшись  
> сказал отличная сосна
> @ [sometimer](https://poetory.ru/authors/sometimer/all)
###### Что будет говорить ~~княгиня Марья Алексевна~~ LLM?
![](c-stream-llm-pine.png)

## 

---

## Отличная сосна! Потащили
*Источник фото — [Depositphotos](https://depositphotos.com/ru/photo/pine-tree-log-lie-in-a-forest-102002842.html). Вроде так можно.*
<img width="1023" height="682" alt="depositphotos_102002842-stock-photo-pine-tree-log-lie-in" src="https://github.com/user-attachments/assets/c2e3dc9e-9fb7-4328-bba1-d3050873425e" />


## Модель — мёртвые данные
- Много байтиков + инструкция по эксплуатации.
- [Hugging Face](https://huggingface.co) — популярный склад байтиков.
- [llama.cpp](https://github.com/ggml-org/llama.cpp) — популярный «верстак», на котором оживает инструкция.

## «Инференс» — заклинание оживления

- Инференс — это просто использование модели.
- Ну как «просто»…

Хорошо: инструкция есть.
Плохо: она на птичьем языке.

### Prefill — фаза «понимания» запроса

- Нужно оцифровать запрос.
- Суть — модель «готовится» наращивать запрос слово за словом.
- Эта фаза жрёт — время и ресурсы железа.
- А пользователи уже привыкли к мгновенным ответам!

> [!WARNING]
> Пахнет технической задачкой, правда?

Хорошо: математика наконец пригодится «в жизни».
Плохо: это не школьная и даже не всякого университета математика.


### Токенизация — это ещё ничего
> У меня есть словарь, я понимаю запросы только на нём.
> Вот какой алгорифм переводит человеческий текст «текст» на моём языке.
> Переведёте — поговорим.

---

Первая задача: перевести человеческий текст в слова из этого словаря.

Хорошая новость: алгорифмы общие для всех, их немного.
Плохая новость: словарь у каждой модели свой.

Словарь — это как профессиональный жаргон. Нужен для конкретных задач.
Можно без него? Можно. Но тогда и говорить будете только о погоде.

Алгорифмы года: **BPE** (Byte Pair Encoding), **WordPiece** и **Unigram**.

Интересный очевидный факт: последний слой модели всегда имеет размер, равный размеру словаря.

Алгорифмы на C/Rust + обвязка на Python
Сложность O(N) — легкотня!

Токен — это вектор. Цепочка чисел.
В каком пространстве?
Ну, завела там себе LLM пространство смыслов, простим её.

Главное — что теперь можно умножать этот вектор на матрицы! Ура!
