;;; -*- Gerbil -*-
;;; General-purpose networking utilities for low-level operations.

(import :std/misc/bytes)

(export #t)

;; Convert a 16-bit integer from host byte order to network byte order (big endian).
(def (htons (n : :integer))
  => :integer
  (if (eq? native-endianness 'little)
    (bitwise-ior (arithmetic-shift (bitwise-and n #xFF) 8)
                 (arithmetic-shift n -8))
    n))

;; Symmetric counterpart of htons (network-to-host short)
(defalias ntohs htons)

;; Convert a 32-bit integer from host byte order to network byte order (big endian).
(def (htonl (n : :integer))
  => :integer
  (if (eq? native-endianness 'little)
    (bitwise-ior
     (arithmetic-shift (bitwise-and n #x000000FF) 24)
     (arithmetic-shift (bitwise-and n #x0000FF00) 8)
     (arithmetic-shift (bitwise-and n #x00FF0000) -8)
     (arithmetic-shift (bitwise-and n #xFF000000) -24))
    n))

;; Symmetric counterpart of htonl (network-to-host long)
(defalias ntohl htonl)
