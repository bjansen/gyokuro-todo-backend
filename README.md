# gyokuro-todo-backend
An implementation of the [Todo-Backend](http://todobackend.com/) based on [Ceylon](https://ceylon-lang.org/) and [gyokuro](http://www.gyokuro.net).

You can [run the reference specs on a live instance](http://todobackend.com/specs/index.html?https://gyokuro-todo-backend.herokuapp.com/todo) to validate this implementation.

## Building and running

```bash
$ git clone https://github.com/bjansen/gyokuro-todo-backend.git
$ cd gyokuro-todo-backend
$ ceylon compile
$ ceylon run gyokuro.demo.todobackend/1.0.0
```

The test suite can be run by opening the following URL in your browser:

http://todobackend.com/specs/index.html?http://localhost:8080/todo

## Deploying on Heroku

Create a new project on Heroku, and do the following in the `Settings` part:

* add the config variable `APP_HOSTNAME=<your-app-name>.herokuapp.com`
* add the config variable `APP_PORT=80`
* add the buildpack `heroku/java`

Then from your machine run the following commands:

```bash
$ ceylon compile
$ ceylon fat-jar gyokuro.demo.todobackend
$ heroku deploy:jar gyokuro.demo.todobackend-1.0.0.jar --app <your-app-name>
```
