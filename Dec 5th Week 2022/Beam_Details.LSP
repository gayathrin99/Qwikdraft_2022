(princ "Type \"BEAMDET\" into the command line")
(defun c:beamdet ()
      (setvar "cmdecho" 0)
      (setq restoreosmode (getvar "osmode"))
      (setvar "INSUNITS" 4)
      (setq unit
	     (getstring "Is the drawings in Foot & inches system?(y/n)")
      )
      (if (or (eq unit "y") (eq unit "Y"))
	(setq u 1)
	(setq u 0)
      )
      (princ u)
      (setq beamnum (getint "How many continous beams in total?"))
      (setq a 1)
      (while (<= a beamnum)
	(alert "Select the end points of the continous beam")
	(setq p1 (getpoint "Select the starting point of the continous beam"))
	(setq p2 (getpoint "Select the end point of the continous beam"))
	(setq span (distance p1 p2))
	(princ span)
	(setvar "osmode" 0)
	(setq layername1 "Beamdetails")
	(setq layercolor1 "255")
	(setq layername2 "Beamsteel")
	(setq layercolor2 "6")
	(setq d (getdist "Enter the depth of the beam"))
	(setq b1 (getpoint "Pick a point outside"))
	(setq x1 (car b1)
	      x2 (+ x1 span)
	      y1 (cadr b1)
	      y2 (+ y1 d)
	)
	(setq b2 (list x2 y1 0.0)
	      b3 (list x2 y2 0.0)
	      b4 (list x1 y2 0.0)
	)
	(command ".layer" "n" layername1 "C" layercolor1 layername1 "")
	(command ".chprop" (entlast) "" "la" layername1 "")
	(command "line" b1 b2 "")
	(command "line" b2 b3 "")
	(command "line" b3 b4 "")
	(command "line" b4 b1 "")
	(setq c (float (getdist "Enter the cover for steel")))
	(command ".layer" "n" layername2 "C" layercolor2 layername2 "")
	(command "line"
		 (mapcar '+ b1 (list c c 0.0))
		 (mapcar '+ b2 (list (- c) c 0.0))
		 ""
	)
	(command ".chprop" (entlast) "" "la" layername2 "")
	(command "line"
		 (mapcar '+ b2 (list (- c) c 0.0))
		 (mapcar '+ b3 (list (- c) (- c) 0.0))
		 ""
	)
	(command ".chprop" (entlast) "" "la" layername2 "")
	(command "line"
		 (mapcar '+ b3 (list (- c) (- c) 0.0))
		 (mapcar '+ b4 (list c (- c) 0.0))
		 ""
	)
	(command ".chprop" (entlast) "" "la" layername2 "")
	(command "line"
		 (mapcar '+ b4 (list c (- c) 0.0))
		 (mapcar '+ b1 (list c c 0.0))
		 ""
	)
	(command ".chprop" (entlast) "" "la" layername2 "")
	(command "dimlinear"
		 b3
		 b2
		 (mapcar '+ b2 (list 6 0 0)) 
		 ""
		 ""
	)
	(command ".chprop" (entlast) "" "la" layername2 "")
	(setq col (getint "How many column cross this beam?"))
	(setq i 1)
	(setq sp (list))
	(alert "Select the end points of the columns in the beam")
	(setq drawing
	       (getfiled
		 "Select the reference drawing from the downloaded \"Beams Details\" file"
		 ""
		 "dwg"
		 
		 16
	       )
	)
	(while (<= i col)
	  (setq cx1 (getpoint "Select the beginning of the column"))
	  (setq cx2 (getpoint "Select the end point of the column"))
	  (setq dis1 (- (car cx1) (car p1)))
	  (setq dis2 (- (car cx2) (car cx1)))
	  (setq bx1 (mapcar '+ b1 (list dis1 0.0 0.0)))
	  (setq bx2 (mapcar '+ bx1 (list dis2 0.0 0.0)))
	  (command "line"
		   (mapcar '- bx1 (list 0.0 (* d 1.5) 0.0))
		   (mapcar '+ bx1 (list 0.0 (* d 1.5) 0.0))
		   ""
	  )
	  (command "line"
		   (mapcar '- bx2 (list 0.0 (* d 1.5) 0.0))
		   (mapcar '+ bx2 (list 0.0 (* d 1.5) 0.0))
		   ""
	  )
	  (command "_layer" "n"	layername1 "C" layercolor1 layername1 "")
	  (setq scale (/ dis2 180))
	  (command "_.INSERT"
		   drawing (mapcar '+ bx1 (list 0 (* d 1.5) 0)) scale 
		   scale 1.
	  )
	  (command "_.-INSERT"
		   drawing
		   (mapcar '+ bx1 (list 0 (* d -1.5) 0)) scale
		   scale 1.
	  )
	  (setq sp (append sp (list dis1 dis2)))
	  (setq i (1+ i))
	)
	(princ sp)
	;|(if (> (nth 0 sp) 0)
    (progn
      (command "line" (mapcar '+ b1 (list (* 2 c) (* 2 c) 0.0))
	   (mapcar '+ b4 (list (* 2 c) (* 2 (- c)) 0.0))
	   ""
  )
      (command "line" (mapcar '+ b4 (list (* 2 c) (* 2 (- c)) 0.0))
	       (mapcar '+ b4 (list (* 2 c) (* 2 (- c)) 0.0) (list (* 0.33 (nth 0 sp)) 0.0 0.0))
      "")
    
)
    )|;
	(command "line"
		 (mapcar '+ b1 (list (* 2 c) (* 2 c) 0.0))
		 (mapcar '+ b4 (list (* 2 c) (* 2 (- c)) 0.0))
		 ""
	)
	(command
	  "line"
	  (mapcar '+ b4 (list (* 2 c) (* 2 (- c)) 0.0))
	  (mapcar '+
		  b4
		  (list 0 (* 2 (- c)) 0.0)
		  (list (+ (nth 0 sp) (nth 1 sp)) 0 0)
		  (list	(qd:roundup
			  (* 0.25 (- (nth 2 sp) (nth 1 sp) (nth 0 sp)))
			  3
			)
			0
			0
		  )
	  )
	  ""
	)
	(command "dimlinear" (mapcar '+ b4 (list (+ (nth 0 sp) (nth 1 sp)) (* d 0.5) 0))
		 (mapcar '+ b4 (list (+ (nth 0 sp) (nth 1 sp) (qd:roundup
			  (* 0.25 (- (nth 2 sp) (nth 1 sp) (nth 0 sp)))
			  3
			)) 0 0))
		 (mapcar '+ b4 (list (+ (nth 0 sp) (nth 1 sp)) (* d 0.5) 80))
		 ""
		 )

		 
	(command "line"
		 (mapcar '+ b1 (list (* 3 c) (* 3 c) 0.0))
		 (mapcar '+ b4 (list (* 3 c) (* 3 (- c)) 0.0))
		 ""
	)
	(command "line"
		 (mapcar '+ b4 (list (* 3 c) (* 3 (- c)) 0.0))
		 (mapcar '+
		  b4
		  (list 0 (* 3 (- c)) 0.0)
		  (list (+ (nth 0 sp) (nth 1 sp)) 0 0)
		  (list	(qd:roundup
			  (* 0.15 (- (nth 2 sp) (nth 1 sp) (nth 0 sp)))
			  3
			)
			0
			0
		  )
	  )
		 ""
		 )
	(command "dimlinear" (mapcar '+ b4 (list (+ (nth 0 sp) (nth 1 sp)) (* d 0.25) 0))
		 (mapcar '+ b4 (list (+ (nth 0 sp) (nth 1 sp) (qd:roundup
			  (* 0.15 (- (nth 2 sp) (nth 1 sp) (nth 0 sp)))
			  3
			)) 0 0))
		 (mapcar '+ b4 (list (+ (nth 0 sp) (nth 1 sp)) (* d 0.25) 80))
		 ""
		 )

	(setq j 0)
	(while (< j (- (length sp) 4))
	  ;;(if (eq (rem j 2) 0)
	  (progn
	    (setq span1 (- (nth (+ j 2) sp) (nth (1+ j) sp) (nth j sp)))
	    (setq span2	(- (nth (+ j 4) sp)
			   (nth (+ j 3) sp)
			   (nth (+ j 2) sp)
			)
	    )
	    (princ span1)
	    (princ "\n")
	    (princ span2)
	    (if	(eq u 1)
		;|(command "line" (mapcar '+ b4 (list (* 2 c) (* 2 (- c)) 0.0) (list (- (* span1 300) (* (qd:roundup (/ (* 0.33 (* span1 300)) 1000) 0.25) 1000)) 0 0))
			      (mapcar '+ b4 (list (* 2 c) (* 2 (- c)) 0.0) (list (+ (* span2 300) (* (qd:roundup (/ (* 0.33 (* span2 300)) 1000) 0.25) 1000)) 0 0))
			      "")|;
	      (progn
		(command
		"line"
		(mapcar	'+
			b4
			(list 0 (* 2 (- c)) 0.0)
			(list (nth (+ j 2) sp) 0 0)
			(list (- (qd:roundup (* 0.25 span1) 3)) 0 0)
		)
		(mapcar	'+
			b4
			(list 0 (* 2 (- c)) 0.0)
			(list (+ (nth (+ j 2) sp) (nth (+ j 3) sp)) 0 0)
			(list (qd:roundup (* 0.25 span2) 3) 0 0)
		)
		""
	      )
		(command "dimlinear" (mapcar '+ b4 (list (- (nth (+ j 2) sp) (qd:roundup (* 0.25 span1) 3)) (* d 0.5) 0))
			 (mapcar '+ b4 (list (nth (+ j 2) sp) (* d 0.5) 0))
			 (mapcar '+ b4 (list (nth (+ j 2) sp) (* d 0.5) 0))
			 "")
		(command "dimlinear" (mapcar '+ b4 (list (+ (nth (+ j 2) sp) (nth (+ j 3) sp)) (* d 0.5) 0))
			 (mapcar '+ b4 (list (+ (nth (+ j 2) sp) (nth (+ j 3) sp) (qd:roundup (* 0.25 span2) 3)) (* d 0.5) 0))
			 (mapcar '+ b4 (list (nth (+ j 2) sp) (* d 0.5) 0))
			 "")
			 
	      (command
		"line"
		(mapcar	'+
			b4
			(list 0 (* 3 (- c)) 0.0)
			(list (nth (+ j 2) sp) 0 0)
			(list (- (qd:roundup (* 0.15 span1) 3)) 0 0)
		)
		(mapcar	'+
			b4
			(list 0 (* 3 (- c)) 0.0)
			(list (+ (nth (+ j 2) sp) (nth (+ j 3) sp)) 0 0)
			(list (qd:roundup (* 0.15 span2) 3) 0 0)
		)
		""
	      )
		(command "dimlinear" (mapcar '+ b4 (list (- (nth (+ j 2) sp) (qd:roundup (* 0.15 span1) 3)) (* d 0.25) 0))
			 (mapcar '+ b4 (list (nth (+ j 2) sp) (* d 0.25) 0))
			 (mapcar '+ b4 (list (nth (+ j 2) sp) (* d 0.25) 0))
			 "")
		(command "dimlinear" (mapcar '+ b4 (list (+ (nth (+ j 2) sp) (nth (+ j 3) sp)) (* d 0.25) 0))
			 (mapcar '+ b4 (list (+ (nth (+ j 2) sp) (nth (+ j 3) sp) (qd:roundup (* 0.15 span2) 3)) (* d 0.25) 0))
			 (mapcar '+ b4 (list (nth (+ j 2) sp) (* d 0.25) 0))
			 "")
		)
	    )
	    (if	(eq u 1)
		;|(command "line" (mapcar '+ b1 (list (* 2 c) (* 2 c) 0.0) (list (+ (* span1 300) (* (qd:rounddown (/ (* 0.15 (* span1 300)) 1000) 0.25) 1000)) 0 0.0))
	       (mapcar '+ b1 (list (* 2 c) (* 2 c) 0.0) (list (- (* span1 300) (* (qd:rounddown (/ (* 0.15 span1) 1000) 0.25) 1000)) 0 0.0))
	       "")|;
	      (progn
		(command
		  "line"
		  (mapcar '+
			  b1
			  (list 0 (* 2 c) 0)
			  (list (+ (nth j sp) (nth (1+ j) sp)) 0 0)
			  (list (qd:rounddown (* 0.15 span1) 3) 0 0)
		  )
		  (mapcar '+
			  b1
			  (list 0 (* 2 c) 0)
			  (list (nth (+ j 2) sp) 0 0)
			  (list (- (qd:rounddown (* 0.15 span1) 3)) 0 0)
		  )
		  ""
		)
		(command "dimlinear" (mapcar '+ b1 (list (+ (nth j sp) (nth (1+ j) sp)) (* d -0.5) 0))
						     (mapcar '+ b1 (list (+ (nth j sp) (nth (1+ j) sp) (qd:rounddown (* 0.15 span1) 3)) (* d -0.5) 0))
					     (mapcar '+ b1 (list (+ (nth j sp) (nth (1+ j) sp)) (* d -0.5) 0))
			 "")
		(command "dimlinear" (mapcar '+ b1 (list (- (nth (+ j 2) sp) (qd:rounddown (* 0.15 span1) 3)) (* d -0.25) 0))
					     (mapcar '+ b1 (list (nth (+ j 2) sp) (* d -0.25) 0))
			 (mapcar '+ b1 (list (nth (+ j 2) sp) (* d -0.25) 0))
			 "")			     
		(command
		  "line"
		  (mapcar
		    '+
		    b1
		    (list 0 (* 2 c) 0)
		    (list (+ (nth (+ j 2) sp) (nth (+ j 3) sp)) 0 0)
		    (list (qd:rounddown (* 0.15 span2) 3) 0 0)
		  )
		  (mapcar '+
			  b1
			  (list 0 (* 2 c) 0)
			  (list (nth (+ j 4) sp) 0 0)
			  (list (- (qd:rounddown (* 0.15 span2) 3)) 0 0)
		  )
		  ""
		)
		(command "dimlinear" (mapcar '+ b1 (list (+ (nth (+ j 3) sp) (nth (+ j 2) sp)) (* d -0.5) 0))
						     (mapcar '+ b1 (list (+ (nth (+ j 3) sp) (nth (+ j 2) sp) (qd:rounddown (* 0.15 span2) 3)) (* d -0.5) 0))
					     (mapcar '+ b1 (list (+ (nth (+ j 3) sp) (nth (+ j 2) sp)) (* d -0.5) 0))
			 "")
		(command "dimlinear" (mapcar '+ b1 (list (- (nth (+ j 4) sp) (qd:rounddown (* 0.15 span2) 3)) (* d -0.25) 0))
					     (mapcar '+ b1 (list (nth (+ j 4) sp) (* d -0.25) 0))
			 (mapcar '+ b1 (list (nth (+ j 4) sp) (* d -0.25) 0))
			 "")
	      )

	    )
	  )
	  (setq j (+ j 2))
	)
	(setq j 0)
	(command "line"
		 (mapcar '+ b2 (list (* 2 (- c)) (* 2 c) 0))
		 (mapcar '+ b3 (list (* 2 (- c)) (* 2 (- c)) 0))
		 ""
	)
	(command "line"
		 (mapcar '+ b3 (list (* 2 (- c)) (* 2 (- c)) 0))
		 (mapcar '+
			 b4
			 (list 0 (* 2 (- c)) 0)
			 (list (nth (- (length sp) 2) sp) 0 0)
			 (list (- (qd:roundup
				 (* 0.25
				    (- (nth (- (length sp) 2) sp)
				       (nth (- (length sp) 3) sp)
				       (nth (- (length sp) 4) sp)
				    )
				 )
				 3
			       )
				  )
			       0
			       0
			 )
		 )
		 ""
	)
	(command "dimlinear"
		 (mapcar '+ b4 (list (- (nth (- (length sp) 2) sp) (qd:roundup (* 0.25 (- (nth (- (length sp) 2) sp) (nth (- (length sp) 3) sp) (nth (- (length sp) 4) sp))) 3)) (* d 0.5) 0))
		 (mapcar '+ b4 (list (nth (- (length sp) 2) sp) (* d 0.5) 0))
		 (mapcar '+ b4 (list (nth (- (length sp) 2) sp) (* d 0.5) 0))
		 ""
		 )
	(command "dimlinear"
		 (mapcar '+ b4 (list (- (nth (- (length sp) 2) sp) (qd:roundup (* 0.15 (- (nth (- (length sp) 2) sp) (nth (- (length sp) 3) sp) (nth (- (length sp) 4) sp))) 3)) (* d 0.25) 0))
		 (mapcar '+ b4 (list (nth (- (length sp) 2) sp) (* d 0.25) 0))
		 (mapcar '+ b4 (list (nth (- (length sp) 2) sp) (* d 0.25) 0))
		 ""
		 )
				     
	(command "line"
		 (mapcar '+ b2 (list (* 3 (- c)) (* 3 c) 0))
		 (mapcar '+ b3 (list (* 3 (- c)) (* 3 (- c)) 0))
		 ""
	)
	(command "line"
		 (mapcar '+ b3 (list (* 3 (- c)) (* 3 (- c)) 0))
		 (mapcar '+
			 b4
			 (list 0 (* 3 (- c)) 0)
			 (list (nth (- (length sp) 2) sp) 0 0)
			 (list (- (qd:roundup
				 (* 0.15
				    (- (nth (- (length sp) 2) sp)
				       (nth (- (length sp) 3) sp)
				       (nth (- (length sp) 4) sp)
				    )
				 )
				 3
			       )
				  )
			       0
			       0
			 )
		 )
		 ""
	)

	(setq a (1+ a))
      )
      (if (< 20230430 (getvar "cdate"))
	(progn
	  (princ
	    "\n*** This version of Qwikdraft software has expired***"
	  )
	  (exit)
	)
      )
          )


    (defun qd:roundup (n m)
      ((lambda (r)
	 (cond ((equal 0.0 r 1e-8) n)
	       ((< n 0) (- n r))
	       ((+ n (- m r)))
	 )
       )
	(rem n m)
      )
    )


    (defun qd:rounddown	(n m)
      ((lambda (r)
	 (cond ((equal 0.0 r 1e-8) n)
	       ((< n 0) (- n r m))
	       ((- n r))
	 )
       )
	(rem n m)
      )
    )
    ;;(entget (car (entsel "select"))
  