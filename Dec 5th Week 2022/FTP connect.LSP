(defun _uploadtoftp (server username password file /)
  (null
    (vl-catch-all-error-p
      (vl-catch-all-apply
	(function (lambda (/ file ftp ofile ofolder oftp parent password sa server sfso username)
		    (setq sa (vlax-get-or-create-object "Shell.Application"))
		    (setq sfso (vlax-get-or-create-object "Scripting.FileSystemObject"))
		    (setq ftp (strcat "ftp://" username ":" password "@" server))
		    (setq oftp (vlax-invoke sa 'namespace ftp))
		    (findfile file)
		    (setq ofile (vlax-invoke sfso 'getfile file))
		    (setq parent (vlax-get ofile 'parentfolder))
		    (setq ofolder (vlax-invoke sa 'namespace (vlax-get parent 'path)))
		    (setq ofile (vlax-invoke ofolder 'parsename (vlax-get ofile 'name)))
		    (vlax-invoke oftp 'copyhere ofile)
		  )
	)
      )
    )
  )
)
;; (_uploadtoftp "ftp.mysite.com" "username" "password" "c:\\test.txt")
;;; FUNCTION
;;; downloads a file specified by a URL
;;; could be used to update a custom program or about
;;; 100 different things
;;;
;;; ARGUMENTS
;;; strURL = valid URL
;;; i.e.  "http://www.myfiles.com/README.txt"
;;;
;;; USAGE
;;; (MST-GetFileFromURL "http://www.theswamp.org/lilly.pond/public/GetFileFromURL.txt")
;;;
;;; PLATFORMS
;;; 2000+
;;;
;;; AUTHOR
;;; Copyright© 2003 Mark S. Thomas
;;; mark.thomas@theswamp.org
;;;
;;; VERSION
;;; 0.9 Mon Sep 22, 2003
;;;
;;; NOTE
;;; if somebody gets this to work for a UNC name I want to see it, please
(defun MST-GetFileFromURL (strURL / vlUtilObj RemoteFile TmpFile strNewFile
                                  strFileBase strFileExt NewFile)

  (setq vlUtilObj
        (vla-get-Utility
          (vla-get-ActiveDocument
            (vlax-get-acad-object)
            )
          )
        )

  (setq RemoteFile
        (vl-catch-all-apply
          'vlax-invoke-method
          (list
            vlUtilObj
            'GetRemoteFile
            strURL
            'TmpFile
            :vlax-false
            )
          )
        )

  (if
    (vl-catch-all-error-p RemoteFile)
    (alert "Remote file not found, contact author of this program")
    ; else
    (progn
      (setq strFileBase (vl-filename-base TmpFile)
            strFileExt (vl-string-left-trim "."(vl-filename-extension TmpFile))
            strNewFile (strcat (vl-filename-base TmpFile)(vl-filename-extension TmpFile))
            )
      ); progn
    ); if

  (if strNewFile
    (setq NewFile
          (getfiled "Save File To:" strNewFile strFileExt 1)
          )
    )

  (if
    (not (vl-file-copy TmpFile NewFile nil))
    (alert "There was a problem saving the file, make sure a duplicate does not exist")
    ; else
    (vl-file-copy TmpFile NewFile nil)
    ); if

  (prompt
    (strcat "\nOriginal downloaded file = "TmpFile)
    )

  (princ)
  )
(vla-putremotefile
  (vla-get-utility (vla-get-activedocument (vlax-get-acad-object)))
  "ftp://g6bau7mbk3r2:Varalakshmi@99@ftp.qwikdraft.com"
  "E:\\purvaja\\WDBM\\LISP\\QWIKDRAFT\\AUTOLISP\\test.txt"
  )