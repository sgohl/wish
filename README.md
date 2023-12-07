# wiSH -- web in SHELL

A simple web framework in `bash`

based on:

- https://github.com/msoap/shell2http
- https://github.com/TekWizely/bash-tpl
- https://startbootstrap.com/template/sb-admin
- https://github.com/damphat/kv-bash

> this is a POC! it neither claims being secure nor bug-free and is mainly for educational purposes.

# Why?

This project is born from the idea of having a system-near control panel (possibly for embedded systems where resources are limited) with a modern admin-ui being able to execute system/shell commands directly within pages, instead of using these `system()` or `exec()` functions from php, for example.

A full-fledged web framework would be kind-of overkill for someone not being routined and having to learn it first, only to then still abstract the actual system commands to get them executed. It wouldn't feel the same, anyway.

Since it's not bound to any framework or language (well, besides bash, of course), you can easily install perl, python, php-cli, go, ruby, and wrap functions around them for specific purposes.

Basically, it's mainly suitable for putting a web-frontend/api on top of existing cli-application(s). Like, providing a web-interface and/or API to a program that doesn't provide one by itself.

# Features

- bash-tpl for rendering bash code into HTML
- auth/cookie/session
- secure the whole app or specific Routes/Views/Pages/Fragments for logged-in users via `Guard`
- file-based pseudo-database (no relations by default)
- prepared for websockets (uses https://github.com/joewalnes/reconnecting-websocket)

# How it works

...
