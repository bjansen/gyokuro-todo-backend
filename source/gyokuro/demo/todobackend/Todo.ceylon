variable Integer sequence = 0;

class Todo(title, completed = false) {
    shared variable String title;
    shared variable Boolean completed;
    shared Integer id = sequence++;
    shared variable String url = "/todo/``id``";
}
