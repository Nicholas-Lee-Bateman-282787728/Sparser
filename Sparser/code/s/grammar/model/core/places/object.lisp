;;; -*- Mode:LISP; Syntax:Common-Lisp; Package:(SPARSER LISP) -*-
;;; copyright (c) 1992-1999,2011  David D. McDonald  -- all rights reserved
;;; extensions copyright (c) 2008-2009 BBNT Solutions LLC. All Rights Reserved
;;; $Id$
;;;
;;;     File:  "object"
;;;   Module:  "model;core:places:"
;;;  version:  July 2011

;; initiated in 10/12/92 v2.3. Added 'kind of location' 1/17/94.  Added location-
;; phrase 11/16/95. Added relative-location 11/99. 11/25 Moved in spatial-
;; orientation (from [words;]). 12/12 fixed choice of category name.
;; 0.1 (7/13/08) Included a subcategory within define-kind-of-location so we no
;;   longer have to write kind-specific categories and rules. 
;; 0.2 (4/19/09) Commented out the relative-location rule because it is
;;   masking verb-centric categories. 4/27 Added here, there as deictic-locations
;;   6/15 Added over here, over there as deictic-locations
;;   7/23 Added a treatment for "from," not sure if I'm happy with it. Throwing
;;   away the "form" analysis as way too narrow and presumptuous. 
;; 0.3. 7/21/11 Moved spatial-orientation and relative-location out to [relational]
;;   and location-description to [descriptive].

(in-package :sparser)

;;;-------------------------------------------------
;;; base category - not intended to be instantiated
;;;-------------------------------------------------

(define-category  location
  :instantiates  self
  :specializes   nil )


(define-autodef-data 'location
  :display-string "Locations"
  :not-instantiable t)



;;;------------------------------------------------
;;; Deictics  -- needs a story about dereferencing
;;;------------------------------------------------

(define-category  deictic-location 
  :instantiates  location ;;self
  :specializes   location
  :binds ((name :primitive word))
  :index (:permanent :key name)
  :realization (:proper-noun name))

(define-individual 'deictic-location :name "over there")

(define-individual 'deictic-location :name "over here")

(define-individual 'deictic-location :name "here")

(define-individual 'deictic-location :name "there")


