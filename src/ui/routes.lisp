(in-package :feather)

;;;; HTML Templates ************************************************************

(djula:add-template-directory
 (asdf:system-relative-pathname "feather" "src/templates/"))

(defparameter +index.html+
  (djula:compile-template* "index.html"))

;;;; Routes ********************************************************************

(defroute root-get ("/" :method :get
                        :decorators (@db))
    ()
  "GET handler for the landing page."
  (djula:render-template* +index.html+ nil))
