(princ "Enter \'COLBARBEN\' into the command line")
(defun c:colbarben ()
  (if (< 20230515 (getvar "cdate"))
    (progn
      (princ "\n*** This version of Qwikdraft software has expired***")
      (exit)
      )
    (progn
      (setvar "INSUNITS" 4)
      (setvar "cmdecho" 0)
      (setq count 0)
      (Setq file (getfiled "Select the csv file with the Column details" "" "csv" 16))
      (setq lst (LM:readcsv file))
      (setq a (getpoint "Pick a point outside, the upper left corner where you want to start the table"))
      (setq b (getpoint "Pick the upper right corner"))
      (command "line" a
		   (mapcar '+ a (list (- (nth 0 b) (nth 0 a)) 0 0))
		   ""
		   )
      (setq th (getreal "Please enter the height of the text"))
      (command "line" (mapcar '- a (list 0 (* th 5) 0))
	       (mapcar '- a (list (- (- (nth 0 b) (nth 0 a))) (* th 5) 0))
	       ""
	       )
      (command "mtext"
	     (mapcar '+ a (list th (* th -4) 0))
	     "Height"
	     (* th 2)
	     (mapcar '+ a (list (/ (- (nth 0 b) (nth 0 a)) 28) (* th -1) 0))
	     "SL No"
	     ""
    )
      (command "mtext"
	     (mapcar '+ a (list (+ th (/ (- (nth 0 b) (nth 0 a)) 28)) (* th -4) 0))
	     "Height"
	     (* th 2)
	     (mapcar '+ a (list (* (- (nth 0 b) (nth 0 a)) (/ 3.0 28)) (* th -1) 0))
	     "Bar dia"
	     ""
    )
      (command "mtext"
	     (mapcar '+ a (list (+ th (* (- (nth 0 b) (nth 0 a)) (/ 3.0 28))) (* th -4) 0))
	     "Height"
	     (* th 2)
	     (mapcar '+ a (list (* (- (nth 0 b) (nth 0 a)) (/ 5.0 28)) (* th -1) 0))
	     "Number"
	     ""
    )
      (command "mtext"
	     (mapcar '+ a (list (+ th (* (- (nth 0 b) (nth 0 a)) (/ 5.0 28))) (* th -4) 0))
	     "Height"
	     (* th 2)
	     (mapcar '+ a (list (* (- (nth 0 b) (nth 0 a)) (/ 13.0 28)) (* th -1) 0))
	     "Bar Shape"
	     ""
    )
      (command "mtext"
	     (mapcar '+ a (list (+ th (* (- (nth 0 b) (nth 0 a)) (/ 13.0 28))) (* th -4) 0))
	     "Height"
	     (* th 2)
	     (mapcar '+ a (list (* (- (nth 0 b) (nth 0 a)) (/ 15.0 28)) (* th -1) 0))
	     "Length"
	     ""
    )
      (command "mtext"
	     (mapcar '+ a (list (+ th (* (- (nth 0 b) (nth 0 a)) (/ 15.0 28))) (* th -4) 0))
	     "Height"
	     (* th 2)
	     (mapcar '+ a (list (* (- (nth 0 b) (nth 0 a)) (/ 17.0 28)) (* th -1) 0))
	     "Total Length(m)"
	     ""
    )
      (command "mtext"
	     (mapcar '+ a (list (+ th (* (- (nth 0 b) (nth 0 a)) (/ 17.0 28))) (* th -4) 0))
	     "Height"
	     (* th 2)
	     (mapcar '+ a (list (* (- (nth 0 b) (nth 0 a)) (/ 19.0 28)) (* th -1) 0))
	     "Unit weight"
	     ""
    )
      (command "mtext"
	     (mapcar '+ a (list (+ th (* (- (nth 0 b) (nth 0 a)) (/ 19.0 28))) (* th -4) 0))
	     "Height"
	     (* th 2)
	     (mapcar '+ a (list (* (- (nth 0 b) (nth 0 a)) (/ 20.0 28)) (* th -1) 0))
	     "8mm weight"
	     ""
    )
      (command "mtext"
	     (mapcar '+ a (list (+ th (* (- (nth 0 b) (nth 0 a)) (/ 20.0 28))) (* th -4) 0))
	     "Height"
	     (* th 2)
	     (mapcar '+ a (list (* (- (nth 0 b) (nth 0 a)) (/ 21.0 28)) (* th -1) 0))
	     "10mm weight"
	     ""
    )
      (command "mtext"
	     (mapcar '+ a (list (+ th (* (- (nth 0 b) (nth 0 a)) (/ 21.0 28))) (* th -4) 0))
	     "Height"
	     (* th 2)
	     (mapcar '+ a (list (* (- (nth 0 b) (nth 0 a)) (/ 22.0 28)) (* th -1) 0))
	     "12mm weight"
	     ""
    )
     (command "mtext"
	     (mapcar '+ a (list (+ th (* (- (nth 0 b) (nth 0 a)) (/ 22.0 28))) (* th -4) 0))
	     "Height"
	     (* th 2)
	     (mapcar '+ a (list (* (- (nth 0 b) (nth 0 a)) (/ 23.0 28)) (* th -1) 0))
	     "16mm weight"
	     ""
    )
      (command "mtext"
	     (mapcar '+ a (list (+ th (* (- (nth 0 b) (nth 0 a)) (/ 23.0 28))) (* th -4) 0))
	     "Height"
	     (* th 2)
	     (mapcar '+ a (list (* (- (nth 0 b) (nth 0 a)) (/ 24.0 28)) (* th -1) 0))
	     "20mm weight"
	     ""
    )
      (command "mtext"
	     (mapcar '+ a (list (+ th (* (- (nth 0 b) (nth 0 a)) (/ 24.0 28))) (* th -4) 0))
	     "Height"
	     (* th 2)
	     (mapcar '+ a (list (* (- (nth 0 b) (nth 0 a)) (/ 25.0 28)) (* th -1) 0))
	     "25mm weight"
	     ""
    )
      (command "mtext"
	     (mapcar '+ a (list (+ th (* (- (nth 0 b) (nth 0 a)) (/ 25.0 28))) (* th -4) 0))
	     "Height"
	     (* th 2)
	     (mapcar '+ a (list (* (- (nth 0 b) (nth 0 a)) (/ 26.5 28)) (* th -1) 0))
	     "32mm weight"
	     ""
    )
      (command "mtext"
	     (mapcar '+ a (list (+ th (* (- (nth 0 b) (nth 0 a)) (/ 26.5 28))) (* th -4) 0))
	     "Height"
	     (* th 2)
	     (mapcar '+ a (list (* (- (nth 0 b) (nth 0 a)) (/ 28 28)) (* th -1) 0))
	     "40mm weight"
	     ""
    )
      (setq count 1)
      (while (< count (length lst))
	(command "line"
		 (mapcar '+ a (list 0.0 (* th count 10) 0.0))
		 (mapcar '+ b (list 0.0 (* th count 10) 0.0))
		 ""
		 )
	(setq count (1+ count))
      )
    )
  )
  )
     ;| (while (eq count 0)
	(progn
	  
		   
	|;

;; Read CSV  -  Lee Mac
;; Parses a CSV file into a matrix list of cell values.
;; csv - [str] filename of CSV file to read
 
(defun LM:readcsv ( csv / des lst sep str )
    (if (setq des (open csv "r"))
        (progn
            (setq sep (cond ((vl-registry-read "HKEY_CURRENT_USER\\Control Panel\\International" "sList")) (",")))
            (while (setq str (read-line des))
                (setq lst (cons (LM:csv->lst str sep 0) lst))
            )
            (close des)
        )
    )
    (reverse lst)
)

;; CSV -> List  -  Lee Mac
;; Parses a line from a CSV file into a list of cell values.
;; str - [str] string read from CSV file
;; sep - [str] CSV separator token
;; pos - [int] initial position index (always zero)
 
(defun LM:csv->lst ( str sep pos / s )
    (cond
        (   (not (setq pos (vl-string-search sep str pos)))
            (if (wcmatch str "\"*\"")
                (list (LM:csv-replacequotes (substr str 2 (- (strlen str) 2))))
                (list str)
            )
        )
        (   (or (wcmatch (setq s (substr str 1 pos)) "\"*[~\"]")
                (and (wcmatch s "~*[~\"]*") (= 1 (logand 1 pos)))
            )
            (LM:csv->lst str sep (+ pos 2))
        )
        (   (wcmatch s "\"*\"")
            (cons
                (LM:csv-replacequotes (substr str 2 (- pos 2)))
                (LM:csv->lst (substr str (+ pos 2)) sep 0)
            )
        )
        (   (cons s (LM:csv->lst (substr str (+ pos 2)) sep 0)))
    )
)

(defun LM:csv-replacequotes ( str / pos )
    (setq pos 0)
    (while (setq pos (vl-string-search  "\"\"" str pos))
        (setq str (vl-string-subst "\"" "\"\"" str pos)
              pos (1+ pos)
        )
    )
    str
)