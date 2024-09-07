# Simple holding service
For digitapes.

This python application comes in two parts:
* The flask webserver
* The CLI tool

This should be enough to get someone started
with making their own digitapes.

## Flask Web server API

The flask webserver is json based so that it
can work with the digitapes app. 

## CLI tool

The CLI tool can be used in conjunction with
the flask server, so that there is a way
to manipulate the local storage of digitapes
without needing the server running.


# Storage

We've implemented a `LocalStorage` plugin to use 
the filesystem as a storage backend for this 
holding service.

One could easily make another plugin, for something
like S3, or other cloud storage offerings.

# Contributing

Anyone can contribute, and we hope that this can be
a good project for you to contribute to. Submit a PR!

## TODO

* Cloud storage (S3)
* Application packaging (ie: `pipx install -e .`) for
  easier use for non-python people
* Authentication / Authorisation (in conjunction with app)
