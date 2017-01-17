# Telebot

…is a basic Chicken Scheme module to ease the development of Bots interfacing with the Telegram Bot API.

In this context _basic_ means that the module currently consists of barely more than raw HTTP API calls hidden behind analogously named functions and JSON deserialization provided by the _http-client_ respectively _medea_ eggs.

The maintanance of these API wrappers is simplified by an appropriate _Scheme_ macro that reduces the implementation of new API methods to basically slightly rewriting the [documentation].

_Telebot_ is available under the terms of the MIT license on [Github] and [cgit].

## Documentation

All _basic_ API wrappers are named the same as their method name and require the bot's token as their first argument. Further parameters are expected as named key value pairs. Note that the library currently only verifies that all required parameters are supplied at all while type verification is left to _Telegram's_ server side logic.

```lisp
(sendMessage token
             chat_id: chat_id
             text:    text)
```

All API wrappers return the raw deserialized JSON results as to not limit the options for further parsing unnecessarily.

The only non-API wrapper provided by this library is `pollUpdates` which enables passing updates acquired via long polling of `getUpdates` to an arbitrary function as follows:

```lisp
(pollUpdates token
             (lambda (u)
               (begin (print-message u)
                      (echo-message  u))))
```

[documentation]: https://core.telegram.org/bots/api
[Github]: https://github.com/KnairdA/telebot/
[cgit]: https://code.kummerlaender.eu/Telebot/
