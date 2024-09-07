import argparse
import sys
from pathlib import Path

from digitapes.storages import get_storage

storage = get_storage("digitapes.storages.local.LocalStorage")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        prog="digitapes-cli",
        description="Build digitapes via the command line",
    )

    subs = parser.add_subparsers(help="The action to run", dest="command")
    list_parser = subs.add_parser("list")
    list_parser.description = "List the digitapes that you have available in the system"

    create_parser = subs.add_parser("create")
    create_parser.add_argument("title", help="The name of your tape")
    create_parser.add_argument(
        "description",
        help="extra information on what it's about",
    )

    describe_parser = subs.add_parser("describe")
    describe_parser.add_argument("tape_id", help="the ID of the tape to describe")

    add_parser = subs.add_parser("add")
    add_parser.add_argument("tape_id", help="the ID of the tape to add media to")
    add_parser.add_argument("filename", help="The file to add to the tape")

    args = parser.parse_args()

    if args.command == "list":
        list_tapes()
    elif args.command == "create":
        create_tape(args.title, args.description)
    elif args.command == "describe":
        describe_tape(args.tape_id)
    elif args.command == "add":
        add_media_to_tape(args.tape_id, args.filename)


def list_tapes():
    print("Your tapes available:")
    print("---------- -----------")
    for tape_id in storage.list_tapes_available():
        data = storage.get_tape_data(tape_id)

        print(f'{tape_id}, "{data["title"]}"')


def describe_tape(tape_id):
    data = storage.get_tape_data(tape_id)
    print("Title:", data["title"])
    print("--------------------------------------")
    print("Description:", data["description"])
    print("Last Updated:", data["updated_at"])
    if created_at := data.get("created_at"):
        print("Created:", created_at)
    media_items = data.get("media", [])
    print(f"{len(media_items)} Media objects")


def add_media_to_tape(tape_id: str, media: str) -> bool:
    data = storage.add_media_to_tape(media, tape_id)
    filename = Path(media).name
    print(f'Added {filename} to "{data["title"]}"')


def create_tape(title: str, description: str):
    tape_id = storage.create_tape(title, description)
    print(f"Tape {tape_id} created!")


if __name__ == "__main__":
    main(sys.argv)
