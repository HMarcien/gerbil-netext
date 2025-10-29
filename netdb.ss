;;; -*- Gerbil -*-
;;; netdb.h bindings for Gerbil Scheme

(import :std/error
        :std/sugar
        :std/foreign
        :std/format
        :std/os/error
        ./util)

(export service-info-by-name
        service-info-by-port
        service-info?
        service-info-name
        service-info-port
        service-info-protocol)


(defstruct service-info ((name :- :string) (port :- :integer) (protocol :- :string))
  final: #t)

(defmethod {to-string service-info}
  (lambda (self)
    (format "~a (~a/~a)" self.name self.port self.protocol)))

(def (service-info-by-name (name : :string) (protocol :? :string := "tcp"))
  => service-info
  (:- (service-entry name protocol) service-info))

(def (service-info-by-port (port : :integer) (protocol :? :string := "tcp"))
  => service-info
  (:- (service-entry (htons port) protocol) service-info))

(def (service-entry name-or-port (protocol : :string))
  (let ((get-service (if (string? name-or-port) _getservbyname _getservbyport)))
    (try
     (let (service (check-ptr (get-service name-or-port protocol)))
       (service-info (service-entry-name service)
                     (service-entry-port service)
                     protocol))
     (catch (foreign-allocation-error? e)
       (let ((id (if (number? name-or-port)
                   (ntohs name-or-port)
                   name-or-port)))
         (error "Service not found" id))))))

(def (service-entry-port service)
  (ntohs (_servent-port service)))

(def (service-entry-protocol service)
  (check-ptr (_servent-proto service)))

(def (service-entry-name service)
  (check-ptr (_servent-name service)))

(begin-ffi (_getservbyname _getservbyport _servent-port _servent-proto _servent-name)
  (c-declare "#include <netdb.h>")

  (c-define-type servent (struct "servent"))
  (c-define-type servent* (pointer servent (servent*)))

  (define-c-lambda _getservbyname (char-string char-string) servent* "getservbyname")
  (define-c-lambda _getservbyport (int char-string) servent* "getservbyport")
  (define-c-lambda _servent-port (servent*) int
    "___return (___arg1->s_port);")
  (define-c-lambda _servent-proto (servent*) char-string
    "___return (___arg1->s_proto);")
  (define-c-lambda _servent-name (servent*) char-string
    "___return (___arg1->s_name);")
  )
