#!/usr/bin/env gxi
;;; -*- Gerbil -*-
(import :std/build-script)

(defbuild-script
  '("gerbil-netdb/lib"
    (exe: "gerbil-netdb/main" bin: "gerbil-netdb")))
