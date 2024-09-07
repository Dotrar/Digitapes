import importlib
from typing import Protocol


class Storage(Protocol):
    """
    Base storage Protocol

    This is not a digitapes wide API, but instead
    just the API for this small simple python system
    """

    def get_tape_data(id: str) -> dict:
        """
        Return specific data about one tape
        for the given ID
        """

    def list_tapes_available(params: dict) -> list[str]:
        """
        Return a list of tape IDs
        """

    def create_tape(name: str, description: str) -> str:
        """
        Create the tape, returns the ID
        """

    def add_media_to_tape(filepath: str, id: str) -> dict:
        """
        Adds the given media filepath to the tape
        object
        """


def get_storage(module: str) -> Storage:
    """
    Return the storage unit
    """

    spec = module.split(".")

    classname = spec[-1]
    module_path = ".".join(spec[:-1])

    cls = getattr(importlib.import_module(module_path), classname)
    return cls()
