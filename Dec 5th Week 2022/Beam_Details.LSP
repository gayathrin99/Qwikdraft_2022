(if (or	ADOLISP_ConnectToDB
	(and (findfile "ADOLISP_Library.LSP")
	     (load "ADOLISP_Library.LSP")
	)
    )
  (progn
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
      (setq beamnum (getint "How many beams in total?"))
      (setq a 1)
      (while (<= a beamnum)
	(alert "Select the end points of the beam")
	(setq p1 (getpoint "Select the starting point of the beam"))
	(setq p2 (getpoint "Select the end point of the beam"))
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
	(command "dimlin"
		 (mapcar '+ b4 (list c (- c) 0))
		 (mapcar '+ b1 (list c c 0)) "H" ""
		 (mapcar '+ b1 (list (+ c 200) c 0.0)) 
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
		   (mapcar '- bx1 (list 0.0 (* d 3) 0.0))
		   (mapcar '+ bx1 (list 0.0 (* d 3) 0.0))
		   ""
	  )
	  (command "line"
		   (mapcar '- bx2 (list 0.0 (* d 3) 0.0))
		   (mapcar '+ bx2 (list 0.0 (* d 3) 0.0))
		   ""
	  )
	  (command "_layer" "n"	layername1 "C" layercolor1 layername1 "")
	  (command "_.INSERT"
		   drawing
		   (mapcar '+ bx1 (list -15 (* d 3) 0.0))
		   "0.05"
		   "0.05"
		   ""
		   ""
	  )
	  (command-s)
	  (command "_.INSERT"
		   drawing
		   (mapcar '+ bx1 (list -15 (* d -3) 0.0))
		   "0.05"
		   "0.05"
		   ""
		   ""
	  )
	  (command-s)
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
			  (* 0.33 (- (nth 2 sp) (nth 1 sp) (nth 0 sp)))
			  3
			)
			0
			0
		  )
	  )
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
	      (command
		"line"
		(mapcar	'+
			b4
			(list 0 (* 2 (- c)) 0.0)
			(list (nth (+ j 2) sp) 0 0)
			(list (- (qd:roundup (* 0.33 span1) 3)) 0 0)
		)
		(mapcar	'+
			b4
			(list 0 (* 2 (- c)) 0.0)
			(list (+ (nth (+ j 2) sp) (nth (+ j 3) sp)) 0 0)
			(list (qd:roundup (* 0.33 span2) 3) 0 0)
		)
		""
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
		(command
		  "dimlin"
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
		  (mapcar '+
			  b1
			  (list 0 (* 2 c) 80)
			  (list (nth (+ j 2) sp) 0 0)
			  (list (- (qd:rounddown (* 0.15 span1) 3)) 0 0)
		  )
		  ""
		)
		(command-s)
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
		(command
		  "dimlin"
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
		  (mapcar '+
			  b1
			  (list 0 (* 2 c) 0)
			  (list (nth (+ j 4) sp) 20 0)
			  (list (- (qd:rounddown (* 0.15 span2) 3)) 0 0)
		  )
		  ""
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
		 (mapcar '-
			 b3
			 (list 0 (* 2 c) 0)
			 (list (nth (1- (length sp)) sp) 0 0)
			 (list (qd:roundup
				 (* 0.33
				    (- (nth (- (length sp) 2) sp)
				       (nth (- (length sp) 3) sp)
				       (nth (- (length sp) 4) sp)
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

	(setq a (1+ a))
      )
      (if (> 20221130 (getvar "cdate"))
	(progn
	  (princ
	    "\n*** This version of Qwikdraft software has expired***"
	  )
	  (exit)
	)
      )
      (IF (EQ
	    (setq ConnectionObject
		   (ADOLISP_ConnectToDB
		     "Driver={MySQL ODBC 3.51 Driver};Server=bom1plzcpnl494592.prod.bom1.secureserver.net;Database=email_addresses;UID=gayathri_qwikdraft;PWD=,rO=nhK[8"
		     "gayathri_qwikdraft"
		     ",rO=nhK[8"
		   )
	    )
	    NIL
	  )
	(ADOLISP_ErrorPrinter)
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
    ;;(entget (car (entsel "select")))

  )
  (progn
    (defun c:beamdet ()
      (alert
	"Can't find ADOLISP.LSP \nFix the problem and reload."
      )
    )
    (defun qd:roundup ()
      (alert
	"Can't find ADOLISP.LSP \nFix the problem and reload."
      )
    )
    (defun qd:rounddown	()
      (alert
	"Can't find ADOLISP.LSP \nFix the problem and reload."
      )
    )
  )
)
 ;|(vl-object-com)

(setq currConnectionString "Provider=MSDASQL;Driver={MySQL ODBC 3.51 Driver};Server=bom1plzcpnl494592;Database=email_addresses;UID=gayathri_qwikdarft;PWD=,rO=nhK[8;Persist Security Inf=False;Integrated Security=SSPI"
   )+


;|(vlax-invoke-method
     ADOConnect "Open" currConnectionString "" "" -1)
(open "https://qwikdraft.com/TRIAL 3.docx" "r")
(startapp "explorer" "https://docs.google.com/document/d/1HA8ZP5RjF2LWfF22oLZiWcaXMJiZR3I0JgYCSrErNjc/edit")|;
 ;|(defun readwwwtxt ( / obj rtn )
  (if (setq obj (vlax-get-or-create-object "winhttp.winhttprequest.5.1"))
            (progn
                (setq rtn
                    (vl-catch-all-apply
                        (function
                            (lambda ( )
                                (vlax-invoke-method obj 'open "GET"
                                    (strcat 
                                        "http://www.theswamp.org/lilly.pond/public/GetFileFromURL.txt"
                                    )
                                    :vlax-false
                                )
                                (vlax-invoke-method obj 'send)
                                (vlax-get-property  obj 'responsebody)
                            )
                        )
                    )
                )
                (vlax-release-object obj)
                (if (vl-catch-all-error-p rtn)
                    (princ (vl-catch-all-error-message rtn))
                    (princ
                        (vl-list->string
                            (mapcar '(lambda ( x ) (lsh (lsh x 24) -24))
                                (vlax-safearray->list (vlax-variant-value rtn))
                            )
                        )
                    )
                )
            )
        )
)
(setq simple (readwwwtxt))
(setq simple (strcat simple "isucks"))|;
(vl-load-com)
(defun c:Example_PutRemoteFile ()
  ;; This example transfers a local file to a remote URL.  Since this example
  ;; relies on both a remote server name and a local file, you will have to
  ;; modify both the DestURL and LocalFile variables below to run this example.
  (setq acadObj (vlax-get-acad-object))
  (setq doc (vla-get-ActiveDocument acadObj))

  ;; Define source and destination
  (setq DestURL "ftp://ftp.qwikdraft.com/")
  (setq
    LocalFile "E:\\purvaja\\WDBM\\LISP\\QWIKDRAFT\\AUTOLISP\\test.txt"
  )

  ;; Transfer local file to remote location
  (vla-PutRemoteFile (vla-get-Utility doc) DestURL LocalFile)

  (alert
    (strcat LocalFile " was just transfered to: " DestURL)
  )
)

(command "_dimlinear" (getpoint "//select a point") (getpoint "**select a point") "v" "" 2000 "")