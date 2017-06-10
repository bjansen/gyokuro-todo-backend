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

import net.gyokuro.core {
    Application,
    get,
    options,
    post,
    delete,
    halt
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

    Application {
        filters = [corsFilter];
        transformers = [jsonTransformer];
    }.run();
}

void corsFilter(Request req, Response resp, Anything(Request, Response) next) {
    resp.addHeader(Header("Access-Control-Allow-Origin", "*"));
    next(req, resp);
}

void optionsHandler(Response response) {
    response.addHeader(Header("Access-Control-Allow-Headers", "Content-Type"));
    response.addHeader(Header("Access-Control-Allow-Methods", "GET,POST,DELETE"));
}

List<Todo> listTodos() => todoDB;

Todo createTodo(Request req, Todo todo) {
    value address = req.destinationAddress.address;
    value host = if (address == "0:0:0:0:0:0:0:1") then "localhost" else address;

    todo.url = req.scheme + "://" + host + ":" + req.destinationAddress.port.string + todo.url;
    todoDB.add(todo);

    return todo;
}

void deleteTodos() {
    todoDB.clear();
}

Todo getTodo(Integer todoId) =>
        todoDB.find((t) => t.id == todoId)
        else halt(404, "TODO ``todoId`` not found");