;;; -*- Mode:LISP; Syntax:Common-Lisp; Package:SPARSER -*-
;;; copyright (c) 1992,1993,1994  David D. McDonald  -- all rights reserved
;;;
;;;     File:  "edge resource"
;;;   Module:  "grammar;tests:"
;;;  version:  1.0  January 1991       v1.6

(in-package :sparser)

#|
;;;----------------------
;;; setting up the rules
;;;----------------------

#|  The precise-version of the stress tests should be done with a
precisely controlled grammar, so I'm putting in all the rules that
should effect these test cases/files right here  |#


#|  with no grammar defined beyond the base model for Who's News
circa 11/15:

? (p "the Japanese media")
the Japanese media 
NIL
? (the-edges)
#<edge0 1 the 2>
*ALL-EDGES*
? |#

(def-cfr <japanese> ("Japanese"))
(def-cfr <the-japanese> ("the" <japanese>))

(def-cfr <media> ("media"))
(def-cfr <japanese-media> (<japanese> <media>))

#|  after these rules are added:
? (p "the Japanese media")
the Japanese media 
NIL
? (the-edges)
#<edge0 1 the 2>
#<edge1 2 <JAPANESE> 3>
#<edge2 1 <THE-JAPANESE> 3>
#<edge3 3 <MEDIA> 4>
#<edge4 2 <JAPANESE-MEDIA> 4>
*ALL-EDGES*
? |#

