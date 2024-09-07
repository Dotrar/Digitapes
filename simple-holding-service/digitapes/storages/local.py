import datetime
import json
import secrets
import shutil
import zlib
from pathlib import Path

DIGITAPES_FILE = "digitape.json"


class LocalStorage:
    """
    LocalStorage

    Uses the filesystem as a storage mechanism
    """

    STORAGE_DIR = Path("localstorage_store")

    def _get_datafile(self, tape_id: str) -> Path:
        tapedir = self.STORAGE_DIR / tape_id
        return tapedir / DIGITAPES_FILE

    def get_tape_data(self, tape_id: str) -> dict:
        data = self._get_datafile(tape_id)

        if not data.exists():
            return {}

        return json.load(data.open())

    def list_tapes_available(self, params: dict | None = None) -> list[str]:
        """
        Return a list of tape IDs
        we will only return fully-digit tape_ids
        """

        suitable_dirs = []
        for datafile in self.STORAGE_DIR.glob(f"*/{DIGITAPES_FILE}"):
            dirname = datafile.parent.name

            # we only expect dirnames to be 6
            if len(dirname) == 6:
                suitable_dirs.append(dirname)

        return suitable_dirs

    def create_tape(self, name: str, description: str) -> str:
        """
        Create the tape, returns the ID
        """
        timestamp = datetime.datetime.utcnow()
        dirname = secrets.token_hex(3).upper()

        tapedir = self.STORAGE_DIR / dirname
        if tapedir.exists():
            raise ValueError(f"Digitape already exists in dir {tapedir}")

        tapedir.mkdir(parents=True)

        data = {
            "title": name,
            "description": description,
            "created_at": timestamp.strftime("%Y-%m-%d %H:%M:%S"),
            "updated_at": timestamp.strftime("%Y-%m-%d %H:%M:%S"),
        }
        datafile = tapedir / DIGITAPES_FILE
        json.dump(data, datafile.open("w+"))

        return dirname

    def _update_tape_data(self, tape_id: str, newdata: dict) -> dict:
        datafile = self._get_datafile(tape_id)
        data = {
            **self.get_tape_data(tape_id),
            **newdata,
        }
        json.dump(data, datafile.open("w"))
        return data

    def add_media_to_tape(self, filepath: str, tape_id: str) -> dict:
        """
        Adds the given media filepath to the tape
        object
        """

        tapedata = self.get_tape_data(tape_id)
        if not tapedata:
            raise ValueError(f"No tape at with {tape_id=}")

        mediafile = Path(filepath)
        if not mediafile.exists():
            raise ValueError(f"Mediafile does not exist '{mediafile=}'")

        # create a new mediafile name, to store in the tape
        stem = mediafile.stem.lower()

        def _makepath() -> Path:
            newname = secrets.token_hex(5) + stem
            return self.STORAGE_DIR / newname

        path = _makepath()
        attempts = 0
        while path.exists():
            attempts += 1
            if attempts == 5:
                raise ExhaustedResourcesError
            path = _makepath()

        shutil.copy(mediafile, path)
        data = {
            "file": path.name,
            "crc32": crc32(path),
            "original_name": mediafile.name,
        }

        media_list = tapedata.get("media", [])
        media_list.append(data)
        tapedata["media"] = media_list

        return self._update_tape_data(tape_id, tapedata)


def crc32(filename, chunksize=65536):
    """Compute the CRC-32 checksum of the contents of the given filename"""
    with open(filename, "rb") as f:
        checksum = 0
        while chunk := f.read(chunksize):
            checksum = zlib.crc32(chunk, checksum)
        return checksum


class ExhaustedResourcesError(Exception):
    """
    We have run out of unique mediafile names
    """
