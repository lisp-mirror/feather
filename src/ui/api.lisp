(in-package :feather)

;;;; Example *******************************************************************

;;; GET           /api/thing     - list
;;; GET           /api/thing/:id - read one
;;; POST (create) /api/thing     - create
;;; POST (update) /api/thing/:id - update one
;;; POST (delete) /api/thing/:id - delete one

;; (defroute api-thing-index
;;     ("/api/thing"
;;      :method :get
;;      :decorators (@errors @db @json))
;;     ()
;;   "List all the things.")

;; (defroute api-thing-show
;;     ("/api/thing/:id"
;;      :method :get
;;      :decorators (@errors @db @json))
;;     ()
;;   "Return one thing with ID.")

;; (defroute api-thing-create
;;     ("/api/thing"
;;      :method :post
;;      :decorators (@errors @db @json))
;;     (&post thing-data)
;;   "Create a new thing.")

;; (defroute api-thing-modify
;;     ("/api/thing/:id"
;;      :method :post
;;      :decorators (@errors @db @json))
;;     ()
;;   "Update or delete one thing with ID.
;;    HTTP verb POST is used for both update and delete. The desired action need to
;;    be specified some other way.")

;;;; Usernames *****************************************************************

(defroute api-usernames-index
    ("/api/usernames"
     :method :get
     :decorators (@errors @db @json))
    ()
  "List all the newest usernames."
  (st-json:write-json-to-string (feather.logic:list-usernames)))

(defroute api-usernames-create
    ("/api/usernames"
     :method :post
     :decorators (@errors @db @json))
    (&post username)
  "Create a new username."
  (check-parameter-non-zero-string username)
  (st-json:write-json-to-string (feather.logic:create-username username))
