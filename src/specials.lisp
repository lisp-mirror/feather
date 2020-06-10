(in-package :feather)

(defvar *db-spec*)

;; These are dev values. Production values are loaded from a file at startup if
;; it exists

(defvar *db-name* "feather_dev")
(defvar *db-user* "feather_dev")
(defvar *db-pwd* "feather_dev")
(defvar *db-host* "localhost")
