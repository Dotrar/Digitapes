# Holding services

A digitape has bits of data that must be stored somewhere. This can be stored
locally, or online as part of a service. This forms a "holding service".


It is an expectation of digitapes compatibility that any digitape from any source
(as long as it adheres to the digitapes standard as defined in this repository)
can be used on any digitapes compatible service.

Likewise, the holding service can then be used to share the digitape in a secure
way, to any service that consumes a digitape, such as a montage service.

## Holding services API

The holding service should atleast provide these features

* a way to list what tapes a user has available
* a way to get details about a tape
* a way to create a tape
* a way to add media to that tape
* import tapes from other services
* export tapes for other services