(defun 20edges ()
  (p "the Japanese media aa
the Japanese media aa
the Japanese media aa
the Japanese media aa"))

(defun 50edges ()
  (p "the Japanese media aa
the Japanese media
the Japanese media
the Japanese media aa
the Japanese media aa
the Japanese media
the Japanese media aa
the Japanese media aa
the Japanese media aa
the Japanese media"))


; (setq *length-of-edge-resource* 12)
; (setq *index-of-furthest-edge-ever-allocated* 12)
;;  12 will wrap it in the middle of the third pass
;;  through the repeating phrase

; (progn (make-the-edge-array-resource) :done)

; (setq *trace-readout* t)
; (setq *trace-readout* nil)

; (20e)

;;;---------
;;; history
;;;---------
#|
;;-------------------- 12/13/90

;;;----------------- routines with no unknown words between the
;;;                  parsable phrases
(defun 20e ()
  (p "the Japanese media
the Japanese media
the Japanese media
the Japanese media"))

(defun 50e ()
  (p "the Japanese media
the Japanese media
the Japanese media
the Japanese media
the Japanese media
the Japanese media
the Japanese media
the Japanese media
the Japanese media
the Japanese media"))

  This set picks up flaws in the readout mechanism that might 
be ignored because this style of test string is so unnatural,
but then it would be nicer if they didn't have to be.
   The problem is that the readout mechanism needs a definitive
criteria to tell it when the set of unreadout edges to its left
will definitively not be further extended by later edges parsed to
the right of the present position.
   A clean criteria, if not always easily met, is to see an
unknown word.  The other definitive case is reaching the end of
the text.  In the run below, readout didn't start until the end
of the text was reached, by which time the first instance of the
phrase had had its edges reused and so was lost.  This kind of
behavior is worked around (if that's the right characterization
of what one should do) by making the edge resource longer --- indeed,
the correct model for the proper length of the resource is that
it should be just longer than the number of edges needed to carry
the phrases of the longest continuous, definitively terminated,
phrase that the grammar will produce.

? (20e)
the Japanese media
the Japanese media
the Japanese media
the Japanese media 
Reading out #<edge9 5 <JAPANESE-MEDIA> 7>
Reading out #<edge10 7 the 8>
Reading out #<edge2 8 <JAPANESE-MEDIA> 10>
Reading out #<edge3 10 the 11>
Reading out #<edge7 11 <JAPANESE-MEDIA> 13>
NIL

   Running the (50e) case you get only two instance of the possible
three still in the chart because of how the fencepost case is
tested.  That tests fixes an infinite loop that was what the code
did before this. 


   When running with the unknown words inserted, (20edges) works
fine, as one would expect. (50e) has a stretch of two lines of
toplevel phrases without an interveening unknown word; here the
first of these is misses since three phrases accumulate before there
is any readout and this blows by an edge resource of length 12 just
as described just above.  A later case where only one line goes 
without works fine.


; (setq *length-of-edge-resource* 30)
; (setq *index-of-furthest-edge-ever-allocated* 30)
; (progn (make-the-edge-array-resource) :done)

   Running at length 30 you get the "two lines uninterrupted" to
work fine, as one would predict.  But the parser goes into a loop
in the sixth line of the routine (which does not end with "aa")
where it should have gone on and scanned the next line.

; (setq *length-of-edge-resource* 60)
; (setq *index-of-furthest-edge-ever-allocated* 60)
; (progn (make-the-edge-array-resource) :done)

At 60 edges the infinite loop doesn't occur.

The length of the edge resource doesn't seem to be the issue since
the hangup is down at edge 18 (as passed to Next-edge-that-is-active)
or at edge28 (as the edge-just-done).


; (setq *length-of-edge-resource* 33)
; (setq *index-of-furthest-edge-ever-allocated* 33)
; (progn (make-the-edge-array-resource) :done)

Nope, the length must matter, since at 33 we just scan two more
words than at 30 and then it loops.


; (setq *length-of-edge-resource* 40)
; (setq *index-of-furthest-edge-ever-allocated* 40)
; (progn (make-the-edge-array-resource) :done)

Gets through two more lines and then loops.

; (setq *length-of-edge-resource* 41)
; (setq *index-of-furthest-edge-ever-allocated* 41)
; (progn (make-the-edge-array-resource) :done)

Gets two more words scanned.


;;--------- looking for a shorter case that gets a loop

(defun 20edges1 ()
  (p "the Japanese media aa
the Japanese media aa
the Japanese media aa
the Japanese media aa"))

; (setq *length-of-edge-resource* 12)
; (setq *index-of-furthest-edge-ever-allocated* 12)
;;  12 will wrap it in the middle of the third pass
;;  through the repeating phrase
; (progn (make-the-edge-array-resource) :done)

(defun 20edges2 ()
  (p "the Japanese media aa
the Japanese media
the Japanese media aa
the Japanese media aa"))   ;;finishes, but doesn't readout the 2d

(defun 20edges3 ()
  (p "the Japanese media aa
the Japanese media aa
the Japanese media 
the Japanese media aa"))  ;;finishes and gets them all


; (setq *length-of-edge-resource* 10)
; (setq *index-of-furthest-edge-ever-allocated* 10)
;;  10 will wrap it just before the third pass
;;  through the repeating phrase
; (progn (make-the-edge-array-resource) :done)

---this gets the loop bug on 20edges3

;;----------- 12/14

  Fixed.  Was a sleeping fence post case from the last episode of work on
this resource inside the Allocation routine.

  The fix revealed a presumption in the readout routine that it wouldn't
hit an edge not in use except in the last phase of the edge-wrap state
transitions.  --Fixed (patched?) it by looking for the resource-center
edge (not in use) outside of those state checks and returning out of the
accumulation loop when it occurs.  /// It seems like this could cause some
(many? only one?) edges to not be readout. Since the state space is already
sufficiently complex to make me concerned about brittleness (especially
since the complexity was all motivated by tests on a drastically shrunk
resource) that I'm inclined to change the algorithm before trying more
variations on the present alg.   --> needs a good auto-test on realistic
size data to get a better evaluation.  /// A good variation might be to
find more points that force readout (the way EOS presently does), maybe
period or comma when it occurs as a treetop?

   50edges proceeded to blow up the parser on a 10 edge resource.  The 
problem was a missing case in Next-edge-from-resource to cover the resource
wrapping more than one time.

; (setq *length-of-edge-resource* 30)
; (setq *index-of-furthest-edge-ever-allocated* 30)
; (progn (make-the-edge-array-resource) :done)

   The 'two lines uninterrupted' readout failure (one line's phrase
not appearing) occurs at length 10, but not as length 30, as expected
from the work earlier.


|#
|#
