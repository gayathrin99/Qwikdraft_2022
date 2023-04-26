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
  (if (< 20230130 (getvar "cdate"))
    (progn
      (princ "\n*** This version of Qwikdraft software has expired***")
      (exit)
      )
    )
  (progn
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
  
  ;;(princ letf)
  (setq layername1 "Footing")
  (setq layercolor1 "255")
  (setq layercolor2 "6")
  (setq a 1)
  (setq c (getint "What is the cover for steel?(in mm)"))
  (setq drawing (getfiled "Select the reference drawing from the downloaded \"Footing Details\" file" "" "dwg" 16))
  (setq textheight (getint "What is the text height? (in mm)"))
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
    (command "dimlinear"
	     pt1 pt4
	     (mapcar '+ pt1 (list 0 -1000 0))
	     ""
	     )
    (command "dimlinear"
	     pt4 pt3
	     (mapcar '+ pt4 (list 0 1000 0))
	     "")
    (command "mtext"
	     (mapcar '+ pt1 (list 0 (* textheight -8) 0))
	     "_justify" "MC"
	     "_Height"
	     textheight
	     (mapcar '+ pt2 (list 0 (* textheight -4) 0))
	     (strcat "FOOTING - F" (itoa a))
	     ""
    )
    (command "mtext"
	     (mapcar '+ pt1 (list 0 (* textheight -12) 0))
	     "_justify" "MC"
	     "_Height"
	     textheight
	     (mapcar '+ pt2 (list 0 (* textheight -6) 0))
	     (strcat "Top steel along " (nth 0 (nth a letf)) " mm side is " (nth 3 (nth a letf)) "mm at " (nth 4 (nth a letf)) " mm spacing")
	     ""
    )
    (command "mtext"
	     (mapcar '+ pt1 (list 0 (* textheight -16) 0))
	     "_justify" "MC"
	     "_Height"
	     textheight
	     (mapcar '+ pt2 (list 0 (* textheight -8) 0))
	     (strcat "Bottom steel along " (nth 0 (nth a letf)) " mm side is " (nth 5 (nth a letf)) "mm at " (nth 6 (nth a letf)) " mm spacing")
	     ""
    )
    (command "mtext"
	     (mapcar '+ pt1 (list 0 (* textheight -22) 0))
	     "_justify" "MC"
	     "_Height"
	     textheight
	     (mapcar '+ pt2 (list 0 (* textheight -12) 0))
	     (strcat "Top steel along " (nth 1 (nth a letf)) " mm side is " (nth 7 (nth a letf)) "mm at " (nth 8 (nth a letf)) " mm spacing")
	     ""
    )
    (command "mtext"
	     (mapcar '+ pt1 (list 0 (* textheight -28) 0))
	     "_justify" "MC"
	     "_Height"
	     textheight
	     (mapcar '+ pt2 (list 0 (* textheight -16) 0))
	     (strcat "Bottom steel along " (nth 1 (nth a letf)) " mm side is " (nth 9 (nth a letf)) "mm at " (nth 10 (nth a letf)) " mm spacing")
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
    (command "line" (mapcar '+ pt1 (list 0 (* d -10) 0)) (mapcar '+ pt1 (list 0 (* d -9) 0)) "")
    (command "line" (mapcar '+ pt1 (list 0 (* d -9) 0)) (mapcar '+ pt1 (list (/ l 2) (* d -10) 0) (list -100 d 0)) "")
    (command "line" (mapcar '+ pt1 (list (/ l 2) (* d -10) 0) (list -100 d 0)) (mapcar '+ pt1 (list (/ l 2) (* d -5) 0 ) (list -100 d 0)) "")
    (command "line" (mapcar '+ pt1 (list 0 (* d -10) 0) (list (+ (/ l 2) 100) d 0)) (mapcar '+ pt1 (list 0 (* d -10) 0) (list l d 0)) "")
    (command "line" (mapcar '+ pt1 (list 100 (* d -10) 0) (list (/ l 2) d 0)) (mapcar '+ pt1 (list 100 (* d -5) 0) (list (/ l 2) d 0)) "")
    (command "line" (mapcar '+ pt1 (list l (* d -10) 0)) (mapcar '+ pt1 (list 0 (* d -9) 0) (list l 0 0)) "")
    (command "_.INSERT" drawing (mapcar '+ pt1 (list (/ l 2) (* d -5) 0) (list -100 d 0)) "1.5" "1.5" "" "")
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
    (command "line" (mapcar '+ pt1 (list 0 (* d -10) 0) (list c c 0)) (mapcar '+ pt1 (list 0 (* d -9) 0) (list c (- c) 0)) "")
    (command "chprop" (entlast) "" "LTScale" "10" "" "Color" "6" "")
    (command "line" (mapcar '+ pt1 (list 0 (* d -10) 0) (list c c 0)) (mapcar '+ pt1 (list l (* d -10) 0) (list c c 0)) "")
    (command "chprop" (entlast) "" "LTScale" "10" "" "Color" "6" "")
    (command "line" (mapcar '+ pt1 (list 0 (* d -9) 0) (list c (- c) 0)) (mapcar '+ pt1 (list l (* d -9) 0) (list (- c) (- c) 0)) "")
    (command "chprop" (entlast) "" "LTScale" "10" "" "Color" "6" "")
    (command "line" (mapcar '+ pt1 (list (/ l 2) (* d -10) 0) (list -100 d 0) (list c 0 0)) (mapcar '+ pt1 (list (/ l 2) (* d -5) 0 ) (list -100 d 0) (list c c 0)) "")
    (command "chprop" (entlast) "" "LTScale" "10" "" "Color" "6" "")
    (command "line" (mapcar '+ pt1 (list 100 (* d -10) 0) (list (/ l 2) d 0) (list (- c) 0 0)) (mapcar '+ pt1 (list 100 (* d -5) 0) (list (/ l 2) d 0) (list (- c) 0 0)) "")
    (command "chprop" (entlast) "" "LTScale" "10"  "" "Color" "6" "")
    (command "line" (mapcar '+ pt1 (list l (* d -10) 0) (list (- c) c 0)) (mapcar '+ pt1 (list 0 (* d -9) 0) (list l 0 0) (list (- c) (- c) 0)) "")
    (command "chprop" (entlast) "" "LTScale" "10" "" "Color" "6" "")
    (setq i 0)
    (setq dd (/ (atoi (nth 2 (nth a letf))) 10))
    (setq dc (+ (/ dd 2) c))
    (while (< (* i (atoi (nth 4 (nth a letf)))) (- (atoi (nth 1 (nth a letf)))(* 2 dd)))
      (progn
	(command "donut" "0.0" dd (mapcar '+ pt1 (list 0 (* d -10) 0) (list dc dc 0) (list (* i (atoi (nth 4 (nth a letf)))) 0 0)) "")
	(command "donut" "0.0" dd (mapcar '+ pt1 (list 0 (* d -9) 0) (list dc (- dc) 0) (list (* i (atoi (nth 4 (nth a letf)))) 0 0)) "")
	(setq i (1+ i))
	)
      )
    (setq j 0)
    (while (< (* j 150) (* d 5))
      (command "line" (mapcar '+ pt1 (list (+ (/ l 2) -100) (* d -9) 0) (list 0 (* j 150) 0) (list (/ c 2) 0 0))
	       (mapcar '+ pt1 (list (+ (/ l 2) 100) (* d -9) 0) (list 0 (* j 150) 0) (list (/ (- c) 2) 0 0))
	       "")
      (setq j (1+ j))
      )
    
    (setq a (1+ a))
  )
)
  )
