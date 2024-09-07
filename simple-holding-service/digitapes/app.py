from flask import Flask

from digitapes.storages import get_storage

app = Flask(__name__)

storage = get_storage("digitapes.storages.local.LocalStorage")


@app.route("/list")
def list_tapes():
    return storage.list_tapes_available()


@app.route("/create")
def create_tape():
    name = "test"
    description = "foobar"
    id = storage.create_tape(name, description)

    return storage.get_tape_data(id)


@app.route("/get/<str:id>")
def get_tape(id):
    # check if id is valid
    data = storage.get_tape_data(id)
    # provide thumbnails:
    data["thumbnails"] = load_thumbnail_dir(id)

    return data


@app.route("/thumbnails/<str:media_id>")
def get_thumbnail(media_id):
    # if we can find media_id
    # retun that
    # else return default .png
    return None


@app.route("/add/<str:id>")
def add_media(id):
    # get post data?
    # add to media
    # return updated tape information
    filepath = ""
    storage.add_media(filepath, id)

    return None


@app.route("/export/<str:id>")
def export_tape(id):
    return None


@app.route("import")
def import_tape():
    return None


def load_thumbnail_dir(id: str) -> str:
    """
    For the given tape id,
    load the thumbnails asynchronously
    """
    return ""
