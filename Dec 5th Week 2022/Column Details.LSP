(princ "Enter \'COLDET\' into the command line")
(defun c:coldet()
  (if (< 20230430 (getvar "cdate"))
    (progn
      (princ "\n*** This version of Qwikdraft software has expired***")
      (exit)
      )
    (progn
   (setvar "INSUNITS" 4)
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
  (setq textheight (getint "Enter the height of text"))
   (setq c (getreal "Enter the cover for steel"))
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
    (setq dd (/ len 10.0))
    (setq dc (+ (/ dd 2) c))
    (setvar "OSMODE" 0)
    (command ".layer" "n" layername1 "C" layercolor1 layername1	"")
    (command "rectang" "f" 0 pt1 pt3 "")
    (command "mtext"
	     (mapcar '+ pt1 (list 0 (* textheight -4) 0))
	     "Height"
	     textheight
	     (mapcar '+ pt2 (list 0 (* textheight -1) 0))
	     (nth 0 (nth x lest))
	     ""
    )
    (command "donut" "0.0" dd (mapcar '+ pt1 (list 0 (* textheight -5) 0)) "")
    (command "circle" (mapcar '+ pt1 (list 0 (* textheight -8) 0)) dd "")
    (command "mtext"
	     (mapcar '+ pt1 (list 3 (* textheight -7) 0))
	     "_justify" "MC"
	     "_Height" textheight
	     (mapcar '+ pt2 (list 0 (* textheight -3) 0))
	     (strcat (nth 3 (nth x lest)) "#" (nth 4 (nth x lest)))
	     ""
    )
    (command "mtext"
	     (mapcar '+ pt1 (list 3 (* textheight -10) 0))
	     "_justify" "MC"
	     "_Height"
	     textheight
	     (mapcar '+ pt2 (list 0 (* textheight -5) 0))
	     (strcat (nth 5 (nth x lest)) "-#" (nth 6 (nth x lest)))
	     ""
    )
    ;|(command "_.mtext"
	     (mapcar '+ pt1 '(0 +10 0))
	     "_justify" "MC"
	     "_Height" textheight
	     (mapcar '+ pt2 (list 0 (+ -10 (- textheight)) 0))
	     (strcat (nth 3 (nth x lest)) "-" (nth 4 (nth x lest)))
	     ""
    )|;
    (command ".chprop" (entlast) "" "la" layername1 "")
    (command ".layer" "n" layername2 "C" layercolor2 layername2	"")
    (command "rectang"
	     "f"
	     rectfillet
	     (mapcar '+ pt1 (list c c 0))
	     (mapcar '- pt3 (list c c
				  0))
	     ""
    )
    ;;dd is donut diameter
    (command ".chprop" (entlast) "" "la" layername2 "")
    (command "donut" "0.0" dd (mapcar '+ pt1 (list dc dc 0)) "")
    (command "donut" "0.0" dd (mapcar '+ pt2 (list (- dc) dc 0)) "")
    (command "donut" "0.0" dd (mapcar '- pt3 (list dc dc 0)) "")
    (command "donut" "0.0" dd (mapcar '- pt4 (list (- dc) dc 0)) "")
    (setq div1 (- (/ (atoi (nth 3 (nth x lest))) 2) 1.0))
    (setq div2 (/ (atoi (nth 5 (nth x lest))) 2.0))
    (if (eq (rem div1 2) 0)
      (progn
	(setq i 1)
	(while (< i div1)
	  (command "donut" "0.0" dd (mapcar '+ pt1 (list dc (+ dc (* (/ i div1) (- (atoi (nth 2 (nth x lest))) (* 2 dc)))) 0)) "")
	  (command "donut" "0.0" dd (mapcar '+ pt2 (list (- dc) (+ dc (* (/ i div1) (- (atoi (nth 2 (nth x lest))) (* 2 dc)))) 0)) "")
	  (if (eq div1 div2)
	    (progn
	      (setq q 1)
	      (while (<= q (* div2 2))
	    (command "circle" (mapcar '+ pt1 (list dc (+ dc (* (/ q (* div2 2)) (- (atoi (nth 2 (nth x lest))) (* 2 dc)))) 0)) (/ dd 2) "")
	    (command "circle" (mapcar '+ pt2 (list (- dc) (+ dc (* (/ q (* div2 2)) (- (atoi (nth 2 (nth x lest))) (* 2 dc)))) 0)) (/ dd 2) "")
		(setq q (+ q 2))
	    )
	    )
	    )
	  (if (< div1 div2)
	    (progn
	      (setq j 1)
	      (while (<= j (* div2 2))
	      (command "circle" (mapcar '+ pt1 (list dc (+ dc (* (/ j (* div1 2)) (- (atoi (nth 2 (nth x lest))) (* 2 dc)))) 0)) (/ dd 2) "")
	      (command "circle" (mapcar '+ pt2 (list (- dc) (+ dc (* (/ j (* div1 2)) (- (atoi (nth 2 (nth x lest))) (* 2 dc)))) 0)) (/ dd 2) "")
		(setq j (+ j 2))
		)
	      (setq q 1)
	      (while (<= q (- div2 div1))
		  (command "circle" (mapcar '+ pt1 (list (+ dc (* (/ q (- div2 div1 -1)) (- (atoi (nth 1 (nth x lest))) (* 2 dc)))) dc 0)) (/ dd 2) "")
		  (command "circle" (mapcar '+ pt4 (list (+ dc (* (/ q (- div2 div1 -1)) (- (atoi (nth 1 (nth x lest))) (* 2 dc)))) (- dc) 0)) (/ dd 2) "")
		  (setq q (1+ q))
		  )
	      )
	    )
	  (if (> div1 div2)
	    (progn
	      (setq j 1)
	      (while (<= j div2)
		(command "circle" (mapcar '+ pt1 (list (+ dc (* (/ j (+ div2 1)) (- (atoi (nth 1 (nth x lest))) (* 2 dc)))) dc 0)) (/ dd 2) "")
		(command "circle" (mapcar '+ pt4 (list (+ dc (* (/ j (+ div2 1)) (- (atoi (nth 1 (nth x lest))) (* 2 dc)))) (- dc) 0)) (/ dd 2) "")
		(setq j (1+ j))
		)
	      )
	    )
	  (setq i (1+ i))  	   
	  )
	)
      (progn
	(setq i 1)
	(while (< i div1)
	  (command "donut" "0.0" dd (mapcar '+ pt1 (list dc (+ dc (* (/ i div1) (- (atoi (nth 2 (nth x lest))) (* 2 dc)))) 0)) "")
	  (command "donut" "0.0" dd (mapcar '+ pt2 (list (- dc) (+ dc (* (/ i div1) (- (atoi (nth 2 (nth x lest))) (* 2 dc)))) 0)) "")
	  (if (eq div1 div2)
	    (progn
	      (setq q 1)
	      (while (<= q (* div2 2))
	    (command "circle" (mapcar '+ pt1 (list dc (+ dc (* (/ q div2) (- (atoi (nth 2 (nth x lest))) (* 2 dc)))) 0)) (/ dd 2) "")
	    (command "circle" (mapcar '+ pt2 (list (- dc) (+ dc (* (/ q div2) (- (atoi (nth 2 (nth x lest))) (* 2 dc)))) 0)) (/ dd 2) "")
		(setq q (+ q 2))
	    )
	    )
	    )
	  (if (< div1 div2)
	    (progn
	      (setq j 1)
	      (while (<= j div2)
	      (command "circle" (mapcar '+ pt1 (list dc (+ dc (* (/ i div1) (- (atoi (nth 2 (nth x lest))) (* 2 dc)))) 0)) (/ dd 2) "")
	      (command "circle" (mapcar '+ pt2 (list (- dc) (+ dc (* (/ i div1) (- (atoi (nth 2 (nth x lest))) (* 2 dc)))) 0)) (/ dd 2) "")
		(setq q 1)
		(while (<= q (- div2 div1))
		  (command "circle" (mapcar '+ pt1 (list (+ dc (* (/ q (- div2 div1 -1)) (- (atoi (nth 1 (nth x lest))) (* 2 dc)))) dc 0)) (/ dd 2) "")
		  (command "circle" (mapcar '+ pt4 (list (+ dc (* (/ q (- div2 div1 -1)) (- (atoi (nth 1 (nth x lest))) (* 2 dc)))) (- dc) 0)) (/ dd 2) "")
		  (setq q (1+ q))
		  )
		(setq j (+ j 2))
		)
	      )
	    )
	  (if (> div1 div2)
	    (progn
	      (setq j 1)
	      (while (<= j div2)
		(command "circle" (mapcar '+ pt1 (list (+ dc (* (/ j (+ div2 1)) (- (atoi (nth 1 (nth x lest))) (* 2 dc)))) dc 0)) (/ dd 2) "")
		(command "circle" (mapcar '+ pt4 (list (+ dc (* (/ j (+ div2 1)) (- (atoi (nth 1 (nth x lest))) (* 2 dc)))) (- dc) 0)) (/ dd 2) "")
		(setq j (1+ j))
		)
	      )
	    )	  
	(setq i (1+ i))
	)
	
      )
    )
    
    (setq x (+ x 1))
  	(command ".qsave")
   (setvar "cmdecho" 1)
  )
  
  
 )
  )
  )

