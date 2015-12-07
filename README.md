README
------

[![Build Status](https://travis-ci.org/Funfun/my_api_app.svg?branch=master)](https://travis-ci.org/Funfun/my_api_app)

Seed user data:

```
  User.create!(role: Role::ADMIN, login: 'admin', password: 'admin')
  User.create!(role: Role::USER, login: 'user', password: 'user')
  User.create!(role: Role::GUEST, login: 'guest', password: 'guest')
```

To successfully work with [https://github.com/Funfun/my_api_app_client](https://github.com/Funfun/my_api_app_client) it is recommended to start server at port `:3001`
