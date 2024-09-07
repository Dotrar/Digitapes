# The digitape format

* Digitapes (the system) uses `digitape` (the object) as the main source of information
and data.

* A digitape can be simply be thought of as an "album", or a zipfile, or a directory, with
metadata attached, or otherwise in that same directory or zipfile.

* Digitape can also be called just "tape" for short.

* Tapes have two components: the "bulk" data, and the "ticket" which is the metadata.

## Digitape Metadata

A tape must provide `digitape.json` file, which provides information about the tape. This
json file must have the following fields:

* `title` - giving a name or a label to the tape.
* `description` - describing the tape.
* `updated_at` - the last time this tape was updated.
* `media` - a list of media objects

The media objects just have two fields that are required:

* `file` - the location of the media
* `crc32` - a checksum for integrity


### Additional data

Services that use digitapes can add their own additional data to the ticket, which can be
used by other services to consume that data, but only the above should be expected.
