(defun qd:numbers-in-a-string (str)
  (vl-list->string
    (vl-remove-if-not
      'num-char-p
      (vl-string->list str)
    )
  )
)
(defun num-char-p (num)
  (<= 48 num 57)
)

(defun c:footdet ()
  (setvar "cmdecho" 0)
  (setq restoreosmode (getvar "osmode"))
  (setvar "INSUNITS" 4)
    (setq	file (getfiled "Select the CSV file with Footing details"
    ""
    "csv"
    16
    )
   )
  
  (setq letf (LM:readcsv file))
  
  (princ letf)
  (setq layername1 "Footing")
  (setq layercolor1 "255")
  (setq layercolor2 "6")
  (command "_.INSERT" "~/Footing reference.dwg" '(0 0 0) "1" "1" "" "")
  (command-s)
  (setq a 1)
  (setq c (getint "What is the cover for steel?"))
  (while (< a (length letf))
    (setq l (atoi (nth 0 (nth a letf))))
    (setq b (atoi (nth 1 (nth a letf))))
    (setq d (atoi (nth 2 (nth a letf))))
    (setq pt1 (getpoint "Pick a point"))
    (setq x1 (car pt1)
	  y1 (cadr pt1)
	  x2 (+ x1 l)
	  y2 (+ y1 b)
    )
    (setq pt2 (list x2 y1 0.0)
	  pt3 (list x2 y2 0.0)
	  pt4 (list x1 y2 0.0)
    )
    (setvar "osmode" 0)
    (command ".layer" "n" layername1 "C" layercolor1 layername1	"")
    (command "rectang" "f" 0 pt1 pt3 "")
    (command "chprop" (entlast) "" "Color" "Green" "")
    (command "line"
	     (mapcar '+ pt1 (list c c 0) (list 0 (* 0.25 b) 0))
	     (mapcar '+ pt2 (list (- c) c 0) (list 0 (* 0.25 b) 0))
	     ""
    )
    (command "chprop"
	     (entlast)
	     ""
	     "LT"
	     "DASHED"
	     ""
	     "LTScale"
	     "15"
	     ""
    )
    (command "line"
	     (mapcar '+ pt1 (list c c 0) (list 0 (* 0.25 b) 0))
	     (mapcar '+
		     pt1
		     (list c c 0)
		     (list 0 (+ (* 0.25 b) (* c 5)) 0)
	     )
	     ""
    )
    (command "chprop"
	     (entlast)
	     ""
	     "LT"
	     "DASHED"
	     ""
	     "LTScale"
	     "15"
	     ""
    )
    (command "line"
	     (mapcar '+ pt2 (list (- c) c 0) (list 0 (* 0.25 b) 0))
	     (mapcar '+
		     pt2
		     (list (- c) c 0)
		     (list 0 (+ (* 0.25 b) (* c 5)) 0)
	     )
	     ""
    )
    (command "chprop"
	     (entlast)
	     ""
	     "LT"
	     "DASHED"
	     ""
	     "LTScale"
	     "15"
	     ""
    )
    (command "line"
	     (mapcar '+ pt1 (list c c 0) (list (* 0.25 l) 0 0))
	     (mapcar '+ pt4 (list c (- c) 0) (list (* 0.25 l) 0 0))
	     ""
    )
    (command "chprop"
	     (entlast)
	     ""
	     "LT"
	     "DASHED"
	     ""
	     "LTScale"
	     "15"
	     ""
    )
    (command "line"
	     (mapcar '+ pt1 (list c c 0) (list (* 0.25 l) 0 0))
	     (mapcar '+
		     pt1
		     (list c c 0)
		     (list (+ (* 0.25 l) (* c 5)) 0 0)
	     )
	     ""
    )
    (command "chprop"
	     (entlast)
	     ""
	     "LT"
	     "DASHED"
	     ""
	     "LTScale"
	     "15"
	     ""
    )
    (command "line"
	     (mapcar '+ pt4 (list c (- c) 0) (list (* 0.25 l) 0 0))
	     (mapcar '+
		     pt4
		     (list c (- c) 0)
		     (list (+ (* 0.25 l) (* c 5)) 0 0)
	     )
	     ""
    )
    (command "chprop"
	     (entlast)
	     ""
	     "LT"
	     "DASHED"
	     ""
	     "LTScale"
	     "15"
	     ""
    )
    (command "line"
	     (mapcar '+ pt2 (list (- c) c 0) (list (* -0.25 l) 0 0))
	     (mapcar '+ pt3 (list (- c) (- c) 0) (list (* -0.25 l) 0 0))
	     ""
    )
    (command "line"
	     (mapcar '+ pt2 (list (- c) c 0) (list (* -0.25 l) 0 0))
	     (mapcar '+
		     pt2
		     (list (- c) c 0)
		     (list (* -0.25 l) 0 0)
		     (list (* c -5) 0 0)
	     )
	     ""
    )
    (command "line"
	     (mapcar '+ pt3 (list (- c) (- c) 0) (list (* -0.25 l) 0 0))
	     (mapcar '+
		     pt3
		     (list (- c) (- c) 0)
		     (list (* -0.25 l) 0 0)
		     (list (* c -5) 0 0)
	     )
	     ""
    )
    (command "line"
	     (mapcar '+ pt4 (list c (- c) 0) (list 0 (* -0.25 b) 0))
	     (mapcar '+ pt3 (list (- c) (- c) 0) (list 0 (* -0.25 b) 0))
	     ""
    )
    (command "line"
	     (mapcar '+ pt4 (list c (- c) 0) (list 0 (* -0.25 b) 0))
	     (mapcar '+
		     pt4
		     (list c (- c) 0)
		     (list 0 (* -0.25 b) 0)
		     (list 0 (* c -5) 0)
	     )
	     ""
    )
    (command "line"
	     (mapcar '+ pt3 (list (- c) (- c) 0) (list 0 (* -0.25 b) 0))
	     (mapcar '+
		     pt3
		     (list (- c) (- c) 0)
		     (list 0 (+ (* -0.25 b) (* c -5)) 0)
	     )
	     ""
    )
    (command "rectang"
	     "f"
	     0
	     (mapcar '+ pt1 '(-100 -100 0))
	     (mapcar '+ pt3 '(100 100 0))
	     ""
    )
    (command "chprop"
	     (entlast)
	     ""
	     "LT"
	     "DASHED"
	     ""
	     "LTScale"
	     "10"
	     ""
    )
    (command "chprop" "" "LT" "DASHED" "" "S" "100" "" "Color" "White"
	     "")
    (command "line" (mapcar '+ pt1 (list 0 (* d -10) 0)) (mapcar '+ pt1 (list 0 (* d -10) 0) (list 0 d 0)) "")
    (command "line" (mapcar '+ pt1 (list 0 (* d -10) 0) (list 0 d 0)) (mapcar '+ pt1 (list (/ l 2) (* d -10) 0) (list -100 d 0)) "")
    (command "line" (mapcar '+ pt1 (list (/ l 2) (* d -10) 0) (list -100 d 0)) (mapcar '+ pt1 (list (/ l 2) (* d -5) 0 ) (list -100 d 0)) "")
    (command "line" (mapcar '+ pt1 (list 0 (* d -10) 0) (list (+ (/ l 2) 100) d 0)) (mapcar '+ pt1 (list 0 (* d -10) 0) (list l d 0)) "")
    (command "line" (mapcar '+ pt1 (list 0 (* d -10) 0) (list l d 0)) (mapcar '+ pt1 (list 0 (* d -5) 0) (list l d 0)) "")
    (command "line" (mapcar '+ pt1 (list l (* d -10) 0)) (mapcar '+ pt1 (list 0 (* d -10) 0) (list l d 0)) "")
    (command
      "rectang"
      "f"
      0
      (mapcar '+ pt1 (list 0 (* d -10) 0.0) '(-100 -100 0.0))
      (mapcar '+
	      pt1
	      (list 0 (* d -10) 0.0)
	      (list l 0 0.0)
	      '(100 0 0.0)
      )
      ""
    )    
    (setq a (1+ a))
  )
)
