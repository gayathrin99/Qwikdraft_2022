(defun c:beamdet ()
  (setvar "cmdecho" 0)
  (setq restoreosmode (getvar "osmode"))
  (setvar "INSUNITS" 4)
  (setq	unit
	 (getstring "Is the drawings in Foot & inches system?(y/n)")
  )
  (if (or (eq unit "y") (eq unit "Y"))
    (setq u 1)
    (setq u 0)
  )
  (princ u)
  (setq beamnum (getint "How many continous beams in total?"))
  (setq a 1)
  (if (eq u 1)
    (progn
      (while (<= a beamnum)
	(alert "Select the end points of the continous beam")
	(setq p1
	       (getpoint "Select the starting point of the continous beam"
	       )
	)
	(setq
	  p2 (getpoint "Select the end point of the continous beam")
	)
	(setq span (distance p1 p2))
	(princ span)
	(setvar "osmode" 0)
	(setq layername1 "Beamdetails")
	(setq layercolor1 "6")
	(setq layername2 "Beamsteel")
	(setq layercolor2 "5")
	(setq d (getdist "Enter the depth of the beam (in inches)"))
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
	(command "line" b1 b2 "")
	(command ".chprop" (entlast) "" "Color" "6" "")
	(command "line" b2 b3 "")
	(command ".chprop" (entlast) "" "Color" "6" "")
	(command "line" b3 b4 "")
	(command ".chprop" (entlast) "" "Color" "6" "")
	(command "line" b4 b1 "")
	(command ".chprop" (entlast) "" "Color" "6" "")
	(setq c (float (getdist "Enter the cover for steel")))
	(setq sd (getint "What is the depth of slab? (in inches)"))
	(command "line"
		 (mapcar '+ b1 (list c c 0.0))
		 (mapcar '+ b2 (list (- c) c 0.0))
		 ""
	)
	(command ".chprop" (entlast) "" "Color" "5" "")
	(command "line"
		 (mapcar '+ b2 (list (- c) c 0.0))
		 (mapcar '+ b3 (list (- c) (- c) 0.0))
		 ""
	)
	(command ".chprop" (entlast) "" "Color" "5" "")
	(command "line"
		 (mapcar '+ b3 (list (- c) (- c) 0.0))
		 (mapcar '+ b4 (list c (- c) 0.0))
		 ""
	)
	(command ".chprop" (entlast) "" "Color" "5" "")
	(command "line"
		 (mapcar '+ b4 (list c (- c) 0.0))
		 (mapcar '+ b1 (list c c 0.0))
		 ""
	)
	(command ".chprop" (entlast) "" "Color" "5" "")
	(command "line"
		 (mapcar '+ b4 (list 0 (- sd) 0))
		 (mapcar '+ b3 (list 0 (- sd) 0))
		 ""
	)
	(command ".chprop" (entlast) "" "Color" "5" "")
	(setq slab_depth_line (entget (entlast)))
	(command "dimlinear"
		 b3
		 b2
		 (mapcar '+ b2 (list 16 0 0))
		 ""
		 ""
	)
	(command ".chprop" (entlast) "" "Color" "5" "")
	(setq col (getint "How many column cross this beam?"))
	(setq i 1)
	(setq sp (list))
	(command "pline" (mapcar '+ bx1 (list 0 (* d 2.5) 0))
	 (mapcar '+ bx1 (list (/ (distance bx1 bx2) 4) (* d 2.5) 0))
	 (mapcar '+ bx1 (list (/ (distance bx1 bx2) 2) (+ (* d 2.5) (* d 0.2)) 0))
	 (mapcar '+ bx1 (list (/ (distance bx1 bx2) 2) (+ (* d 2.5) (* d -0.2)) 0))
	 (mapcar '+ bx1 (list (/ (distance bx1 bx2) 1.3333) (* d 2.5) 0))
	 (mapcar '+ bx1 (list (distance bx1 bx2) (* d 2.5) 0))
	 ""
	 )
	(command ".chprop" (entlast) "" "Color" "6" "")
	(command "pline" (mapcar '+ bx1 (list 0 (* d -1.5) 0))
	 (mapcar '+ bx1 (list (/ (distance bx1 bx2) 4) (* d -1.5) 0))
	 (mapcar '+ bx1 (list (/ (distance bx1 bx2) 2) (+ (* d -1.5) (* d 0.2)) 0))
	 (mapcar '+ bx1 (list (/ (distance bx1 bx2) 2) (+ (* d -1.5) (* d -0.2)) 0))
	 (mapcar '+ bx1 (list (/ (distance bx1 bx2) 1.3333) (* d -1.5) 0))
	 (mapcar '+ bx1 (list (distance bx1 bx2) (* d -1.5) 0))
	 ""
	 )
	(command ".chprop" (entlast) "" "Color" "6" "")
	(alert "Select the end points of the columns in the beam")
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
	  (command ".chprop" (entlast) "" "Color" "6" "")
	  (command
	    "line"
	    (mapcar '-
		    bx2
		    (list (/ (distance bx1 bx2) 2) (* d 2.5) 0.0)
	    )
	    (mapcar '+
		    bx2
		    (list (- (/ (distance bx1 bx2) 2)) (* d 2) 0.0)
	    )
	    ""
	  )
	  (command ".chprop"
		   (entlast)
		   ""
		   "Color"
		   "8"
		   "LType"
		   "DASHED"
		   "LTScale"
		   "25"
		   ""
	  )
	  (command "line"
		   (mapcar '- bx2 (list 0.0 (* d 1.5) 0.0))
		   (mapcar '+ bx2 (list 0 0 0))
		   ""
	  )
	  (command ".chprop" (entlast) "" "Color" "6" "")
	  (command "line"
		   (mapcar '+ bx2 (list 0.0 (* d 2.5) 0.0))
		   (mapcar '+ bx2 (list 0 d 0))
		   ""
		   )		   
	  (command ".chprop" (entlast) "" "Color" "6" "")
	  (setq scale (/ dis2 180))
	  (command ".chprop" (entlast) "" "Color" "6" "")
	  (command ".chprop" (entlast) "" "Color" "6" "")
	  (setq sp (append sp (list dis1 dis2)))
	  (setq i (1+ i))
	)
	(princ sp)
	(setq b 1)
	(while (< b (length sp))
	  (command "mtext"
		   (mapcar '+ b1 (list (- (nth (+ a 2) sp) (nth (1+ a) sp) (nth a sp)) (- d) 0.0))
		   "Height"
		   "4.0"
		   (mapcar '+ b1 (list (- (nth (+ a 2) sp) (nth (1+ a) sp) (nth a sp) 4) (- 4 d) 0.0))
		   (strcat "B" (itoa a) (chr (+ 64 a)))
		   ""
		   )
	  (setq b (1+ b))
	  )			    
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
			  (* 0.3
			     (-	(nth 2 sp)
				(/ (nth 1 sp) 2)
				(nth 0 sp)
				(- (/ (nth 3 sp) 2))
			     )
			  )
			  3
			)
			0
			0
		  )
	  )
	  ""
	)
	(command
	  "dimlinear"
	  (mapcar '+ b4 (list (+ (nth 0 sp) (nth 1 sp)) (* d 0.5) 0))
	  (mapcar '+
		  b4
		  (list	(+ (nth 0 sp)
			   (nth 1 sp)
			   (qd:roundup
			     (*	0.3
				(- (nth 2 sp)
				   (/ (nth 1 sp) 2)
				   (nth 0 sp)
				   (- (/ (nth 3 sp) 2))
				)
			     )
			     3
			   )
			)
			0
			0
		  )
	  )
	  (mapcar '+ b4 (list (+ (nth 0 sp) (nth 1 sp)) (* d 0.5) 80))
	  ""
	)
	;|(setq ss
	       (getint
		 "What is the stirrup spacing at the supports (in inches)"
	       )
	)
	(setq a 1)
	(while
	  (< (* a ss)
	     (qd:roundup (* 0.3 (- (nth 2 sp) (nth 1 sp) (nth 0 sp))) 3)
	  )
	   (progn
	     (command "line"
		      (mapcar '-
			      b4
			      (list (* a (- ss)) (/ c 2) 0.0)
			      (list (- (+ (nth 0 sp) (nth 1 sp))) 0.0 0.0)
		      )
		      (mapcar '+
			      b1
			      (list (* a ss) c 0.0)
			      (list (+ (nth 0 sp) (nth 1 sp)) 0.0 0.0)
		      )
		      ""
	     )

	     (command ".chprop" (entlast) "" "C" "11" "")
	     (setq a (1+ a))
	   )
	)
	|;
	(setq a 1)
	(command "line"
		 (mapcar '+ b1 (list (* 3 c) (* 3 c) 0.0))
		 (mapcar '+ b4 (list (* 3 c) (* 3 (- c)) 0.0))
		 ""
	)
	(setq j 0)
	(while (< j (- (length sp) 5))
	  ;;(if (eq (rem j 2) 0)
	  (progn
	    (setq span1	(- (nth (+ j 2) sp)
			   (/ (nth (1+ j) sp) 2)
			   (nth j sp)
			   (- (/ (nth (+ j 3) sp) 2))
			)
	    )
	    (setq span2	(- (nth (+ j 4) sp)
			   (/ (nth (+ j 3) sp) 2)
			   (nth (+ j 2) sp)
			   (- (/ (nth (+ j 5) sp) 2))
			)
	    )
	    (princ span1)
	    (princ "\n")
	    (princ span2)
	    (if	(eq u 1)
	      (progn
		(command
		  "line"
		  (mapcar '+
			  b4
			  (list 0 (* 2 (- c)) 0.0)
			  (list (nth (+ j 2) sp) 0 0)
			  (list (- (qd:roundup (* 0.3 span1) 3)) 0 0)
		  )
		  (mapcar
		    '+
		    b4
		    (list 0 (* 2 (- c)) 0.0)
		    (list (+ (nth (+ j 2) sp) (nth (+ j 3) sp)) 0 0)
		    (list (qd:roundup (* 0.3 span2) 3) 0 0)
		  )
		  ""
		)
		(command
		  "dimlinear"
		  (mapcar
		    '+
		    b4
		    (list
		      (- (nth (+ j 2) sp) (qd:roundup (* 0.3 span1) 3))
		      (* d 0.5)
		      0
		    )
		  )
		  (mapcar '+ b4 (list (nth (+ j 2) sp) (* d 0.5) 0))
		  (mapcar '+ b4 (list (nth (+ j 2) sp) (* d 0.5) 0))
		  ""
		)
		(command
		  "dimlinear"
		  (mapcar '+
			  b4
			  (list	(+ (nth (+ j 2) sp) (nth (+ j 3) sp))
				(* d 0.5)
				0
			  )
		  )
		  (mapcar '+
			  b4
			  (list	(+ (nth (+ j 2) sp)
				   (nth (+ j 3) sp)
				   (qd:roundup (* 0.3 span2) 3)
				)
				(* d 0.5)
				0
			  )
		  )
		  (mapcar '+ b4 (list (nth (+ j 2) sp) (* d 0.5) 0))
		  ""
		)
		(command
		  "dimlinear"
		  (mapcar '+
			  b4
			  (list (/ (nth (+ j 1) sp) 2) (* d 1.5) 0)
		  )
		  (mapcar
		    '+
		    b4
		    (list (+ (nth (+ j 2) sp) (/ (nth (+ j 3) sp) 2))
			  (* d 2)
			  0
		    )
		  )
		  (mapcar '+ b4 (list (nth (+ j 1) sp) (* d 2) 0))
		  ""
		)
		(command
		  "dimlinear"
		  (mapcar
		    '+
		    b4
		    (list (+ (nth (+ j 2) sp) (/ (nth (+ j 3) sp) 2))
			  (* d 1.5)
			  0.0
		    )
		  )
		  (mapcar
		    '+
		    b4
		    (list (+ (nth (+ j 4) sp) (/ (nth (+ j 5) sp) 2))
			  (* d 1.5)
			  0.0
		    )
		  )
		  (mapcar
		    '+
		    b4
		    (list (+ (nth (+ j 4) sp) (/ (nth (+ j 5) sp) 2))
			  (* d 1.5)
			  0.0
		    )
		  )
		  ""
		)
		(setq b 1)
	;|	(while (< (* b ss)
			  (qd:roundup
			    (* 0.3
			       (- (nth (+ j 4) sp)
				  (nth (+ j 3) sp)
				  (nth (+ j 2) sp)
			       )
			    )
			    3
			  )
		       )
		  (progn
		    (command
		      "line"
		      (mapcar
			'-
			b4
			(list (* b (- ss)) (/ c 2) 0.0)
			(list (- (+ (nth (+ j 3) sp) (nth (+ j 2) sp)))
			      0.0
			      0.0
			)
		      )
		      (mapcar '+
			      b1
			      (list (* b ss) (/ c 2) 0.0)
			      (list (+ (nth (+ j 3) sp) (nth (+ j 2) sp))
				    0.0
				    0.0
			      )
		      )
		      ""
		    )
		    (command ".chprop" (entlast) "" "C" "5" "")

		    (setq b (1+ b))
		  )
		)
		|;
		(setq e 1)
		;|(while
		  (< (* e ss)
		     (qd:roundup
		       (* 0.3
			  (- (nth (+ j 2) sp) (nth (1+ j) sp) (nth j sp))
		       )
		       3
		     )
		  )
		   (progn
		     (command "line"
			      (mapcar '-
				      b4
				      (list (* e ss) (/ c 2) 0.0)
				      (list (- (nth (+ j 2) sp)) 0.0 0.0)
			      )
			      (mapcar '+
				      b1
				      (list (* e (- ss)) (/ c 2) 0.0)
				      (list (nth (+ j 2) sp) 0.0 0.0)
			      )
			      ""
		     )
		     (command ".chprop" (entlast) "" "C" "5" "")
		     (setq e (1+ e))
		   )
		)|;
	      )
	    )
	    (if	(eq u 1)
		;|(command "line" (mapcar '+ b1 (list (* 2 c) (* 2 c) 0.0) (list (+ (* span1 300) (* (qd:rounddown (/ (* 0.15 (* span1 300)) 1000) 0.25) 1000)) 0 0.0))
	       (mapcar '+ b1 (list (* 2 c) (* 2 c) 0.0) (list (- (* span1 300) (* (qd:rounddown (/ (* 0.15 span1) 1000) 0.25) 1000)) 0 0.0))
	       "")|;
	      (progn
		(if (and (/= j 0) (/= j (- (length sp) 1)))
		  (progn
		    (command
		      "line"
		      (mapcar
			'+
			b1
			(list 0 (* 2 c) 0)
			(list (+ (nth j sp) (/ (nth (1+ j) sp) 2)) 0 0)
			(list (qd:rounddown (* 0.15 span1) 3) 0 0)
		      )
		      (mapcar
			'+
			b1
			(list 0 (* 2 c) 0)
			(list (nth (+ j 2) sp) 0 0)
			(list (- (qd:rounddown (* 0.15 span1) 3)) 0 0)
		      )
		      ""
		    )
		    (command
		      "dimlinear"
		      (mapcar '+
			      b1
			      (list (+ (nth j sp) (/ (nth (1+ j) sp) 2))
				    (* d -0.5)
				    0
			      )
		      )
		      (mapcar '+
			      b1
			      (list (+ (nth j sp)
				       (nth (1+ j) sp)
				       (qd:rounddown (* 0.15 span1) 3)
				    )
				    (* d -0.5)
				    0
			      )
		      )
		      (mapcar '+
			      b1
			      (list (+ (nth j sp) (nth (1+ j) sp))
				    (* d -0.5)
				    0
			      )
		      )
		      ""
		    )
		    (command
		      "dimlinear"
		      (mapcar '+
			      b1
			      (list (- (nth (+ j 2) sp)
				       (qd:rounddown (* 0.15 span1) 3)
				    )
				    (* d -0.25)
				    0
			      )
		      )
		      (mapcar
			'+
			b1
			(list (+ (nth (+ j 2) sp) (/ (nth (+ j 3) sp) 2))
			      (* d -0.25)
			      0
			)
		      )
		      (mapcar '+
			      b1
			      (list (nth (+ j 2) sp) (* d -0.25) 0)
		      )
		      ""
		    )
		    (command
		      "line"
		      (mapcar
			'+
			b1
			(list 0 (* 2 c) 0)
			(list (+ (nth (+ j 2) sp) (/ (nth (+ j 3) sp) 2))
			      0
			      0
			)
			(list (qd:rounddown (* 0.15 span2) 3) 0 0)
		      )
		      (mapcar
			'+
			b1
			(list 0 (* 2 c) 0)
			(list (+ (nth (+ j 4) sp) (/ (nth (+ j 5) sp) 2))
			      0
			      0
			)
			(list (- (qd:rounddown (* 0.15 span2) 3)) 0 0)
		      )
		      ""
		    )
		    (command
		      "dimlinear"
		      (mapcar
			'+
			b1
			(list (+ (/ (nth (+ j 3) sp) 2) (nth (+ j 2) sp))
			      (* d -0.5)
			      0
			)
		      )
		      (mapcar '+
			      b1
			      (list (+ (/ (nth (+ j 3) sp) 2)
				       (nth (+ j 2) sp)
				       (qd:rounddown (* 0.15 span2) 3)
				    )
				    (* d -0.5)
				    0
			      )
		      )
		      (mapcar
			'+
			b1
			(list (+ (/ (nth (+ j 3) sp) 2) (nth (+ j 2) sp))
			      (* d -0.5)
			      0
			)
		      )
		      ""
		    )
		    (command
		      "dimlinear"
		      (mapcar '+
			      b1
			      (list (- (nth (+ j 4) sp)
				       (qd:rounddown (* 0.15 span2) 3)
				       (- (/ (nth (+ j 5) sp) 2))
				    )
				    (* d -0.25)
				    0
			      )
		      )
		      (mapcar
			'+
			b1
			(list (+ (nth (+ j 4) sp) (/ (nth (+ j 5) sp) 2))
			      (* d -0.25)
			      0
			)
		      )
		      (mapcar '+
			      b1
			      (list (nth (+ j 4) sp) (* d -0.25) 0)
		      )
		      ""
		    )
		  )
		  (progn
		    (if	(eq j 0)
		      (progn
			(command
			  "line"
			  (mapcar
			    '+
			    b1
			    (list 0 (* 2 c) 0)
			    (list (+ (nth j sp) (/ (nth (1+ j) sp) 2))
				  0
				  0
			    )
			    (list (qd:rounddown (* 0.15 span1) 3) 0 0)
			  )
			  (mapcar
			    '+
			    b1
			    (list 0 (* 2 c) 0)
			    (list (nth (+ j 2) sp) 0 0)
			    (list (- (qd:rounddown (* 0.15 span1) 3))
				  0
				  0
			    )
			  )
			  ""
			)
			(command
			  "dimlinear"
			  (mapcar
			    '+
			    b1
			    (list (+ (nth j sp) (/ (nth (1+ j) sp) 2))
				  (* d -0.5)
				  0
			    )
			  )
			  (mapcar '+
				  b1
				  (list	(+ (nth j sp)
					   (nth (1+ j) sp)
					   (qd:rounddown (* 0.15 span1) 3)
					)
					(* d -0.5)
					0
				  )
			  )
			  (mapcar '+
				  b1
				  (list	(+ (nth j sp) (nth (1+ j) sp))
					(* d -0.5)
					0
				  )
			  )
			  ""
			)
			(command
			  "dimlinear"
			  (mapcar
			    '+
			    b1
			    (list (- (nth (+ j 2) sp)
				     (qd:rounddown (* 0.15 span1) 3)
				  )
				  (* d -0.25)
				  0
			    )
			  )
			  (mapcar '+
				  b1
				  (list	(+ (nth (+ j 2) sp)
					   (/ (nth (+ j 3) sp) 2)
					)
					(* d -0.25)
					0
				  )
			  )
			  (mapcar '+
				  b1
				  (list (nth (+ j 2) sp) (* d -0.25) 0)
			  )
			  ""
			)
			(setq j (+ j 2))
		      )
		    )
		    (if	(eq j (- (length sp) 2))
		      (progn
			(command
			  "line"
			  (mapcar
			    '+
			    b1
			    (list 0 (* 2 c) 0)
			    (list (+ (nth (- (length sp) 4) sp)
				     (/ (nth (- (length sp) 3) sp) 2)
				  )
				  0
				  0
			    )
			    (list (qd:rounddown (* 0.15 span2) 3) 0 0)
			  )
			  (mapcar
			    '+
			    b1
			    (list 0 (* 2 c) 0)
			    (list (+ (nth (- (length sp) 2) sp)
				     (/ (nth (- (length sp) 1) sp) 2)
				  )
				  0
				  0
			    )
			    (list (- (qd:rounddown (* 0.15 span2) 3))
				  0
				  0
			    )
			  )
			  ""
			)
			(command
			  "dimlinear"
			  (mapcar
			    '+
			    b1
			    (list (+ (/ (nth (- (length sp) 3) sp) 2)
				     (nth (- (length sp) 4) sp)
				  )
				  (* d -0.5)
				  0
			    )
			  )
			  (mapcar
			    '+
			    b1
			    (list (+ (/ (nth (- (length sp) 3) sp) 2)
				     (nth (- (length sp) 4) sp)
				     (qd:rounddown (* 0.15 span2) 3)
				  )
				  (* d -0.5)
				  0
			    )
			  )
			  (mapcar
			    '+
			    b1
			    (list (+ (/ (nth (- (length sp) 3) sp) 2)
				     (nth (- (length sp) 4) sp)
				  )
				  (* d -0.5)
				  0
			    )
			  )
			  ""
			)
			(command
			  "dimlinear"
			  (mapcar
			    '+
			    b1
			    (list (- (nth (- (length sp) 2) sp)
				     (qd:rounddown (* 0.15 span2) 3)
				     (- (/ (nth (- (length sp) 1) sp) 2))
				  )
				  (* d -0.25)
				  0
			    )
			  )
			  (mapcar
			    '+
			    b1
			    (list (+ (nth (- (length sp) 2) sp)
				     (/ (nth (- (length sp) 1) sp) 2)
				  )
				  (* d -0.25)
				  0
			    )
			  )
			  (mapcar '+
				  b1
				  (list	(nth (- (length sp) 1) sp)
					(* d -0.25)
					0
				  )
			  )
			  ""
			)
		      )
		    )
		  )
		)
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
				    (* 0.3
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
	(setq a 1)
	;|(while (< (* a ss)
		  (qd:roundup
		    (* 0.3
		       (- (nth (- (length sp) 2) sp)
			  (nth (- (length sp) 3) sp)
			  (nth (- (length sp) 4) sp)
		       )
		    )
		    3
		  )
	       )
	  (progn
	    (command "line"
		     (mapcar '-
			     b3
			     (list (* a ss) (/ c 2) 0.0)
			     (list (nth (- (length sp) 1) sp) 0.0 0.0)
		     )
		     (mapcar '-
			     b2
			     (list (* a ss) (/ c 2) 0.0)
			     (list (nth (- (length sp) 1) sp) 0.0 0.0)
		     )
		     ""
	    )

	    (command ".chprop" (entlast) "" "C" "11" "")
	    (setq a (1+ a))
	  )
	)|;
	(command
	  "dimlinear"
	  (mapcar '+
		  b4
		  (list	(- (nth (- (length sp) 2) sp)
			   (qd:roundup
			     (*	0.3
				(- (nth (- (length sp) 2) sp)
				   (nth (- (length sp) 3) sp)
				   (nth (- (length sp) 4) sp)
				)
			     )
			     3
			   )
			)
			(* d 0.5)
			0
		  )
	  )
	  (mapcar '+ b4 (list (nth (- (length sp) 2) sp) (* d 0.5) 0))
	  (mapcar '+ b4 (list (nth (- (length sp) 2) sp) (* d 0.5) 0))
	  ""
	)
	(command "line"
		 (mapcar '+ b2 (list (* 3 (- c)) (* 3 c) 0))
		 (mapcar '+ b3 (list (* 3 (- c)) (* 3 (- c)) 0))
		 ""
	)
	(setq beam_no
	       (getint
		 "Now, please enter the number of beams crossing the main beam"
	       )
	)
	(setq bnum 1)
	(while (<= bnum beam_no)
	  (setq cb1 (getpoint "Select the beginning of the beam"))
	  (setq cb2 (getpoint "Select the end of the beam"))
	  (setq d1 (- (car cb1) (car p1)))
	  (setq d2 (- (car cb2) (car cb1)))
	  (setq cbx1 (mapcar '+ b1 (list d1 0.0 0.0)))
	  (setq cbx2 (mapcar '+ cbx1 (list d2 0.0 0.0)))
	  (command "line"
		   (mapcar '+ cbx1 (list 0.0 (- d sd) 0.0))
		   (mapcar '+ cbx1 (list 0.0 0.0 0.0))
		   ""
	  )
	  (command ".chprop" (entlast) "" "Color" "6" "")
	  (setq beamline1 (entget (entlast)))
	  (command "line"
		   (mapcar '+ cbx2 (list 0.0 (- d sd) 0.0))
		   (mapcar '+ cbx2 (list 0.0 0.0 0.0))
		   ""
	  )
	  (command ".chprop" (entlast) "" "Color" "6" "")
	  (setq beamline2 (entget (entlast)))
	  ;;(command "trim" beamline1 "" beamline2 "" slab_depth_line "")
	  ;;(command "_-hatch" (getpoint "Pick the internal point to hatch") "_p" "Solid" "0.25" "0.0" "")
	  (setq bnum (1+ bnum))
	)
	(setq bw (getreal "Enter the width of the beam"))
	(command "pline"
		 (mapcar '+ b4 (list (* d -4.5) (- sd) 0.0))
		 (mapcar '+ b4 (list (* d -5) (- sd) 0.0))
		 (mapcar '+ b4 (list (* d -5) (- d) 0.0))
		 (mapcar '+ b4 (list (+ (* d -5) (- bw)) (- d) 0.0))
		 (mapcar '+ b4 (list (+ (* d -5) (- bw)) (- sd) 0.0))
		 (mapcar '+ b4 (list (+ (* d -5.5) (- bw)) (- sd) 0.0))
		 ""
		 )
	(command ".chprop" (entlast) "" "Color" "6" "")
	(command "line"
		 (mapcar '+ b4 (list (* d -4.5) 0.0 0.0))
		 (mapcar '+ b4 (list (- (+ (* d 5.5) bw)) 0.0 0.0))
		 ""
		 )
	(command ".chprop" (entlast) "" "Color" "6" "")
	(command "pline"
		 (mapcar '+ b4 (list (* d -4.5) (* d 0.1) 0.0))
		 (mapcar '+ b4 (list (* d -4.5) (- (/ sd 6)) 0.0))
		 (mapcar '+ b4 (list (* d -4.4) (- (/ sd 2)) 0.0))
		 (mapcar '+ b4 (list (* d -4.6) (- (/ sd 2)) 0.0))
		 (mapcar '+ b4 (list (* d -4.5) (- (* sd (/ 5.0 6.0))) 0.0))
		 (mapcar '+ b4 (list (* d -4.5) (- (+ sd (* d 0.1))) 0.0))
		 ""
		 )
	(command ".chprop" (entlast) "" "Color" "6" "")
	(command "pline"
		 (mapcar '+ b4 (list (- (+ bw (* d 5.5))) (* d 0.1) 0.0))
		 (mapcar '+ b4 (list (- (+ bw (* d 5.5))) (- (/ sd 6)) 0.0))
		 (mapcar '+ b4 (list (- (+ bw (* d 5.4))) (- (/ sd 2)) 0.0))
		 (mapcar '+ b4 (list (- (+ bw (* d 5.6))) (- (/ sd 2)) 0.0))
		 (mapcar '+ b4 (list (- (+ bw (* d 5.5))) (- (* sd (/ 5.0 6.0))) 0.0))
		 (mapcar '+ b4 (list (- (+ bw (* d 5.5))) (- (+ sd (* d 0.1))) 0.0))
		 ""
		 )
	(command ".chprop" (entlast) "" "Color" "6" "")
	(command "rectang" "f" 1 (mapcar '+ b1 (list (- (+ bw (* d 5) (- c))) c 0.0))
		 (mapcar '+ b4 (list (+ (* d -5) (- c)) (- c) 0.0))
		 ""
		 )
	(command "donut" "0.0" "2.0" (mapcar '+ b1 (list (- (+ bw (* d 5) (- c) -1)) (+ c 1) 0.0))
		 ""
		 )
	(command "donut" "0.0" "2.0" (mapcar '+ b1 (list (- (+ (* d 5) c 1)) (+ c 1) 0.0))
		 ""
		 )
	(command "donut" "0.0" "2.0" (mapcar '+ b1 (list (- (+ (* d 5) 1 (/ bw 2.0))) (+ c 1) 0.0))
		 ""
		 )
	(command "donut" "0.0" "2.0" (mapcar '+ b4 (list (- (+ (* d 5) c 1)) (- (+ c 1)) 0.0))
		 ""
		 )
	(command "donut" "0.0" "2.0" (mapcar '+ b4 (list (- (+ (* d 5) (- c) -1 bw)) (- (+ c 1)) 0.0))
		 ""
		 )
	(command "donut" "0.0" "2.0" (mapcar '+ b4 (list (- (+ (* d 5) 1 (/ bw 2.0))) (- (+ c 1)) 0.0))
		 ""
		 )
	(command "donut" "0.0" "2.0" (mapcar '+ b4 (list (- (+ (* d 5) c 1)) (- (+ c 1 sd)) 0.0))
		 ""
		 )
	(command "donut" "0.0" "2.0" (mapcar '+ b4 (list (- (+ (* d 5) (- c) -1 bw)) (- (+ c 1 sd)) 0.0))
		 ""
		 )
	(command "mtext"
		   (mapcar '+ b4 (list (- (+ (* d 5) 1 (/ bw 2.0))) (- (+ c 1)) 0.0))
		   "Height"
		   "4.0"
		   (mapcar '+ b4 (list (- (+ (* d 5) 1 (/ bw 2.0))) (- (+ c 1)) 0.0))
		   (strcat "B" (itoa a))
		   ""
		   )
	(setq a (1+ a))
      )
    )
    (progn
      (setq u1
	     (getint
	       "Do you want the drawing in Millimeters or meters? (press 1 for millimeters , press 2 for meters)"
	     )
      )
      (if (eq u1 1)    ;;for millimeters
	(progn
	  (while (<= a beamnum)
	    (alert "Select the end points of the continous beam")
	    (setq
	      p1 (getpoint
		   "Select the starting point of the continous beam"
		 )
	    )
	    (setq p2
		   (getpoint "Select the end point of the continous beam")
	    )
	    (setq span (distance p1 p2))
	    (princ span)
	    (setvar "osmode" 0)
	    (setq layername1 "Beamdetails")
	    (setq layercolor1 "6")
	    (setq layername2 "Beamsteel")
	    (setq layercolor2 "5")
	    (setq d
		   (getdist "Enter the depth of the beam (in millimeters)")
	    )
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
	    (command ".chprop" (entlast) "" "Color" "6" "")
	    (command "line" b1 b2 "")
	    (command ".chprop" (entlast) "" "Color" "6" "")
	    (command "line" b2 b3 "")
	    (command ".chprop" (entlast) "" "Color" "6" "")
	    (command "line" b3 b4 "")
	    (command ".chprop" (entlast) "" "Color" "6" "")
	    (command "line" b4 b1 "")

	    (command ".chprop" (entlast) "" "Color" "6" "")
	    (setq c
		   (float
		     (getdist "Enter the cover for steel (in millimeters)")
		   )
	    )
	    (setq sd
		   (getreal "What is the depth of slab? (in millimeters)")
	    )
	    (command "line"
		     (mapcar '+ b1 (list (* 3 c) c 0.0))
		     (mapcar '+ b2 (list (* -3 c) c 0.0))
		     ""
	    )
	    (command ".chprop" (entlast) "" "Color" "5" "")
	    (command "line"
		     (mapcar '+ b2 (list (- c) (* 2 c) 0.0))
		     (mapcar '+ b3 (list (- c) (- c) 0.0))
		     ""
	    )
	    (command ".chprop" (entlast) "" "Color" "5" "")
	    (command "line"
		     (mapcar '+ b3 (list (- c) (- c) 0.0))
		     (mapcar '+ b4 (list c (- c) 0.0))
		     ""
	    )
	    (command ".chprop" (entlast) "" "Color" "5" "")
	    (command "line"
		     (mapcar '+ b4 (list c (- c) 0.0))
		     (mapcar '+ b1 (list c (* 2 c) 0.0))
		     ""
	    )
	    (command ".chprop" (entlast) "" "Color" "5" "")
	    (setq slab_depth_line (entget (entlast)))
	    (command "dimlinear"
		     b3
		     b2
		     "Vertical"
		     (mapcar '+ b2 (list 16 0 0))
		     ""
		     ""
	    )
	    (command ".chprop" (entlast) "" "Color" "5" "")
	    (setq col (getint "How many column cross this beam?"))
	    (setq i 1)
	    (setq sp (list))
	    (alert "Select the end points of the columns in the beam")
	    (while (<= i col)
	      (setq cx1 (getpoint "Select the beginning of the column"))
	      (setq cx2 (getpoint "Select the end point of the column"))
	      (setq dis1 (- (car cx1) (car p1)))
	      (setq dis2 (- (car cx2) (car cx1)))
	      (setq bx1 (mapcar '+ b1 (list dis1 0.0 0.0)))
	      (setq bx2 (mapcar '+ bx1 (list dis2 0.0 0.0)))
	      (command "line"
		       (mapcar '- bx1 (list 0.0 (* d 1.5) 0.0))
		       (mapcar '+ bx1 (list 0.0 0.0 0.0))
		       ""
		       )
	      (command ".chprop" (entlast) "" "Color" "6" "")
	      (command "line"
		       (mapcar '+ bx1 (list 0.0 d 0.0))
		       (mapcar '+ bx1 (list 0.0 (* d 2.5) 0.0))
		       ""
	      )
	      (command ".chprop" (entlast) "" "Color" "6" "")
	      (command
		"line"
		(mapcar	'-
			bx2
			(list (/ (distance bx1 bx2) 2) (* d 2.5) 0.0)
		)
		(mapcar	'+
			bx2
			(list (- (/ (distance bx1 bx2) 2)) (* d 2) 0.0)
		)
		""
	      )
	      (command ".chprop"
		       (entlast)
		       ""
		       "C"
		       "8"
		       "LType"
		       "DASHED"
		       "LTScale"
		       "25"
		       ""
	      )
	      (command "line"
		       (mapcar '- bx2 (list 0.0 (* d 1.5) 0.0))
		       (mapcar '+ bx2 (list 0.0 0.0 0.0))
		       ""
		       )
	      (command ".chprop" (entlast) "" "Color" "6" "")
	      (command "line"
		       (mapcar '+ bx2 (list 0.0 d 0.0))
		       (mapcar '+ bx2 (list 0.0 (* d 2.5) 0.0))
		       ""
	      )
	      (command ".chprop" (entlast) "" "Color" "6" "")
	      ;;(command "_layer" "n"	layername1 "C" layercolor1 layername1 "")
	      (command
		"pline"
		(mapcar '+ bx1 (list 0 (* d 2.5) 0))
		(mapcar	'+
			bx1
			(list (/ (distance bx1 bx2) 4) (* d 2.5) 0)
		)
		(mapcar	'+
			bx1
			(list (/ (distance bx1 bx2) 2)
			      (+ (* d 2.5) (* d 0.2))
			      0
			)
		)
		(mapcar	'+
			bx1
			(list (/ (distance bx1 bx2) 2)
			      (+ (* d 2.5) (* d -0.2))
			      0
			)
		)
		(mapcar	'+
			bx1
			(list (/ (distance bx1 bx2) 1.3333) (* d 2.5) 0)
		)
		(mapcar '+ bx1 (list (distance bx1 bx2) (* d 2.5) 0))
		""
	      )
	      (command ".chprop" (entlast) "" "Color" "6" "")
	      (command
		"pline"
		(mapcar '+ bx1 (list 0 (* d -1.5) 0))
		(mapcar	'+
			bx1
			(list (/ (distance bx1 bx2) 4) (* d -1.5) 0)
		)
		(mapcar	'+
			bx1
			(list (/ (distance bx1 bx2) 2)
			      (+ (* d -1.5) (* d 0.2))
			      0
			)
		)
		(mapcar	'+
			bx1
			(list (/ (distance bx1 bx2) 2)
			      (+ (* d -1.5) (* d -0.2))
			      0
			)
		)
		(mapcar	'+
			bx1
			(list (/ (distance bx1 bx2) 1.3333) (* d -1.5) 0)
		)
		(mapcar '+ bx1 (list (distance bx1 bx2) (* d -1.5) 0))
		""
	      )
	      (command ".chprop" (entlast) "" "Color" "6" "")
	      (setq sp (append sp (list dis1 dis2)))
	      (setq i (1+ i))
	    )
	    (princ sp)
	    (setq b 1)
	    (while (< b (length sp))
	      (command "mtext"
		   (mapcar '+ b1 (list (- (nth (+ a 2) sp) (nth (1+ a) sp) (nth a sp)) (- d) 0.0))
		   "Height"
		   "40.0"
		   (mapcar '+ b1 (list (- (nth (+ a 2) sp) (nth (1+ a) sp) (nth a sp) 4) (- 4 d) 0.0))
		   (strcat "B" (itoa a) (chr (+ 64 a)))
		   ""
		   )
	  (setq b (1+ b))
	  )
	    ;|(command
	      "pline"
	      (mapcar '+
		      b4
		      (list (- (+ (nth 0 sp) (nth 1 sp)) c) (* d 0.1) 0)
	      )
	      (mapcar '+ b4 (list (- (* d 0.1)) (* d 0.1) 0))
	      (mapcar '+ b1 (list (* d -0.1) (- (* 2 c) d) 0.0))
	      ""
	    )
	    (command ".chprop" (entlast) "" "C" "9" "")|;
	    ;|(command
	      "pline"
	      (mapcar '+
		      b4
		      (list (- (+ (nth 0 sp) (nth 1 sp)) c) (* d 0.1) 0)
	      )
	      (mapcar '+
		      b4
		      (list (- (+ (nth 0 sp) (nth 1 sp)) c)
			    (+ (* d 0.1) (/ c 2))
			    0
		      )
	      )
	      (mapcar '+
		      b4
		      (list (+ (nth 0 sp) (nth 1 sp)) (* d 0.1) 0)
	      )
	      (mapcar '+
		      b4
		      (list (- (+ (nth 0 sp) (nth 1 sp)) c)
			    (- (* d 0.1) (/ c 2))
			    0
		      )
	      )
	      (mapcar '+
		      b4
		      (list (- (+ (nth 0 sp) (nth 1 sp)) c) (* d 0.1) 0)
	      )
	      ""
	    )
	    (command ".chprop" (entlast) "" "C" "9" "")|;
	   ;| (command
	      "pline"
	      (mapcar '+ b1 (list (* d -0.1) (- (* 2 c) d) 0.0))
	      (mapcar '+
		      b1
		      (list (- (* d -0.1) (/ c 2)) (- (* 2 c) d) 0.0)
	      )
	      (mapcar '+ b1 (list (* d -0.1) (- c d) 0.0))
	      (mapcar '+
		      b1
		      (list (+ (* d -0.1) (/ c 2)) (- (* 2 c) d) 0.0)
	      )
	      (mapcar '+ b1 (list (* d -0.1) (- (* 2 c) d) 0.0))
	      ""
	    )
	    (command ".chprop" (entlast) "" "C" "9" "")|;
	    ;|(command
	      "pline"
	      (mapcar '+
		      b1
		      (list (- (+ (nth 0 sp) (nth 1 sp)) c) (* d -0.2) 0)
	      )
	      (mapcar '+ b1 (list (- (* d 0.2)) (* d -0.2) 0))
	      (mapcar '+ b4 (list (* d -0.2) (+ d (* 4 (- c))) 0.0))
	      ""
	    )
	    (command ".chprop" (entlast) "" "C" "9" "")|;
	    ;|(command
	      "pline"
	      (mapcar '+
		      b1
		      (list (- (+ (nth 0 sp) (nth 1 sp)) c) (* d -0.2) 0)
	      )
	      (mapcar '+
		      b1
		      (list (- (+ (nth 0 sp) (nth 1 sp)) c)
			    (+ (* d -0.2) (/ c 2))
			    0
		      )
	      )
	      (mapcar '+
		      b1
		      (list (+ (nth 0 sp) (nth 1 sp)) (* d -0.2) 0)
	      )
	      (mapcar '+
		      b1
		      (list (- (+ (nth 0 sp) (nth 1 sp)) c)
			    (- (* d -0.2) (/ c 2))
			    0
		      )
	      )
	      (mapcar '+
		      b1
		      (list (- (+ (nth 0 sp) (nth 1 sp)) c) (* d -0.2) 0)
	      )
	      ""
	    )
	    (command ".chprop" (entlast) "" "C" "9" "")|;
	   ;| (command
	      "pline"
	      (mapcar '+ b4 (list (* d -0.2) (- d (* 4 c)) 0.0))
	      (mapcar '+
		      b4
		      (list (- (* d -0.2) (/ c 2)) (- d (* 4 c)) 0.0)
	      )
	      (mapcar '+ b4 (list (* d -0.2) (- d (* 4 c) (- c)) 0.0))
	      (mapcar '+
		      b4
		      (list (+ (* d -0.2) (/ c 2)) (- d (* 4 c)) 0.0)
	      )
	      (mapcar '+ b4 (list (* d -0.2) (- d (* 4 c)) 0.0))
	      ""
	    )
	    (command ".chprop" (entlast) "" "C" "9" "")|;
	    (command "mtext"
		     (mapcar '+ b4 (list (- d) (* d 0.3) 0.0))
		     "Height"
		     "0.2"
		     (mapcar '+ b4 (list (- d) (* d 0.3) 0.0))
		     "Ld"
		     ""
	    )
	    (command "line"
		     (mapcar '+ b1 (list (* 2 c) (* 2 c) 0.0))
		     (mapcar '+ b4 (list (* 2 c) (* 2 (- c)) 0.0))
		     ""
	    )
	    (command "line"
		     (mapcar '+ b1 (list (* 3 c) c 0.0))
		     (mapcar '+ b4 (list (* 3 c) (+ d (* 3 (- c))) 0.0))
		     ""
	    )
	    (command "line"
		     (mapcar '+ b2 (list (* 2 (- c)) (* 2 c) 0.0))
		     (mapcar '+ b3 (list (* 2 (- c)) (* 2 (- c)) 0.0))
		     ""
	    )
	    (command
	      "line"
	      (mapcar '+ b2 (list (* 3 (- c)) c 0.0))
	      (mapcar '+ b3 (list (* 3 (- c)) (+ d (* 3 (- c))) 0.0))
	      ""
	    )
	    ;|
	    (setq ss
		   (getint
		     "What is the stirrup spacing at the supports (in millimeters)"
		   )
	    )|;
	    (setq j 0)
	    (while (< j (- (length sp) 3))
	      (command
		"dimlinear"
		(mapcar
		  '+
		  b4
		  (list (+ (nth j sp) (/ (nth (1+ j) sp) 2)) (* d 2) 0)
		)
		(mapcar	'+
			b4
			(list (+ (nth (+ j 2) sp) (/ (nth (+ j 3) sp) 2))
			      (* d 2)
			      0
			)
		)
		(mapcar
		  '+
		  b4
		  (list (+ (nth j sp) (/ (nth (1+ j) sp) 2)) (* d 2) 0)
		)
		""
	      )
	      (command
		"line"
		;;top 0.25l on the right line
		(mapcar	'+
			b4
			(list (* 2 c) (* 2 (- c)) 0.0)
			(list (nth j sp) 0 0)
		)
		(mapcar	'+
			b4
			(list 0 (* 2 (- c)) 0.0)
			(list (+ (nth j sp) (nth (1+ j) sp)) 0 0)
			(list (qd:roundup
				(* 0.25
				   (- (nth (+ j 2) sp)
				      (/ (nth (1+ j) sp) 2)
				      (nth j sp)
				      (- (/ (nth (+ j 3) sp) 2))
				   )
				)
				75
			      )
			      0
			      0
			)
		)
		""
	      )
	      (command
		"dimlinear"
		(mapcar
		  '+
		  b4
		  (list (+ (nth j sp) (nth (1+ j) sp)) (* d 0.75) 0)
		)
		;;top 0.25l on the right dimension
		(mapcar	'+
			b4
			(list (+ (nth j sp)
				 (nth (1+ j) sp)
				 (qd:roundup
				   (* 0.25
				      (- (nth (+ j 2) sp)
					 (/ (nth (1+ j) sp) 2)
					 (nth j sp)
					 (- (/ (nth (+ j 3) sp) 2))
				      )
				   )
				   75
				 )
			      )
			      0
			      0
			)
		)
		"Horizontal"
		(mapcar
		  '+
		  b4
		  (list (+ (nth j sp) (nth (1+ j) sp)) (* d 0.75) 80)
		)
		""
	      )
	      (command
		;;top 0.25l on the left side
		"line"
		(mapcar	'+
			b4
			(list (* -2 c) (* 2 (- c)) 0.0)
			(list (nth (+ j 2) sp) 0 0)
			(list (- (qd:roundup
				   (* 0.3
				      (- (nth (+ j 2) sp)
					 (nth j sp)
					 (/ (nth (1+ j) sp) 2)
					 (/ (- (nth (+ j 3) sp)) 2)
				      )
				   )
				   75
				 )
			      )
			      0
			      0
			)
		)
		(mapcar	'+
			b4
			(list (* -2 c) (* 2 (- c)) 0.0)
			(list (+ (nth (+ j 2) sp) (nth (+ j 3) sp)) 0 0)
		)
		""
	      )
	      (command
		"dimlinear"
		;;top 0.25l on the left side
		(mapcar	'+
			b4
			(list (- (nth (+ j 2) sp)
				 (qd:roundup
				   (* 0.3
				      (- (nth (+ j 2) sp)
					 (nth j sp)
					 (/ (nth (1+ j) sp) 2)
					 (/ (- (nth (+ j 3) sp)) 2)
				      )
				   )
				   75
				 )
			      )
			      (* d 0.5)
			      0
			)
		)
		;;top 0.25 on the left side
		(mapcar '+ b4 (list (nth (+ j 2) sp) (* d 0.75) 0))
		"Horizontal"
		(mapcar '+ b4 (list (nth (+ j 2) sp) (* d 0.75) 0))
		""
	      )
	      (command
		"dimlinear"
		(mapcar	'+
			b1
			(list (+ (nth (+ j 1) sp) (nth j sp)) (* d -2) 0)
		)
		(mapcar	'+
			b1
			(list (+ (nth (+ j 1) sp)
				 (nth j sp)
				 (qd:roundup
				   (* 0.3
				      (- (nth (+ j 2) sp)
					 (nth (1+ j) sp)
					 (nth j sp)
				      )
				   )
				   75
				 )
			      )
			      (* d -2)
			      0
			)
		)
		"Horizontal"
		(mapcar	'+
			b1
			(list (+ (nth (+ j 1) sp) (nth j sp)) (* d -2) 0)
		)
		""
	      )
	      (setq ent1 (entlast))
	      (entmod (subst (cons 1 "Stirrups at Support")
			     (assoc 1 (entget ent1))
			     (entget ent1)
		      )
	      )
	      (command "dimlinear"
		       (mapcar '+
			       b1
			       (list (+	(nth (+ j 1) sp)
					(nth j sp)
					(qd:roundup
					  (* 0.3
					     (-	(nth (+ j 2) sp)
						(nth (1+ j) sp)
						(nth j sp)
					     )
					  )
					  75
					)
				     )
				     (* d -2)
				     0
			       )
		       )
		       (mapcar '+
			       b1
			       (list (-	(nth (+ j 2) sp)
					(qd:roundup
					  (* 0.3
					     (-	(nth (+ j 2) sp)
						(nth (1+ j) sp)
						(nth j sp)
					     )
					  )
					  75
					)
				     )
				     (* d -2)
				     0
			       )
		       )
		       "Horizontal"
		       (mapcar '+
			       b1
			       (list (+	(nth (+ j 1) sp)
					(nth j sp)
					(qd:roundup
					  (* 0.3
					     (-	(nth (+ j 2) sp)
						(nth (1+ j) sp)
						(nth j sp)
					     )
					  )
					  75
					)
				     )
				     (* d -2)
				     0
			       )
		       )
		       ""
	      )
	      (setq ent2 (entlast))
	      (entmod (subst (cons 1 "Stirrups at MidSpan")
			     (assoc 1 (entget ent2))
			     (entget ent2)
		      )
	      )
	      (command "dimlinear"
		       (mapcar '+
			       b1
			       (list (-	(nth (+ j 2) sp)
					(qd:roundup
					  (* 0.3
					     (-	(nth (+ j 2) sp)
						(nth (1+ j) sp)
						(nth j sp)
					     )
					  )
					  75
					)
				     )
				     (* d -2)
				     0
			       )
		       )
		       (mapcar '+ b1 (list (nth (+ j 2) sp) (* d -2) 0))
		       "Horizontal"
		       (mapcar '+ b1 (list (nth (+ j 2) sp) (* d -2) 0))
		       ""
	      )
	      (setq ent3 (entlast))
	      (entmod (subst (cons 1 "Stirrups at Supports")
			     (assoc 1 (entget ent3))
			     (entget ent3)
		      )
	      )

	      (if (and (/= j 0) (/= j (- (length sp) 2)))
		(progn
		  (command
		    "line"
		    (mapcar
		      '+
		      b1
		      (list 0 (* 2 c) 0)
		      (list (+ (nth j sp) (/ (nth (1+ j) sp) 2)) 0 0)
		      (list (qd:rounddown
			      (* 0.15
				 (- (nth (+ j 2) sp)
				    (nth j sp)
				    (/ (nth (1+ j) sp) 2)
				    (/ (- (nth (+ j 3) sp)) 2)
				 )
			      )
			      75
			    )
			    0
			    0
		      )
		    )
		    (mapcar
		      '+
		      b1
		      (list 0 (* 2 c) 0)
		      (list (+ (nth (+ j 2) sp) (/ (nth (+ j 3) sp) 2))
			    0
			    0
		      )
		      (list (- (qd:rounddown
				 (* 0.15
				    (- (nth (+ j 2) sp)
				       (nth j sp)
				       (/ (nth (1+ j) sp) 2)
				       (/ (- (nth (+ j 3) sp)) 2)
				    )
				 )
				 75
			       )
			    )
			    0
			    0
		      )
		    )
		    ""
		  )
		  (command
		    "dimlinear"
		    (mapcar '+
			    b1
			    (list (+ (nth j sp) (/ (nth (1+ j) sp) 2))
				  (* d -0.5)
				  0
			    )
		    )
		    (mapcar '+
			    b1
			    (list (+ (nth j sp)
				     (/ (nth (1+ j) sp) 2)
				     (qd:rounddown
				       (* 0.15
					  (- (nth (+ j 2) sp)
					     (nth j sp)
					     (/ (nth (1+ j) sp) 2)
					     (/ (- (nth (+ j 3) sp)) 2)
					  )
				       )
				       75
				     )
				  )
				  (* d -0.5)
				  0
			    )
		    )
		    "Horizontal"
		    (mapcar
		      '+
		      b1
		      (list (+ (nth j sp) (nth (1+ j) sp)) (* d -0.5) 0)
		    )
		    ""
		  )
		  (command
		    "dimlinear"
		    (mapcar '+
			    b1
			    (list (- (nth (+ j 2) sp)
				     (- (/ (nth (+ j 3) sp) 2))
				     (qd:rounddown
				       (* 0.15
					  (- (nth (+ j 2) sp)
					     (nth j sp)
					     (/ (nth (1+ j) sp) 2)
					  )
				       )
				       75
				     )
				  )
				  (* d -0.5)
				  0
			    )
		    )
		    (mapcar
		      '+
		      b1
		      (list (+ (nth (+ j 2) sp) (/ (nth (+ j 3) sp) 2))
			    (* d -0.5)
			    0
		      )
		    )
		    "Horizontal"
		    (mapcar
		      '+
		      b1
		      (list (+ (nth (+ j 2) sp) (/ (nth (+ j 3) sp) 2))
			    (* d -0.5)
			    0
		      )
		    )
		    ""
		  )
		)
		(progn  
		  (if (eq j 0)
		    (progn
		      (command
			"line"
			(mapcar
			  '+
			  b1
			  (list 0 (* 2 c) 0)
			  (list	(+ (nth j sp) (/ (nth (1+ j) sp) 2))
				0
				0
			  )
			  (list	(qd:rounddown
				  (* 0.15
				     (-	(nth (+ j 2) sp)
					(nth j sp)
					(/ (nth (1+ j) sp) 2)
					(/ (- (nth (+ j 3) sp)) 2)
				     )
				  )
				  75
				)
				0
				0
			  )
			)
			(mapcar
			  '+
			  b1
			  (list 0 (* 2 c) 0)
			  (list
			    (+ (nth (+ j 2) sp) (/ (nth (+ j 3) sp) 2))
			    0
			    0
			  )
			  (list	(- (qd:rounddown
				     (*	0.15
					(- (nth (+ j 2) sp)
					   (nth j sp)
					   (/ (nth (1+ j) sp) 2)
					   (/ (- (nth (+ j 3) sp)) 2)
					)
				     )
				     75
				   )
				)
				0
				0
			  )
			)
			""
		      )
		      (command
			"dimlinear"
			(mapcar
			  '+
			  b1
			  (list	(+ (nth j sp) (/ (nth (1+ j) sp) 2))
				(* d -0.5)
				0
			  )
			)
			(mapcar
			  '+
			  b1
			  (list	(+ (nth j sp)
				   (/ (nth (1+ j) sp) 2)
				   (qd:rounddown
				     (*	0.15
					(- (nth (+ j 2) sp)
					   (nth j sp)
					   (/ (nth (1+ j) sp) 2)
					   (/ (- (nth (+ j 3) sp)) 2)
					)
				     )
				     75
				   )
				)
				(* d -0.5)
				0
			  )
			)
			"Horizontal"
			(mapcar
			  '+
			  b1
			  (list	(+ (nth j sp) (/ (nth (1+ j) sp) 2))
				(* d -0.5)
				0
			  )
			)
			""
		      )
		      (command
			"dimlinear"
			(mapcar
			  '+
			  b1
			  (list	(- (nth (+ j 2) sp)
				   (/ (- (nth (+ j 3) sp)) 2)
				   (qd:rounddown
				     (*	0.15
					(- (nth (+ j 2) sp)
					   (nth j sp)
					   (/ (nth (1+ j) sp) 2)
					   (/ (- (nth (+ j 3) sp)) 2)
					)
				     )
				     75
				   )
				)
				(* d -0.5)
				0
			  )
			)
			(mapcar
			  '+
			  b1
			  (list
			    (+ (nth (+ j 2) sp) (/ (nth (+ j 3) sp) 2))
			    (* d -0.5)
			    0
			  )
			)
			"Horizontal"
			(mapcar	'+
				b1
				(list (nth (+ j 2) sp) (* d -0.5) 0)
			)
			""
		      )
		    )
		  )
		  (if (eq j (- (length sp) 3))
		    (progn
		      (command
			"line"
			(mapcar
			  '+
			  b1
			  (list 0 (* 2 c) 0)
			  (list	(+ (nth (- (length sp) 4) sp)
				   (/ (nth (- (length sp) 3) sp) 2)
				)
				0
				0
			  )
			  (list
			    (qd:rounddown
			      (* 0.15
				 (- (nth (- (length sp) 2) sp)
				    (nth (- (length sp) 4) sp)
				    (/ (nth (- (length sp) 3) sp) 2)
				    (/ (- (nth (- (length sp) 1) sp)) 2)
				 )
			      )
			      75
			    )
			    0
			    0
			  )
			)
			(mapcar
			  '+
			  b1
			  (list 0 (* 2 c) 0)
			  (list	(+ (nth (- (length sp) 2) sp)
				   (/ (nth (- (length sp) 1) sp) 2)
				)
				0
				0
			  )
			  (list
			    (-
			      (qd:rounddown
				(*
				  0.15
				  (- (nth (- (length sp) 2) sp)
				     (nth (- (length sp) 4) sp)
				     (/ (nth (- (length sp) 3) sp) 2)
				     (/ (- (nth (- (length sp) 1) sp)) 2)
				  )
				)
				75
			      )
			    )
			    0
			    0
			  )
			)
			""
		      )
		      (command
			"dimlinear"
			(mapcar	'+
				b1
				(list (+ (/ (nth (- (length sp) 3) sp) 2)
					 (nth (- (length sp) 4) sp)
				      )
				      (* d -0.5)
				      0
				)
			)
			(mapcar
			  '+
			  b1
			  (list
			    (+
			      (/ (nth (- (length sp) 3) sp) 2)
			      (nth (- (length sp) 4) sp)
			      (qd:rounddown
				(*
				  0.15
				  (- (nth (- (length sp) 2) sp)
				     (nth (- (length sp) 4) sp)
				     (/ (nth (- (length sp) 3) sp) 2)
				     (/ (- (nth (- (length sp) 1) sp)) 2)
				  )
				)
				75
			      )
			    )
			    (* d -0.5)
			    0
			  )
			)
			"Horizontal"
			(mapcar	'+
				b1
				(list (+ (/ (nth (- (length sp) 3) sp) 2)
					 (nth (- (length sp) 4) sp)
				      )
				      (* d -0.5)
				      0
				)
			)
			""
		      )
		      (command
			"dimlinear"
			(mapcar
			  '+
			  b1
			  (list
			    (-
			      (nth (- (length sp) 2) sp)
			      (- (/ (nth (- (length sp) 1) sp) 2))
			      (qd:rounddown
				(*
				  0.15
				  (- (nth (- (length sp) 2) sp)
				     (nth (- (length sp) 4) sp)
				     (/ (nth (- (length sp) 3) sp) 2)
				     (/ (- (nth (- (length sp) 1) sp)) 2)
				  )
				)
				75
			      )
			    )
			    (* d -0.5)
			    0
			  )
			)
			(mapcar	'+
				b1
				(list (+ (nth (- (length sp) 2) sp)
					 (/ (nth (- (length sp) 1) sp) 2)
				      )
				      (* d -0.5)
				      0
				)
			)
			"Horizontal"
			(mapcar	'+
				b1
				(list (+ (nth (- (length sp) 2) sp)
					 (/ (nth (- (length sp) 1) sp) 2)
				      )
				      (* d -0.5)
				      0
				)
			)
			""
		      )
		    )
		  )
		)
	      )
	      (setq b 1)
	      ;|(while
		(<= (* b ss)
		    (qd:roundup
		      (* 0.3
			 (- (nth (+ j 2) sp) (nth (1+ j) sp) (nth j sp))
		      )
		      75
		    )
		)
		 (progn
		   (command
		     "line"
		     (mapcar
		       '-
		       b4
		       (list (* b (- ss)) (/ c 2) 0.0)
		       (list (- (+ (nth j sp) (nth (1+ j) sp))) 0.0 0.0)
		     )
		     (mapcar '+
			     b1
			     (list (* b ss) (/ c 2) 0.0)
			     (list (+ (nth j sp) (nth (1+ j) sp)) 0.0 0.0)
		     )
		     ""
		   )
		   (command ".chprop" (entlast) "" "C" "11" "")
		   (setq b (1+ b))
		 )
	      )|;
	      (setq e 1)
	      ;|(while
		(<= (* e ss)
		    (qd:roundup
		      (* 0.25
			 (- (nth (+ j 2) sp) (nth (1+ j) sp) (nth j sp))
		      )
		      75
		    )
		)
		 (progn
		   (command "line"
			    (mapcar '-
				    b4
				    (list (* e ss) (/ c 2) 0.0)
				    (list (- (nth (+ j 2) sp)) 0.0 0.0)
			    )
			    (mapcar '+
				    b1
				    (list (* e (- ss)) (/ c 2) 0.0)
				    (list (nth (+ j 2) sp) 0.0 0.0)
			    )
			    ""
		   )
		   (command ".chprop" (entlast) "" "C" "11" "")
		   (setq e (1+ e))
		 )
	      )|;
	      (setq j (+ j 2))
	    )
	    (setq beam_no
		   (getint
		     "Now, please enter the number of beams crossing the main beam"
		   )
	    )
	    (setq end_of_last_beam 0)
	    (setq bnum 1)
	    (while (<= bnum beam_no)
	      (setq cb1 (getpoint "Select the beginning of the beam"))
	      (setq cb2 (getpoint "Select the end of the beam"))
	      (setq d1 (- (car cb1) (car p1)))
	      (setq d2 (- (car cb2) (car cb1)))
	      (setq cbx1 (mapcar '+ b1 (list d1 0.0 0.0)))
	      (setq cbx2 (mapcar '+ cbx1 (list d2 0.0 0.0)))
	      (command "line"
		       (mapcar '+ b4 (list end_of_last_beam (- sd) 0))
		       (mapcar '+ b4 (list d1 (- sd) 0))
		       ""
	      )
	      (command ".chprop"
		       (entlast)
		       ""
		       "Color"
		       "93"
		       "Ltype"
		       "DASHED"
		       "LTScale"
		       "2.5"
		       ""
	      )
	      (command "line"
		       (mapcar '+ cbx1 (list 0.0 (- d sd) 0.0))
		       (mapcar '+ cbx1 (list 0.0 0.0 0.0))
		       ""
	      )
	      (command ".chprop"
		       (entlast)
		       ""
		       "Color"
		       "93"
		       "Ltype"
		       "DASHED"
		       "LTScale"
		       "2.5"
		       ""
	      )
	      (setq beamline1 (entget (entlast)))
	      (command "line"
		       (mapcar '+ cbx2 (list 0.0 (- d sd) 0.0))
		       (mapcar '+ cbx2 (list 0.0 0.0 0.0))
		       ""
	      )
	      (command ".chprop"
		       (entlast)
		       ""
		       "Color"
		       "93"
		       "Ltype"
		       "DASHED"
		       "LTScale"
		       "2.5"
		       ""
	      )
	      (setq end_of_last_beam (+ d1 d2))
	      ;;(command "trim" beamline1 "" beamline2 "" slab_depth_line "")
	      ;;(command "_-hatch" (getpoint "Pick the internal point to hatch") "_p" "Solid" "0.25" "0.0" "")
	      (setq bnum (1+ bnum))
	    )
	    (setq bw (getreal "Enter the width of the beam"))
	(command "pline"
		 (mapcar '+ b4 (list (* d -4.5) (- sd) 0.0))
		 (mapcar '+ b4 (list (* d -5) (- sd) 0.0))
		 (mapcar '+ b4 (list (* d -5) (- d) 0.0))
		 (mapcar '+ b4 (list (+ (* d -5) (- bw)) (- d) 0.0))
		 (mapcar '+ b4 (list (+ (* d -5) (- bw)) (- sd) 0.0))
		 (mapcar '+ b4 (list (+ (* d -5.5) (- bw)) (- sd) 0.0))
		 ""
		 )
	(command ".chprop" (entlast) "" "Color" "6" "")
	(command "line"
		 (mapcar '+ b4 (list (* d -4.5) 0.0 0.0))
		 (mapcar '+ b4 (list (- (+ (* d 5.5) bw)) 0.0 0.0))
		 ""
		 )
	(command ".chprop" (entlast) "" "Color" "6" "")
	(command "pline"
		 (mapcar '+ b4 (list (* d -4.5) (* d 0.1) 0.0))
		 (mapcar '+ b4 (list (* d -4.5) (- (/ sd 6)) 0.0))
		 (mapcar '+ b4 (list (* d -4.4) (- (/ sd 2)) 0.0))
		 (mapcar '+ b4 (list (* d -4.6) (- (/ sd 2)) 0.0))
		 (mapcar '+ b4 (list (* d -4.5) (- (* sd (/ 5.0 6.0))) 0.0))
		 (mapcar '+ b4 (list (* d -4.5) (- (+ sd (* d 0.1))) 0.0))
		 ""
		 )
	(command ".chprop" (entlast) "" "Color" "6" "")
	(command "pline"
		 (mapcar '+ b4 (list (- (+ bw (* d 5.5))) (* d 0.1) 0.0))
		 (mapcar '+ b4 (list (- (+ bw (* d 5.5))) (- (/ sd 6)) 0.0))
		 (mapcar '+ b4 (list (- (+ bw (* d 5.4))) (- (/ sd 2)) 0.0))
		 (mapcar '+ b4 (list (- (+ bw (* d 5.6))) (- (/ sd 2)) 0.0))
		 (mapcar '+ b4 (list (- (+ bw (* d 5.5))) (- (* sd (/ 5.0 6.0))) 0.0))
		 (mapcar '+ b4 (list (- (+ bw (* d 5.5))) (- (+ sd (* d 0.1))) 0.0))
		 ""
		 )
	(command ".chprop" (entlast) "" "Color" "6" "")
	(command "rectang" "f" 10.0 (mapcar '+ b1 (list (- (+ bw (* d 5) (- c))) c 0.0))
		 (mapcar '+ b4 (list (+ (* d -5) (- c)) (- c) 0.0))
		 ""
		 )
	(command "donut" "0.0" "20.0" (mapcar '+ b1 (list (- (+ bw (* d 5) (- c) -1)) (+ c 10.0) 0.0))
		 ""
		 )
	(command "donut" "0.0" "20.0" (mapcar '+ b1 (list (- (+ (* d 5) c 10.0)) (+ c 10.0) 0.0))
		 ""
		 )
	(command "donut" "0.0" "20.0" (mapcar '+ b1 (list (- (+ (* d 5) 10.0 (/ bw 2.0))) (+ c 10.0) 0.0))
		 ""
		 )
	(command "donut" "0.0" "20.0" (mapcar '+ b4 (list (- (+ (* d 5) c 10.0)) (- (+ c 10.0)) 0.0))
		 ""
		 )
	(command "donut" "0.0" "20.0" (mapcar '+ b4 (list (- (+ (* d 5) (- c) -10.0 bw)) (- (+ c 10.0)) 0.0))
		 ""
		 )
	(command "donut" "0.0" "20.0" (mapcar '+ b4 (list (- (+ (* d 5) 10.0 (/ bw 2.0))) (- (+ c 10.0)) 0.0))
		 ""
		 )
	(command "donut" "0.0" "20.0" (mapcar '+ b4 (list (- (+ (* d 5) c 10.0)) (- (+ c 10.0 sd)) 0.0))
		 ""
		 )
	(command "donut" "0.0" "20.0" (mapcar '+ b4 (list (- (+ (* d 5) (- c) -10.0 bw)) (- (+ c 10.0 sd)) 0.0))
		 ""
		 )
	    (command "mtext"
		   (mapcar '+ b4 (list (- (+ (* d 5) 1 (/ bw 2.0))) (- (+ c 1)) 0.0))
		   "Height"
		   "40.0"
		   (mapcar '+ b4 (list (- (+ (* d 5) 1 (/ bw 2.0))) (- (+ c 1)) 0.0))
		   (strcat "B" (itoa a))
		   ""
		   )	    
	    (setq a (1+ a))
	  )
	)
      )
      (if (eq u1 2) ;;for meters
	(progn
	  (while (<= a beamnum)
	    (alert "Select the end points of the continous beam")
	    (setq
	      p1 (getpoint
		   "Select the starting point of the continous beam"
		 )
	    )
	    (setq p2
		   (getpoint "Select the end point of the continous beam")
	    )
	    (setq span (distance p1 p2))
	    (princ span)
	    (setvar "osmode" 0)
	    (setq d
		   (getdist "Enter the depth of the beam (in meters)")
	    )
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
	    (command ".chprop" (entlast) "" "Color" "86" "")
	    (command "line" b1 b2 "")
	    (command ".chprop" (entlast) "" "Color" "86" "")
	    (command "line" b2 b3 "")
	    (command ".chprop" (entlast) "" "Color" "86" "")
	    (command "line" b3 b4 "")
	    (command ".chprop" (entlast) "" "Color" "86" "")
	    (command "line" b4 b1 "")

	    (command ".chprop" (entlast) "" "Color" "86" "")
	    (setq c
		   (float
		     (getdist "Enter the cover for steel (in meters)")
		   )
	    )
	    (setq sd
		   (getreal "What is the depth of slab? (in meters)")
	    )
	    (command "line"
		     (mapcar '+ b1 (list (* 3 c) c 0.0))
		     (mapcar '+ b2 (list (* -3 c) c 0.0))
		     ""
	    )
	    (command ".chprop" (entlast) "" "Color" "5" "")
	    (command "line"
		     (mapcar '+ b2 (list (- c) (- (* 2 c) d) 0.0))
		     (mapcar '+ b3 (list (- c) (- c) 0.0))
		     ""
	    )
	    (command ".chprop" (entlast) "" "Color" "5" "")
	    (command "line"
		     (mapcar '+ b3 (list (- c) (- c) 0.0))
		     (mapcar '+ b4 (list c (- c) 0.0))
		     ""
	    )
	    (command ".chprop" (entlast) "" "Color" "5" "")
	    (command "line"
		     (mapcar '+ b4 (list c (- c) 0.0))
		     (mapcar '+ b1 (list c (- (* 2 c) d) 0.0))
		     ""
	    )
	    (command ".chprop" (entlast) "" "Color" "5" "")
	    (setq slab_depth_line (entget (entlast)))
	    (command "dimlinear"
		     b3
		     b2
		     "Vertical"
		     (mapcar '+ b2 (list 16 0 0))
		     ""
		     ""
	    )
	    (command ".chprop" (entlast) "" "Color" "5" "")
	    (setq col (getint "How many column cross this beam?"))
	    (setq i 1)
	    (setq sp (list))
	    (alert "Select the end points of the columns in the beam")
	    (while (<= i col)
	      (setq cx1 (getpoint "Select the beginning of the column"))
	      (setq cx2 (getpoint "Select the end point of the column"))
	      (setq dis1 (- (car cx1) (car p1)))
	      (setq dis2 (- (car cx2) (car cx1)))
	      (setq bx1 (mapcar '+ b1 (list dis1 0.0 0.0)))
	      (setq bx2 (mapcar '+ bx1 (list dis2 0.0 0.0)))
	      (command "line"
		       (mapcar '- bx1 (list 0.0 (* d 1.5) 0.0))
		       (mapcar '+ bx1 (list 0.0 0.0 0.0))
		       "")
	      (command ".chprop" (entlast) "" "Color" "6" "")
	      (command "line"
		       (mapcar '+ bx1 (list 0.0 (* d 1.5) 0.0))
		       (mapcar '+ bx1 (list 0.0 d 0.0))		
		       ""
	      )
	      (command ".chprop" (entlast) "" "Color" "6" "")
	      (command
		"line"
		(mapcar	'-
			bx2
			(list (/ (distance bx1 bx2) 2) (* d 2) 0.0)
		)
		(mapcar	'+
			bx2
			(list (- (/ (distance bx1 bx2) 2)) (* d 2.5) 0.0)
		)
		""
		)
	      (command ".chprop" (entlast) "" "Color" "9" "")
	      (command ".chprop"
		       (entlast)
		       ""
		       "C"
		       "8"
		       "LType"
		       "DASHED"
		       "LTScale"
		       "25"
		       ""
	      )
	      (command "line"
		       (mapcar '- bx2 (list 0.0 (* d 1.5) 0.0))
		       (mapcar '+ bx2 (list 0.0 0.0 0.0))
		       ""
		       )
	      (command ".chprop" (entlast) "" "Color" "5" "")
	      (command "line"
		       (mapcar '+ bx2 (list 0.0 d 0.0))
		       (mapcar '+ bx2 (list 0.0 (* d 2.5) 0.0))
		       ""
	      )
	      (command ".chprop" (entlast) "" "Color" "5" "")
	      ;;(command "_layer" "n"	layername1 "C" layercolor1 layername1 "")
	      (setq scale (/ dis2 (* 12 381)))
	      (command
		"pline"
		(mapcar '+ bx1 (list 0 (* d 2.5) 0))
		(mapcar	'+
			bx1
			(list (/ (distance bx1 bx2) 4) (* d 2.5) 0)
		)
		(mapcar	'+
			bx1
			(list (/ (distance bx1 bx2) 2)
			      (+ (* d 2.5) (* d 0.2))
			      0
			)
		)
		(mapcar	'+
			bx1
			(list (/ (distance bx1 bx2) 2)
			      (+ (* d 2.5) (* d -0.2))
			      0
			)
		)
		(mapcar	'+
			bx1
			(list (/ (distance bx1 bx2) 1.3333) (* d 2.5) 0)
		)
		(mapcar '+ bx1 (list (distance bx1 bx2) (* d 2.5) 0))
		""
	      )
	      (command ".chprop" (entlast) "" "Color" "6" "")
	      (command
		"pline"
		(mapcar '+ bx1 (list 0 (* d -1.5) 0))
		(mapcar	'+
			bx1
			(list (/ (distance bx1 bx2) 4) (* d -1.5) 0)
		)
		(mapcar	'+
			bx1
			(list (/ (distance bx1 bx2) 2)
			      (+ (* d -1.5) (* d 0.2))
			      0
			)
		)
		(mapcar	'+
			bx1
			(list (/ (distance bx1 bx2) 2)
			      (+ (* d -1.5) (* d -0.2))
			      0
			)
		)
		(mapcar	'+
			bx1
			(list (/ (distance bx1 bx2) 1.3333) (* d -1.5) 0)
		)
		(mapcar '+ bx1 (list (distance bx1 bx2) (* d -1.5) 0))
		""
	      )
	      (command ".chprop" (entlast) "" "Color" "6" "")
	      (setq sp (append sp (list dis1 dis2)))
	      (setq i (1+ i))
	    )
	    (princ sp)
	    (setq b 1)
	    (while (< b (length sp))
	  (command "mtext"
		   (mapcar '+ b1 (list (- (nth (+ a 2) sp) (nth (1+ a) sp) (nth a sp)) (- d) 0.0))
		   "Height"
		   "4.0"
		   (mapcar '+ b1 (list (- (nth (+ a 2) sp) (nth (1+ a) sp) (nth a sp) 4) (- 4 d) 0.0))
		   (strcat "B" (itoa a) (chr (+ 64 a)))
		   ""
		   )
	  (setq b (1+ b))
	  )
	    ;|(command
	      "pline"
	      (mapcar '+
		      b4
		      (list (- (+ (nth 0 sp) (nth 1 sp)) c) (* d 0.1) 0)
	      )
	      (mapcar '+ b4 (list (- (* d 0.1)) (* d 0.1) 0))
	      (mapcar '+ b1 (list (* d -0.1) (- (* 2 c) d) 0.0))
	      ""
	    )
	    (command ".chprop" (entlast) "" "C" "9" "")|;
	    ;|(command
	      "pline"
	      (mapcar '+
		      b4
		      (list (- (+ (nth 0 sp) (nth 1 sp)) c) (* d 0.1) 0)
	      )
	      (mapcar '+
		      b4
		      (list (- (+ (nth 0 sp) (nth 1 sp)) c)
			    (+ (* d 0.1) (/ c 2))
			    0
		      )
	      )
	      (mapcar '+
		      b4
		      (list (+ (nth 0 sp) (nth 1 sp)) (* d 0.1) 0)
	      )
	      (mapcar '+
		      b4
		      (list (- (+ (nth 0 sp) (nth 1 sp)) c)
			    (- (* d 0.1) (/ c 2))
			    0
		      )
	      )
	      (mapcar '+
		      b4
		      (list (- (+ (nth 0 sp) (nth 1 sp)) c) (* d 0.1) 0)
	      )
	      ""
	    )
	    (command ".chprop" (entlast) "" "C" "9" "") |;
	    ;|(command
	      "pline"
	      (mapcar '+ b1 (list (* d -0.1) (- (* 2 c) d) 0.0))
	      (mapcar '+
		      b1
		      (list (- (* d -0.1) (/ c 2)) (- (* 2 c) d) 0.0)
	      )
	      (mapcar '+ b1 (list (* d -0.1) (- c d) 0.0))
	      (mapcar '+
		      b1
		      (list (+ (* d -0.1) (/ c 2)) (- (* 2 c) d) 0.0)
	      )
	      (mapcar '+ b1 (list (* d -0.1) (- (* 2 c) d) 0.0))
	      ""
	    )
	    (command ".chprop" (entlast) "" "C" "9" "")|;
	    ;|(command
	      "pline"
	      (mapcar '+
		      b1
		      (list (- (+ (nth 0 sp) (nth 1 sp)) c) (* d -0.2) 0)
	      )
	      (mapcar '+ b1 (list (- (* d 0.2)) (* d -0.2) 0))
	      (mapcar '+ b4 (list (* d -0.2) (+ d (* 4 (- c))) 0.0))
	      ""
	    )
	    (command ".chprop" (entlast) "" "C" "9" "")|;
	    ;|(command
	      "pline"
	      (mapcar '+
		      b1
		      (list (- (+ (nth 0 sp) (nth 1 sp)) c) (* d -0.2) 0)
	      )
	      (mapcar '+
		      b1
		      (list (- (+ (nth 0 sp) (nth 1 sp)) c)
			    (+ (* d -0.2) (/ c 2))
			    0
		      )
	      )
	      (mapcar '+
		      b1
		      (list (+ (nth 0 sp) (nth 1 sp)) (* d -0.2) 0)
	      )
	      (mapcar '+
		      b1
		      (list (- (+ (nth 0 sp) (nth 1 sp)) c)
			    (- (* d -0.2) (/ c 2))
			    0
		      )
	      )
	      (mapcar '+
		      b1
		      (list (- (+ (nth 0 sp) (nth 1 sp)) c) (* d -0.2) 0)
	      )
	      ""
	    ) 
	    (command ".chprop" (entlast) "" "C" "9" "") |;
	    ;|(command
	      "pline"
	      (mapcar '+ b4 (list (* d -0.2) (- d (* 4 c)) 0.0))
	      (mapcar '+
		      b4
		      (list (- (* d -0.2) (/ c 2)) (- d (* 4 c)) 0.0)
	      )
	      (mapcar '+ b4 (list (* d -0.2) (- d (* 4 c) (- c)) 0.0))
	      (mapcar '+
		      b4
		      (list (+ (* d -0.2) (/ c 2)) (- d (* 4 c)) 0.0)
	      )
	      (mapcar '+ b4 (list (* d -0.2) (- d (* 4 c)) 0.0))
	      ""
	    )
	    (command ".chprop" (entlast) "" "C" "9" "")|;
	    ;|(command "mtext"
		     (mapcar '+ b4 (list (- d) (* d 0.3) 0.0))
		     "Height"
		     "0.2"
		     (mapcar '+ b4 (list (- d) (* d 0.3) 0.0))
		     "Ld"
		     ""
	    )|;
	    (command "line"
		     (mapcar '+ b1 (list (* 2 c) (- (* 2 c) d) 0.0))
		     (mapcar '+ b4 (list (* 2 c) (* 2 (- c)) 0.0))
		     ""
	    )
	    (command "line"
		     (mapcar '+ b1 (list (* 3 c) c 0.0))
		     (mapcar '+ b4 (list (* 3 c) (+ d (* 3 (- c))) 0.0))
		     ""
	    )
	    (command "line"
		     (mapcar '+ b2 (list (* 2 (- c)) (- (* 2 c) d) 0.0))
		     (mapcar '+ b3 (list (* 2 (- c)) (* 2 (- c)) 0.0))
		     ""
	    )
	    (command
	      "line"
	      (mapcar '+ b2 (list (* 3 (- c)) c 0.0))
	      (mapcar '+ b3 (list (* 3 (- c)) (+ d (* 3 (- c))) 0.0))
	      ""
	    )
	    (setq j 0)
	    (while (< j (- (length sp) 3))
	      (command
		"dimlinear"
		(mapcar
		  '+
		  b4
		  (list (+ (nth j sp) (/ (nth (1+ j) sp) 2)) (* d 2) 0)
		)
		(mapcar	'+
			b4
			(list (+ (nth (+ j 2) sp) (/ (nth (+ j 3) sp) 2))
			      (* d 2)
			      0
			)
		)
		(mapcar
		  '+
		  b4
		  (list (+ (nth j sp) (/ (nth (1+ j) sp) 2)) (* d 2) 0)
		)
		""
	      )
	      (command
		"line"
		;;top 0.25l on the right line
		(mapcar	'+
			b4
			(list (* 2 c) (* 2 (- c)) 0.0)
			(list (nth j sp) 0 0)
		)
		(mapcar	'+
			b4
			(list 0 (* 2 (- c)) 0.0)
			(list (+ (nth j sp) (nth (1+ j) sp)) 0 0)
			(list (qd:roundup
				(* 0.3
				   (- (nth (+ j 2) sp)
				      (/ (nth (1+ j) sp) 2)
				      (nth j sp)
				      (- (/ (nth (+ j 3) sp) 2))
				   )
				)
				0.075
			      )
			      0
			      0
			)
		)
		""
	      )
	      (command
		"dimlinear"
		(mapcar
		  '+
		  b4
		  (list (+ (nth j sp) (nth (1+ j) sp)) (* d 0.75) 0)
		)
		;;top 0.25l on the right dimension
		(mapcar	'+
			b4
			(list (+ (nth j sp)
				 (nth (1+ j) sp)
				 (qd:roundup
				   (* 0.3
				      (- (nth (+ j 2) sp)
					 (/ (nth (1+ j) sp) 2)
					 (nth j sp)
					 (- (/ (nth (+ j 3) sp) 2))
				      )
				   )
				   0.075
				 )
			      )
			      0
			      0
			)
		)
		"Horizontal"
		(mapcar
		  '+
		  b4
		  (list (+ (nth j sp) (nth (1+ j) sp)) (* d 0.75) 80)
		)
		""
	      )
	      (command
		;;top 0.25l on the left side
		"line"
		(mapcar	'+
			b4
			(list (* -2 c) (* 2 (- c)) 0.0)
			(list (nth (+ j 2) sp) 0 0)
			(list (- (qd:roundup
				   (* 0.3
				      (- (nth (+ j 2) sp)
					 (nth j sp)
					 (/ (nth (1+ j) sp) 2)
					 (/ (- (nth (+ j 3) sp)) 2)
				      )
				   )
				   0.075
				 )
			      )
			      0
			      0
			)
		)
		(mapcar	'+
			b4
			(list (* -2 c) (* 2 (- c)) 0.0)
			(list (+ (nth (+ j 2) sp) (nth (+ j 3) sp)) 0 0)
		)
		""
	      )
	      (command
		"dimlinear"
		;;top 0.25l on the left side
		(mapcar	'+
			b4
			(list (- (nth (+ j 2) sp)
				 (qd:roundup
				   (* 0.3
				      (- (nth (+ j 2) sp)
					 (nth j sp)
					 (/ (nth (1+ j) sp) 2)
					 (/ (- (nth (+ j 3) sp)) 2)
				      )
				   )
				   0.075
				 )
			      )
			      (* d 0.5)
			      0
			)
		)
		;;top 0.25 on the left side
		(mapcar '+ b4 (list (nth (+ j 2) sp) (* d 0.75) 0))
		"Horizontal"
		(mapcar '+ b4 (list (nth (+ j 2) sp) (* d 0.75) 0))
		""
	      )
	      (command
		"dimlinear"
		(mapcar	'+
			b1
			(list (+ (nth (+ j 1) sp) (nth j sp)) (* d -2) 0)
		)
		(mapcar	'+
			b1
			(list (+ (nth (+ j 1) sp)
				 (nth j sp)
				 (qd:roundup
				   (* 0.3
				      (- (nth (+ j 2) sp)
					 (nth (1+ j) sp)
					 (nth j sp)
				      )
				   )
				   0.075
				 )
			      )
			      (* d -2)
			      0
			)
		)
		"Horizontal"
		(mapcar	'+
			b1
			(list (+ (nth (+ j 1) sp) (nth j sp)) (* d -2) 0)
		)
		""
	      )
	      (setq ent1 (entlast))
	      (entmod (subst (cons 1 "Stirrups at Support")
			     (assoc 1 (entget ent1))
			     (entget ent1)
		      )
	      )
	      (command "dimlinear"
		       (mapcar '+
			       b1
			       (list (+	(nth (+ j 1) sp)
					(nth j sp)
					(qd:roundup
					  (* 0.3
					     (-	(nth (+ j 2) sp)
						(nth (1+ j) sp)
						(nth j sp)
					     )
					  )
					  0.075
					)
				     )
				     (* d -2)
				     0
			       )
		       )
		       (mapcar '+
			       b1
			       (list (-	(nth (+ j 2) sp)
					(qd:roundup
					  (* 0.3
					     (-	(nth (+ j 2) sp)
						(nth (1+ j) sp)
						(nth j sp)
					     )
					  )
					  0.075
					)
				     )
				     (* d -2)
				     0
			       )
		       )
		       "Horizontal"
		       (mapcar '+
			       b1
			       (list (+	(nth (+ j 1) sp)
					(nth j sp)
					(qd:roundup
					  (* 0.3
					     (-	(nth (+ j 2) sp)
						(nth (1+ j) sp)
						(nth j sp)
					     )
					  )
					  0.075
					)
				     )
				     (* d -2)
				     0
			       )
		       )
		       ""
	      )
	      (setq ent2 (entlast))
	      (entmod (subst (cons 1 "Stirrups at MidSpan")
			     (assoc 1 (entget ent2))
			     (entget ent2)
		      )
	      )
	      (command "dimlinear"
		       (mapcar '+
			       b1
			       (list (-	(nth (+ j 2) sp)
					(qd:roundup
					  (* 0.3
					     (-	(nth (+ j 2) sp)
						(nth (1+ j) sp)
						(nth j sp)
					     )
					  )
					  0.075
					)
				     )
				     (* d -2)
				     0
			       )
		       )
		       (mapcar '+ b1 (list (nth (+ j 2) sp) (* d -2) 0))
		       "Horizontal"
		       (mapcar '+ b1 (list (nth (+ j 2) sp) (* d -2) 0))
		       ""
	      )
	      (setq ent3 (entlast))
	      (entmod (subst (cons 1 "Stirrups at Supports")
			     (assoc 1 (entget ent3))
			     (entget ent3)
		      )
	      )

	      (if (and (/= j 0) (/= j (- (length sp) 2)))
		(progn
		  (command
		    "line"
		    (mapcar
		      '+
		      b1
		      (list 0 (* 2 c) 0)
		      (list (+ (nth j sp) (/ (nth (1+ j) sp) 2)) 0 0)
		      (list (qd:rounddown
			      (* 0.15
				 (- (nth (+ j 2) sp)
				    (nth j sp)
				    (/ (nth (1+ j) sp) 2)
				    (/ (- (nth (+ j 3) sp)) 2)
				 )
			      )
			      0.075
			    )
			    0
			    0
		      )
		    )
		    (mapcar
		      '+
		      b1
		      (list 0 (* 2 c) 0)
		      (list (+ (nth (+ j 2) sp) (/ (nth (+ j 3) sp) 2))
			    0
			    0
		      )
		      (list (- (qd:rounddown
				 (* 0.15
				    (- (nth (+ j 2) sp)
				       (nth j sp)
				       (/ (nth (1+ j) sp) 2)
				       (/ (- (nth (+ j 3) sp)) 2)
				    )
				 )
				 0.075
			       )
			    )
			    0
			    0
		      )
		    )
		    ""
		  )
		  (command
		    "dimlinear"
		    (mapcar '+
			    b1
			    (list (+ (nth j sp) (/ (nth (1+ j) sp) 2))
				  (* d -0.5)
				  0
			    )
		    )
		    (mapcar '+
			    b1
			    (list (+ (nth j sp)
				     (/ (nth (1+ j) sp) 2)
				     (qd:rounddown
				       (* 0.15
					  (- (nth (+ j 2) sp)
					     (nth j sp)
					     (/ (nth (1+ j) sp) 2)
					     (/ (- (nth (+ j 3) sp)) 2)
					  )
				       )
				       0.075
				     )
				  )
				  (* d -0.5)
				  0
			    )
		    )
		    "Horizontal"
		    (mapcar
		      '+
		      b1
		      (list (+ (nth j sp) (nth (1+ j) sp)) (* d -0.5) 0)
		    )
		    ""
		  )
		  (command
		    "dimlinear"
		    (mapcar '+
			    b1
			    (list (- (nth (+ j 2) sp)
				     (- (/ (nth (+ j 3) sp) 2))
				     (qd:rounddown
				       (* 0.15
					  (- (nth (+ j 2) sp)
					     (nth j sp)
					     (/ (nth (1+ j) sp) 2)
					  )
				       )
				       0.075
				     )
				  )
				  (* d -0.5)
				  0
			    )
		    )
		    (mapcar
		      '+
		      b1
		      (list (+ (nth (+ j 2) sp) (/ (nth (+ j 3) sp) 2))
			    (* d -0.5)
			    0
		      )
		    )
		    "Horizontal"
		    (mapcar
		      '+
		      b1
		      (list (+ (nth (+ j 2) sp) (/ (nth (+ j 3) sp) 2))
			    (* d -0.5)
			    0
		      )
		    )
		    ""
		  )
		)
		(progn
		  (if (eq j 0)
		    (progn
		      (command
			"line"
			(mapcar
			  '+
			  b1
			  (list 0 (* 2 c) 0)
			  (list	(+ (nth j sp) (/ (nth (1+ j) sp) 2))
				0
				0
			  )
			  (list	(qd:rounddown
				  (* 0.15
				     (-	(nth (+ j 2) sp)
					(nth j sp)
					(/ (nth (1+ j) sp) 2)
					(/ (- (nth (+ j 3) sp)) 2)
				     )
				  )
				  0.075
				)
				0
				0
			  )
			)
			(mapcar
			  '+
			  b1
			  (list 0 (* 2 c) 0)
			  (list
			    (+ (nth (+ j 2) sp) (/ (nth (+ j 3) sp) 2))
			    0
			    0
			  )
			  (list	(- (qd:rounddown
				     (*	0.15
					(- (nth (+ j 2) sp)
					   (nth j sp)
					   (/ (nth (1+ j) sp) 2)
					   (/ (- (nth (+ j 3) sp)) 2)
					)
				     )
				     0.075
				   )
				)
				0
				0
			  )
			)
			""
		      )
		      (command
			"dimlinear"
			(mapcar
			  '+
			  b1
			  (list	(+ (nth j sp) (/ (nth (1+ j) sp) 2))
				(* d -0.5)
				0
			  )
			)
			(mapcar
			  '+
			  b1
			  (list	(+ (nth j sp)
				   (/ (nth (1+ j) sp) 2)
				   (qd:rounddown
				     (*	0.15
					(- (nth (+ j 2) sp)
					   (nth j sp)
					   (/ (nth (1+ j) sp) 2)
					   (/ (- (nth (+ j 3) sp)) 2)
					)
				     )
				     0.075
				   )
				)
				(* d -0.5)
				0
			  )
			)
			"Horizontal"
			(mapcar
			  '+
			  b1
			  (list	(+ (nth j sp) (/ (nth (1+ j) sp) 2))
				(* d -0.5)
				0
			  )
			)
			""
		      )
		      (command
			"dimlinear"
			(mapcar
			  '+
			  b1
			  (list	(- (nth (+ j 2) sp)
				   (/ (- (nth (+ j 3) sp)) 2)
				   (qd:rounddown
				     (*	0.15
					(- (nth (+ j 2) sp)
					   (nth j sp)
					   (/ (nth (1+ j) sp) 2)
					   (/ (- (nth (+ j 3) sp)) 2)
					)
				     )
				     0.075
				   )
				)
				(* d -0.5)
				0
			  )
			)
			(mapcar
			  '+
			  b1
			  (list
			    (+ (nth (+ j 2) sp) (/ (nth (+ j 3) sp) 2))
			    (* d -0.5)
			    0
			  )
			)
			"Horizontal"
			(mapcar	'+
				b1
				(list (nth (+ j 2) sp) (* d -0.5) 0)
			)
			""
		      )
		    )
		  )
		  (if (eq j (- (length sp) 3))
		    (progn
		      (command
			"line"
			(mapcar
			  '+
			  b1
			  (list 0 (* 2 c) 0)
			  (list	(+ (nth (- (length sp) 4) sp)
				   (/ (nth (- (length sp) 3) sp) 2)
				)
				0
				0
			  )
			  (list
			    (qd:rounddown
			      (* 0.15
				 (- (nth (- (length sp) 2) sp)
				    (nth (- (length sp) 4) sp)
				    (/ (nth (- (length sp) 3) sp) 2)
				    (/ (- (nth (- (length sp) 1) sp)) 2)
				 )
			      )
			      0.075
			    )
			    0
			    0
			  )
			)
			(mapcar
			  '+
			  b1
			  (list 0 (* 2 c) 0)
			  (list	(+ (nth (- (length sp) 2) sp)
				   (/ (nth (- (length sp) 1) sp) 2)
				)
				0
				0
			  )
			  (list
			    (-
			      (qd:rounddown
				(*
				  0.15
				  (- (nth (- (length sp) 2) sp)
				     (nth (- (length sp) 4) sp)
				     (/ (nth (- (length sp) 3) sp) 2)
				     (/ (- (nth (- (length sp) 1) sp)) 2)
				  )
				)
				0.075
			      )
			    )
			    0
			    0
			  )
			)
			""
		      )
		      (command
			"dimlinear"
			(mapcar	'+
				b1
				(list (+ (/ (nth (- (length sp) 3) sp) 2)
					 (nth (- (length sp) 4) sp)
				      )
				      (* d -0.5)
				      0
				)
			)
			(mapcar
			  '+
			  b1
			  (list
			    (+
			      (/ (nth (- (length sp) 3) sp) 2)
			      (nth (- (length sp) 4) sp)
			      (qd:rounddown
				(*
				  0.15
				  (- (nth (- (length sp) 2) sp)
				     (nth (- (length sp) 4) sp)
				     (/ (nth (- (length sp) 3) sp) 2)
				     (/ (- (nth (- (length sp) 1) sp)) 2)
				  )
				)
				0.075
			      )
			    )
			    (* d -0.5)
			    0
			  )
			)
			"Horizontal"
			(mapcar	'+
				b1
				(list (+ (/ (nth (- (length sp) 3) sp) 2)
					 (nth (- (length sp) 4) sp)
				      )
				      (* d -0.5)
				      0
				)
			)
			""
		      )
		      (command
			"dimlinear"
			(mapcar
			  '+
			  b1
			  (list
			    (-
			      (nth (- (length sp) 2) sp)
			      (- (/ (nth (- (length sp) 1) sp) 2))
			      (qd:rounddown
				(*
				  0.15
				  (- (nth (- (length sp) 2) sp)
				     (nth (- (length sp) 4) sp)
				     (/ (nth (- (length sp) 3) sp) 2)
				     (/ (- (nth (- (length sp) 1) sp)) 2)
				  )
				)
				0.075
			      )
			    )
			    (* d -0.5)
			    0
			  )
			)
			(mapcar	'+
				b1
				(list (+ (nth (- (length sp) 2) sp)
					 (/ (nth (- (length sp) 1) sp) 2)
				      )
				      (* d -0.5)
				      0
				)
			)
			"Horizontal"
			(mapcar	'+
				b1
				(list (+ (nth (- (length sp) 2) sp)
					 (/ (nth (- (length sp) 1) sp) 2)
				      )
				      (* d -0.5)
				      0
				)
			)
			""
		      )
		    )
		  )
		)
	      )
	      (setq b 1)
	      (while
		(<= (* b ss)
		    (qd:roundup
		      (* 0.3
			 (- (nth (+ j 2) sp) (nth (1+ j) sp) (nth j sp))
		      )
		      0.075
		    )
		)
		 (progn
		   (command
		     "line"
		     (mapcar
		       '-
		       b4
		       (list (* b (- ss)) (/ c 2) 0.0)
		       (list (- (+ (nth j sp) (nth (1+ j) sp))) 0.0 0.0)
		     )
		     (mapcar '+
			     b1
			     (list (* b ss) (/ c 2) 0.0)
			     (list (+ (nth j sp) (nth (1+ j) sp)) 0.0 0.0)
		     )
		     ""
		   )
		   (command ".chprop" (entlast) "" "C" "11" "")
		   (setq b (1+ b))
		 )
	      )
	      (setq e 1)
	      (while
		(<= (* e ss)
		    (qd:roundup
		      (* 0.3
			 (- (nth (+ j 2) sp) (nth (1+ j) sp) (nth j sp))
		      )
		      0.075
		    )
		)
		 (progn
		   (command "line"
			    (mapcar '-
				    b4
				    (list (* e ss) (/ c 2) 0.0)
				    (list (- (nth (+ j 2) sp)) 0.0 0.0)
			    )
			    (mapcar '+
				    b1
				    (list (* e (- ss)) (/ c 2) 0.0)
				    (list (nth (+ j 2) sp) 0.0 0.0)
			    )
			    ""
		   )
		   (command ".chprop" (entlast) "" "C" "11" "")
		   (setq e (1+ e))
		 )
	      )
	      (setq j (+ j 2))
	    )
	    (setq beam_no
		   (getint
		     "Now, please enter the number of beams crossing the main beam"
		   )
	    )
	    (setq end_of_last_beam 0)
	    (setq bnum 1)
	    (while (<= bnum beam_no)
	      (setq cb1 (getpoint "Select the beginning of the beam"))
	      (setq cb2 (getpoint "Select the end of the beam"))
	      (setq d1 (- (car cb1) (car p1)))
	      (setq d2 (- (car cb2) (car cb1)))
	      (setq cbx1 (mapcar '+ b1 (list d1 0.0 0.0)))
	      (setq cbx2 (mapcar '+ cbx1 (list d2 0.0 0.0)))
	      (command "line"
		       (mapcar '+ b4 (list end_of_last_beam (- sd) 0))
		       (mapcar '+ b4 (list d1 (- sd) 0))
		       ""
	      )
	      (command ".chprop"
		       (entlast)
		       ""
		       "Color"
		       "93"
		       "Ltype"
		       "DASHED"
		       "LTScale"
		       "2.5"
		       ""
	      )
	      (command "line"
		       (mapcar '+ cbx1 (list 0.0 (- d sd) 0.0))
		       (mapcar '+ cbx1 (list 0.0 0.0 0.0))
		       ""
	      )
	      (command ".chprop"
		       (entlast)
		       ""
		       "Color"
		       "93"
		       "Ltype"
		       "DASHED"
		       "LTScale"
		       "2.5"
		       ""
	      )
	      (setq beamline1 (entget (entlast)))
	      (command "line"
		       (mapcar '+ cbx2 (list 0.0 (- d sd) 0.0))
		       (mapcar '+ cbx2 (list 0.0 0.0 0.0))
		       ""
	      )
	      (command ".chprop"
		       (entlast)
		       ""
		       "Color"
		       "93"
		       "Ltype"
		       "DASHED"
		       "LTScale"
		       "2.5"
		       ""
	      )
	      (setq end_of_last_beam (+ d1 d2))
	      ;;(command "trim" beamline1 "" beamline2 "" slab_depth_line "")
	      ;;(command "_-hatch" (getpoint "Pick the internal point to hatch") "_p" "Solid" "0.25" "0.0" "")
	      (setq bnum (1+ bnum))
	    )
	    (setq bw (getreal "Enter the width of the beam"))
	(command "pline"
		 (mapcar '+ b4 (list (* d -4.5) (- sd) 0.0))
		 (mapcar '+ b4 (list (* d -5) (- sd) 0.0))
		 (mapcar '+ b4 (list (* d -5) (- d) 0.0))
		 (mapcar '+ b4 (list (+ (* d -5) (- bw)) (- d) 0.0))
		 (mapcar '+ b4 (list (+ (* d -5) (- bw)) (- sd) 0.0))
		 (mapcar '+ b4 (list (+ (* d -5.5) (- bw)) (- sd) 0.0))
		 ""
		 )
	(command ".chprop" (entlast) "" "Color" "6" "")
	(command "line"
		 (mapcar '+ b4 (list (* d -4.5) 0.0 0.0))
		 (mapcar '+ b4 (list (- (+ (* d 5.5) bw)) 0.0 0.0))
		 ""
		 )
	(command ".chprop" (entlast) "" "Color" "6" "")
	(command "pline"
		 (mapcar '+ b4 (list (* d -4.5) (* d 0.1) 0.0))
		 (mapcar '+ b4 (list (* d -4.5) (- (/ sd 6)) 0.0))
		 (mapcar '+ b4 (list (* d -4.4) (- (/ sd 2)) 0.0))
		 (mapcar '+ b4 (list (* d -4.6) (- (/ sd 2)) 0.0))
		 (mapcar '+ b4 (list (* d -4.5) (- (* sd (/ 5.0 6.0))) 0.0))
		 (mapcar '+ b4 (list (* d -4.5) (- (+ sd (* d 0.1))) 0.0))
		 ""
		 )
	(command ".chprop" (entlast) "" "Color" "6" "")
	(command "pline"
		 (mapcar '+ b4 (list (- (+ bw (* d 5.5))) (* d 0.1) 0.0))
		 (mapcar '+ b4 (list (- (+ bw (* d 5.5))) (- (/ sd 6)) 0.0))
		 (mapcar '+ b4 (list (- (+ bw (* d 5.4))) (- (/ sd 2)) 0.0))
		 (mapcar '+ b4 (list (- (+ bw (* d 5.6))) (- (/ sd 2)) 0.0))
		 (mapcar '+ b4 (list (- (+ bw (* d 5.5))) (- (* sd (/ 5.0 6.0))) 0.0))
		 (mapcar '+ b4 (list (- (+ bw (* d 5.5))) (- (+ sd (* d 0.1))) 0.0))
		 ""
		 )
	(command ".chprop" (entlast) "" "Color" "6" "")
	(command "rectang" "f" 1 (mapcar '+ b1 (list (- (+ bw (* d 5) (- c))) c 0.0))
		 (mapcar '+ b4 (list (+ (* d -5) (- c)) (- c) 0.0))
		 ""
		 )
	(command "donut" "0.0" "2.0" (mapcar '+ b1 (list (- (+ bw (* d 5) (- c) -1)) (+ c 1) 0.0))
		 ""
		 )
	(command "donut" "0.0" "2.0" (mapcar '+ b1 (list (- (+ (* d 5) c 1)) (+ c 1) 0.0))
		 ""
		 )
	(command "donut" "0.0" "2.0" (mapcar '+ b1 (list (- (+ (* d 5) 1 (/ bw 2.0))) (+ c 1) 0.0))
		 ""
		 )
	(command "donut" "0.0" "2.0" (mapcar '+ b4 (list (- (+ (* d 5) c 1)) (- (+ c 1)) 0.0))
		 ""
		 )
	(command "donut" "0.0" "2.0" (mapcar '+ b4 (list (- (+ (* d 5) (- c) -1 bw)) (- (+ c 1)) 0.0))
		 ""
		 )
	(command "donut" "0.0" "2.0" (mapcar '+ b4 (list (- (+ (* d 5) 1 (/ bw 2.0))) (- (+ c 1)) 0.0))
		 ""
		 )
	(command "donut" "0.0" "2.0" (mapcar '+ b4 (list (- (+ (* d 5) c 1)) (- (+ c 1 sd)) 0.0))
		 ""
		 )
	(command "donut" "0.0" "2.0" (mapcar '+ b4 (list (- (+ (* d 5) (- c) -1 bw)) (- (+ c 1 sd)) 0.0))
		 ""
		 )
	    (command "mtext"
		   (mapcar '+ b4 (list (- (+ (* d 5) 1 (/ bw 2.0))) (- (+ c 1)) 0.0))
		   "Height"
		   "4.0"
		   (mapcar '+ b4 (list (- (+ (* d 5) 1 (/ bw 2.0))) (- (+ c 1)) 0.0))
		   (strcat "B" (itoa a))
		   ""
		   )
	    (setq a (1+ a))
	  )
	)
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