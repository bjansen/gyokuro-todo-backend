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
    delete
}

MutableList<Todo> todoDB = ArrayList<Todo>();

"Runs the todo backend."
shared void run() {

    // the api root responds to a GET (i.e. the server is up and accessible, CORS headers are set up)
    get("/todo", `listTodos`);
    options("/todo", `optionsHandler`);

    // the api root responds to a POST with the todo which was posted to it
    post("/todo", `createTodo`);

    // the api root responds successfully to a DELETE
    delete("/todo", `deleteTodos`);

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
    todo.url = req.scheme + "://" + req.destinationAddress.address + ":" + req.destinationAddress.port.string + todo.url;
    todoDB.add(todo);
    return todo;
}

void deleteTodos() {
    todoDB.clear();
}
