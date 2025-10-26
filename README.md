# gerbil-netext

Gerbil FFI bindings for supplemental C networking headers.

This project provides Gerbil Scheme bindings for C networking interfaces that are not yet covered by Gerbil’s core libraries.

## Example

```scheme
;; netdb.h — for host database access
(import :netext/netdb)

;; Example: get host information
(getservbyname "smtp")
