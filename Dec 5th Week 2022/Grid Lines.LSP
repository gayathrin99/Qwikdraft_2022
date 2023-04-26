(princ "Type \"GL\" into your command line")
(defun c:gl (/)
  ;;(princ "Grid Line drawing")
  (setvar "osmode" 0)
 ;; (setvar "INSUNITS" 4)
  (setq wall (entsel "Select a wall line"))
  (setq width (getint "What is the wall thickness"))
  (setq entlist (entget (car wall)))
  (setq i 0)
  (repeat (setq i (length entlist))
    (if	(= (car (nth i entlist)) 0)
      (setq enttype (cdr (nth i entlist)))
    )
    (if	(= (car (nth i entlist)) 8)
      (setq layername (cdr (nth i entlist)))
    )
    (setq i (1- i))
  )
  (setq sp (list))
  (setq ss (ssget "_X" (list (cons 0 enttype) (cons 8 layername))))
  (repeat (setq in (sslength ss))
    (vla-highlight
      (vlax-ename->vla-object (ssname ss (setq in (1- in))))
      :vlax-true
    )
    (setq ent (entget (ssname ss in)))
    (setq sp (append (list (cdr (assoc 10 ent))) sp))
  )
  (princ "Before qsort")
  (repeat (setq x (length sp))
    (princ (nth x sp))
    (princ "\n")
    (setq x (1- x))
  )

  (setq sp (qsort_x sp))
  (princ "After qsort along x")
  ;;(princ (qsort sp))
  (repeat (setq x (- (length sp) 1))
    (repeat (setq x1 (- (length sp) 2))
    (if
      (or (= (- (nth 1 (nth x sp)) (nth 1 (nth x1 sp))) width)
	  (= (- (nth 1 (nth x sp)) (nth 1 (nth x1 sp))) (- width))
      )
       (progn
	 (if (< (nth 1 (nth x sp)) (nth 1 (nth x1 sp))) 
	 (command "line"
		  (mapcar '+ (nth x sp) (list 100 (/ width 2) 0))
		  (mapcar '+ (nth x sp) (list -100 (/ width 2) 0))
		  ""
	 )
	  (command "line"
		  (mapcar '+ (nth x1 sp) (list 100 (/ width 2) 0))
		  (mapcar '+ (nth x1 sp) (list -100 (/ width 2) 0))
		  ""
	 )
	   )
	 (command ".chprop"
		  (entlast)
		  ""
		  "Color"
		  "TrueColor"
		  "128,128,128"
		  ""
	 )
	 (princ "Grid line drawn")
       )
    )
    (if	(or (= (- (car (nth x sp)) (car (nth x1 sp))) width)
	    (= (- (car (nth x sp)) (car (nth x1 sp))) (- width))
	)
      (progn
	(if (< (car (nth x sp)) (car (nth x1 sp)))
	(command "line"
		 (mapcar '+ (nth x sp) (list (/ width 2) 100 0))
		 (mapcar '+ (nth x sp) (list (/ width 2) -100 0))
		 ""
	)
	  (command "line"
		 (mapcar '+ (nth x1 sp) (list (/ width 2) 100 0))
		 (mapcar '+ (nth x1 sp) (list (/ width 2) -100 0))
		 ""
	))
	(command ".chprop" (entlast) "" "Color" "TrueColor" "128,128,128" "")
	(princ "Grid line drawn")
      )
    )
      (setq x1 (1- x1))
      )
    (princ (nth x sp))
    (princ "\n")
    (setq x (1- x))
  )
  (setq sp (qsort_y sp))
  (princ "After qsort along y")
  (repeat (setq y (- (length sp) 1))
    (repeat (setq y1 (- (length sp) 2))
    (if
      (or (= (- (nth 1 (nth y sp)) (nth 1 (nth y1 sp))) width)
	  (= (- (nth 1 (nth y sp)) (nth 1 (nth y1 sp))) (- width))
      )
      (progn
	(if (< (nth 1 (nth y sp)) (nth 1 (nth y1 sp)))
	 (command "line"
		  (mapcar '+ (nth y sp) (list 100 (/ width 2) 0))
		  (mapcar '+ (nth y sp) (list -100 (/ width 2) 0))
		  ""
	 )
	  (command "line"
		  (mapcar '+ (nth y1 sp) (list 100 (/ width 2) 0))
		  (mapcar '+ (nth y1 sp) (list -100 (/ width 2) 0))
		  ""
	 )
	  )
	 (command ".chprop"
		  (entlast)
		  ""
		  "Color"
		  "TrueColor"
		  "128,128,128"
		  ""
	 )
	 (princ "Grid line drawn")
       )
    )
    (if	(or (= (- (car (nth y sp)) (car (nth y1 sp))) width)
	    (= (- (car (nth y sp)) (car (nth y1 sp))) (- width))
	) 
      (progn
	(if (< (car (nth y sp)) (car (nth y1 sp)))
	(command "line"
		 (mapcar '+ (nth y sp) (list (/ width 2) 100 0))
		 (mapcar '+ (nth y sp) (list (/ width 2) -100 0))
		 ""
	)
	  (command "line"
		 (mapcar '+ (nth y1 sp) (list (/ width 2) 100 0))
		 (mapcar '+ (nth y1 sp) (list (/ width 2) -100 0))
		 ""
	)
	  )
	(command ".chprop" (entlast) "" "Color" "TrueColor" "128,128,128" "")
	(princ "Grid line drawn")
      )
    )
      (setq y1 (1- y1))
      )
    (princ (nth y sp))
    (princ "\n")
    (setq y (1- y))
  )
  (setq sp nil)
)

(defun qsort_x (L)
  (cond
    ((null L) nil)
    (t
     (append
       (qsort_x (list<_x (car L) (cdr L)))
       (cons (car L) nil)
       (qsort_x (list>=_x (car L) (cdr L)))
     )
    )
  )
)

(defun list<_x (a b)
  (cond
    ((or (null a) (null b)) nil)
    ((< (car a) (car (car b))) (list<_x a (cdr b)))
    (t (cons (car b) (list<_x a (cdr b))))
  )
)

(defun list>=_x (a b)
  (cond
    ((or (null a) (null b)) nil)
    ((>= (car a) (car (car b))) (list>=_x a (cdr b)))
    (t (cons (car b) (list>=_x a (cdr b))))
  )
)
(defun qsort_y (L)
  (cond
    ((null L) nil)
    (t
     (append
       (qsort_y (list<_y (car L) (cdr L)))
       (cons (car L) nil)
       (qsort_y (list>=_y (car L) (cdr L)))
     )
    )
  )
)

(defun list<_y (a b)
  (cond
    ((or (null a) (null b)) nil)
    ((< (nth 1 a) (nth 1 (car b))) (list<_y a (cdr b)))
    (t (cons (car b) (list<_y a (cdr b))))
  )
)

(defun list>=_y (a b)
  (cond
    ((or (null a) (null b)) nil)
    ((>= (nth 1 a) (nth 1 (car b))) (list>=_y a (cdr b)))
    (t (cons (car b) (list>=_y a (cdr b))))
  )
)