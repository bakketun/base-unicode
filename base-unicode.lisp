(assert (< #x10FFFF char-code-limit))


(deftype unicode-scalar-value ()
  '(or
    (integer 0 #xD7FF)
    (integer #xE000 #x10FFFF)))


(defconstant +unicode-radix+ (+ (expt 2 16) (expt 2 20) (* -2 (expt 2 10))))


(defun code-point-weight (code-point)
  (check-type code-point unicode-scalar-value)
  (etypecase code-point
    ((integer 0 #xD7FF)
     code-point)
    ((integer #xE000 #x10FFFF)
     (- code-point 2048))))


(defun unicode-char-weight (char)
  (code-point-weight (char-code char)))


(defun weight-code-point (weight)
  (if (< weight #xD800)
      weight
      (+ weight 2048)))


(defun unicode-digit-char (weight)
  (code-char (weight-code-point weight)))


(defun string-to-integer (string)
  (loop :with n = 0
        :for c :across string
        :do (setf n (+ (* n +unicode-radix+) (unicode-char-weight c)))
        :finally (return n)))


(defun base-unicode-length (integer)
  (if (zerop integer)
      0
      (1+ (floor (log integer +unicode-radix+)))))


(defun integer-to-string (integer)
  (loop :with r = integer
        :with d
        :with l = (base-unicode-length integer)
        :with s = (make-string l)
        :for i :from (1- l) :downto 0
        :do (multiple-value-setq (r d) (floor r +unicode-radix+))
        :do (setf (char s i) (unicode-digit-char d))
        :finally (return s)))


(defun read-base-unicode (stream c1 c2)
  (declare (ignore c1 c2))
  (string-to-integer (read stream t nil t)))


(defun base-unicode-syntax-enabled-p ()
  (eq (get-dispatch-macro-character #\# #\u)
      #'read-base-unicode))


(defun pprint-base-unicode (stream integer)
  (if (base-unicode-syntax-enabled-p)
      (format stream "#u~S" (integer-to-string integer))
      (write integer :pretty nil)))


(defun enable-base-unicode-syntax (&optional pprint)
  (set-dispatch-macro-character #\# #\u #'read-base-unicode)
  (when pprint
    (set-pprint-dispatch 'unsigned-byte #'pprint-base-unicode)))

