import net.gyokuro.core {
    Application,
    get,
    options
}
import ceylon.http.server {
    Response,
    Request
}
import ceylon.http.common {
    Header
}

"Runs the todo backend."
shared void run() {

    // the api root responds to a GET (i.e. the server is up and accessible, CORS headers are set up)
    get("/todo", (req, resp) => "Hello world!");
    options("/todo", `optionsHandler`);

    Application {
        filters = [corsFilter];
    }.run();
}

void corsFilter(Request req, Response resp, Anything(Request, Response) next) {
    resp.addHeader(Header("Access-Control-Allow-Origin", "*"));
    next(req, resp);
}

void optionsHandler(Response response) {
    response.addHeader(Header("Access-Control-Allow-Headers", "Content-Type"));
}