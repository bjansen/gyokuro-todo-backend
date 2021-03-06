import ceylon.collection {
    MutableList,
    ArrayList
}
import ceylon.http.common {
    Header
}
import ceylon.http.server {
    Response,
    Request
}
import ceylon.json {
    JsonObject
}

import net.gyokuro.core {
    Application,
    get,
    options,
    post,
    delete,
    halt,
    patch
}

MutableList<Todo> todoDB = ArrayList<Todo>();

"Runs the todo backend."
shared void run() {

    // the api root responds to a GET (i.e. the server is up and accessible, CORS headers are set up)
    get("/todo", `listTodos`);
    options("/todo", `optionsHandler`);

    // the api root responds to a POST with the to-do which was posted to it
    post("/todo", `createTodo`);

    // the api root responds successfully to a DELETE
    delete("/todo", `deleteTodos`);

    // each new to-do has a url, which returns a to-do
    get("/todo/:todoId", `getTodo`);
    options("/todo/:todoId", `optionsHandler`);

    // can change the to-do's title by PATCHing to the to-do's url
    // can change the to-do's completedness by PATCHing to the to-do's url
    patch("/todo/:todoId", `modifyTodo`);

    // can delete a to-do making a DELETE request to the to-do's url
    delete("/todo/:todoId", `deleteTodo`);

    Application {
        filters = [corsFilter];
        port = parseInteger(process.environmentVariableValue("PORT") else "8080") else 8080;
        transformers = [jsonTransformer];
    }.run();
}

void corsFilter(Request req, Response resp, Anything(Request, Response) next) {
    resp.addHeader(Header("Access-Control-Allow-Origin", "*"));
    next(req, resp);
}

void optionsHandler(Response response) {
    response.addHeader(Header("Access-Control-Allow-Headers", "Content-Type"));
    response.addHeader(Header("Access-Control-Allow-Methods", "GET,POST,DELETE,PATCH"));
}

List<Todo> listTodos() => todoDB;

Todo createTodo(Request req, Todo todo) {
    value host = process.environmentVariableValue("APP_HOSTNAME") else "localhost";
    value port = process.environmentVariableValue("APP_PORT")
            else process.environmentVariableValue("PORT")
            else req.destinationAddress.port.string;

    todo.url = req.scheme + "://" + host + ":" + port + todo.url;
    todoDB.add(todo);

    return todo;
}

void deleteTodos() {
    todoDB.clear();
}

suppressWarnings ("expressionTypeNothing")
Todo getTodo(Integer todoId) =>
        todoDB.find((t) => t.id == todoId) else halt(404, "TODO ``todoId`` not found");

Todo modifyTodo(Integer todoId, JsonObject patch) {
    value todo = getTodo(todoId);

    if (exists title = patch.getStringOrNull("title")) {
        todo.title = title;
    }
    if (exists completed = patch.getBooleanOrNull("completed")) {
        todo.completed = completed;
    }
    if (exists order = patch.getIntegerOrNull("order")) {
        todo.order = order;
    }

    return todo;
}

void deleteTodo(Integer todoId) =>
        todoDB.removeWhere((t) => t.id == todoId);
