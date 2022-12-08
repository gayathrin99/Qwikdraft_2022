(defun replace (new old string / pos)
  (while (setq pos (vl-string-search old string pos))
    (setq string (vl-string-subst new old string pos)
	  pos	 (+ pos (strlen new))
    )
  )
  string
)

(defun c:coldet()
  (setvar "cmdecho" 0)
  (setq file (getfiled "Select the CSV file" "" "csv" 16))
  (setq lest (LM:readcsv file))
  (setq layername1 "Column")
  (setq layercolor1 "255")
  (setq layername2 "Steel")
  (setq layercolor2 "6")

  (setq restoreosmode (getvar "OSMODE"))
  (setq rectradius "0.5")
  (setq x 1)
  (length lest)
  (while (< x (length lest))
    (setq len (ATOI (nth 1 (nth X lest))))
    (princ len)
    (setq breadth (ATOI (nth 2 (nth X lest))))
    (princ breadth)

    (setq st1 (atoi (nth 3 (nth x lest))))
    (princ st1)
    (setq pt1 (getpoint "Pick the lower left corner"))
    (setq x1 (car pt1)
	  x2 (+ x1 len)
	  y1 (cadr pt1)
	  y2 (+ y1 breadth)
    )
    (setq pt2 (list x2 y1 0.0)
	  pt3 (list x2 y2 0.0)
	  pt4 (list x1 y2 0.0)
    )
    (setq rectfillet "0.5")
    (setvar "OSMODE" 0)
    (command ".layer" "n" layername1 "C" layercolor1 layername1	"")
    (command "rectang" "f" 0 pt1 pt3 "")
    (command "mtext"
	     (mapcar '+ pt1 '(0 -6 0))
	     "Height"
	     "1"
	     (mapcar '+ pt2 '(0 -1.5 0))
	     (nth 0 (nth x lest))
	     ""
    )
    (command "donut" "0.0" "1.0" (mapcar '+ pt1 '(0 -9 0)) "")
    (command "circle" (mapcar '+ pt1 '(0 -12 0)) "0.5" "")
    (command "mtext"
	     (mapcar '+ pt1 '(1 -9 0))
	     "Height"
	     "1.5"
	     (mapcar '+ pt2 '(0 -12 0))
	     (strcat (nth 3 (nth x lest)) "#" (nth 4 (nth x lest)))
	     ""
    )
    (command "mtext"
	     (mapcar '+ pt1 '(1 -12 0))
	     "Height"
	     "1.5"
	     (mapcar '+ pt2 '(0 -15 0))
	     (strcat (nth 5 (nth x lest)) "-#" (nth 6 (nth x lest)))
	     ""
    )
    (command "mtext"
	     (mapcar '+ pt2 '(5 +10 0))
	     "Height"
	     "1.5"
	     (mapcar '+ pt2 '(20 0 0))
	     (strcat (nth 9 (nth x lest)) "-" (nth 10 (nth x lest)))
	     ""
    )
    (command ".chprop" (entlast) "" "la" layername1 "")
    (command ".layer" "n" layername2 "C" layercolor2 layername2	"")
    (command "rectang"
	     "f"
	     rectfillet
	     (mapcar '+ pt1 '(0.5 0.5 0))
	     (mapcar '- pt3 '(0.5 0.5 0))
	     ""
    )
    (command ".chprop" (entlast) "" "la" layername2 "")
    (command "donut" "0.0" "1.0" (mapcar '+ pt1 '(1 1 0)) "")
    (command "donut" "0.0" "1.0" (mapcar '+ pt2 '(-1 1 0)) "")
    (command "donut" "0.0" "1.0" (mapcar '- pt3 '(1 1 0)) "")
    (command "donut" "0.0" "1.0" (mapcar '- pt4 '(-1 1 0)) "")
    (if	(and (> (atoi (nth 3 (nth x lest))) 4)
	     (= (atoi (nth 5 (nth x lest))) 0)
	)
      (progn
	(setq div (float (- (/ (atoi (nth 3 (nth x lest))) 2) 1)))
	(setq i 1)
	(while (< i div)
	  (command "donut"
		   "0.0"
		   "1.0"
		   (list (+ x1 1)
			 (+ (* y1 (float (/ i div)))
			    (* y2 (float (/ (- div i) div)))
			 )
		   )
		   ""
	  )
	  (command "donut"
		   "0.0"
		   "1.0"
		   (list (- x2 1)
			 (+ (* y1 (float (/ i div)))
			    (* y2 (float (/ (- div i) div)))
			 )
		   )
		   ""
	  )
	  (setq i (1+ i))
	)
      )
    )
    (if	(and (> (atoi (nth 3 (nth x lest))) 4)
	     (= (atoi (nth 5 (nth x lest))) 2)
	)
      (progn
	(setq div1 (float (- (/ (atoi (nth 3 (nth x lest))) 2) 1)))
	(setq j 1)
	(while (< j div1)
	  (command "donut"
		   "0.0"
		   "1.0"
		   (list (+ x1 1)
			 (+ (* y1 (float (/ j div1)))
			    (* y2 (float (/ (- div1 j) div1)))
			 )
		   )
		   ""
	  )
	  (command "donut"
		   "0.0"
		   "1.0"
		   (list (- x2 1)
			 (+ (* y1 (float (/ j div1)))
			    (* y2 (float (/ (- div1 j) div1)))
			 )
		   )
		   ""
	  )
	  (setq j (1+ j))
	)
	(if (/= (rem div1 2) 0)
	  (progn
	    (command "circle" (list (+ x1 1) (/ (+ y1 y2) 2)) "0.5" "")
	    (command "circle" (list (- x2 1) (/ (+ y1 y2) 2)) "0.5" "")
	  )
	)
	(if (= (rem div1 2) 0)
	  (progn
	    (command "circle" (list (/ (+ x1 x2) 2) (+ y1 1)) "0.5" "")
	    (command "circle" (list (/ (+ x1 x2) 2) (- y2 1)) "0.5" "")
	  )
	)
      )
    )
    (if	(and (> (atoi (nth 3 (nth x lest))) 4)
	     (= (atoi (nth 5 (nth x lest))) 4)
	)
      (progn
	(setq div2 (float (- (/ (atoi (nth 3 (nth x lest))) 2) 1)))
	(setq k 1)
	(while (< k div2)
	  (command "donut"
		   "0.0"
		   "1.0"
		   (list (+ x1 1)
			 (+ (* y1 (float (/ k div2)))
			    (* y2 (float (/ (- div2 k) div2)))
			 )
		   )
		   ""
	  )
	  (command "donut"
		   "0.0"
		   "1.0"
		   (list (- x2 1)
			 (+ (* y1 (float (/ k div2)))
			    (* y2 (float (/ (- div2 k) div2)))
			 )
		   )
		   ""
	  )
	  (setq k (1+ k))
	)
	(if (= (rem div2 2) 0)
	  (progn
	    (command "circle" (list (/ (+ x1 x2) 2) (+ y1 1)) "0.5" "")
	    (command "circle" (list (/ (+ x1 x2) 2) (- y2 1)) "0.5" "")
	    (command "circle" (list (+ x1 1) (/ (+ y1 y2) 2)) "0.5" "")
	    (command "circle" (list (- x2 1) (/ (+ y1 y2) 2)) "0.5" "")
	  )
	)
	(if (/= (rem div2 2) 0)
	  (progn
	    (command "circle"
		     (list (+ (* x1 0.25) (* x2 0.75)) (+ y1 1))
		     "0.5"
		     ""
	    )
	    (command "circle"
		     (list (+ (* x1 0.75) (* x2 0.25)) (+ y1 1))
		     "0.5"
		     ""
	    )
	    (command "circle"
		     (list (+ (* x1 0.25) (* x2 0.75)) (- y2 1))
		     "0.5"
		     ""
	    )
	    (command "circle"
		     (list (+ (* x1 0.75) (* x2 0.25)) (- y2 1))
		     "0.5"
		     ""
	    )
	  )
	)
      )
    )
    (if	(and (> (atoi (nth 3 (nth x lest))) 4)
	     (= (atoi (nth 5 (nth x lest))) 6)
	)
      (progn
	(setq div3 (float (- (/ (atoi (nth 3 (nth x lest))) 2) 1)))
	(setq g 1)
	(while (< g div3)
	  (command "donut"
		   "0.0"
		   "1.0"
		   (list (+ x1 1)
			 (+ (* y1 (float (/ k div2)))
			    (* y2 (float (/ (- div2 k) div2)))
			 )
		   )
		   ""
	  )
	  (command "donut"
		   "0.0"
		   "1.0"
		   (list (- x2 1)
			 (+ (* y1 (float (/ k div2)))
			    (* y2 (float (/ (- div2 k) div2)))
			 )
		   )
		   ""
	  )
	  (setq k (1+ k))
	)
	(if (= (rem div2 2) 0)
	  (progn
	    (command "circle" (list (/ (+ x1 x2) 2) (+ y1 1)) "0.5" "")
	    (command "circle" (list (/ (+ x1 x2) 2) (- y2 1)) "0.5" "")
	    (command "circle" (list (+ x1 1) (/ (+ y1 y2) 2)) "0.5" "")
	    (command "circle" (list (- x2 1) (/ (+ y1 y2) 2)) "0.5" "")
	  )
	)
	(if (/= (rem div2 2) 0)
	  (progn
	    (command "circle"
		     (list (+ (* x1 0.25) (* x2 0.75)) (+ y1 1))
		     "0.5"
		     ""
	    )
	    (command "circle"
		     (list (+ (* x1 0.75) (* x2 0.25)) (+ y1 1))
		     "0.5"
		     ""
	    )
	    (command "circle"
		     (list (+ (* x1 0.25) (* x2 0.75)) (- y2 1))
		     "0.5"
		     ""
	    )
	    (command "circle"
		     (list (+ (* x1 0.75) (* x2 0.25)) (- y2 1))
		     "0.5"
		     ""
	    )
	  )
	)
      )
    )
    (setq x (+ x 1))
  )
  (command ".zoom" "e" "")
  (command ".qsave")
  (setvar "cmdecho" 1)
  (if (< 20221130 (getvar "cdate"))
    (progn
      (princ "\n*** This version of Qwikdraft software has expired***")
      (exit)
      )
    )
 )

