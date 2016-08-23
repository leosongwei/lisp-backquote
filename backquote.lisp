(defun build-body (e ht)
  (if (consp e)
      (case (car e)
        (comma-at
         (let ((key (gensym)))
           (setf (gethash key ht) (cadr e))
           key))
        (comma
         (let ((key (gensym)))
           (setf (gethash key ht) (cadr e))
           (list 'list key)))
        (t
         (list 'list
               (append '(append)
                       (mapcar (lambda (i)
                                 (build-body i ht))
                               e)))))
      ;; atom
      (list 'list (list 'quote e))))

(defmacro backquote (list)
  (let ((ht (make-hash-table))
        (body nil)
        (kvlst nil))
    (setf body (build-body list ht))
    (maphash (lambda (k v)
               (push (list k v) kvlst))
             ht)
    (list 'let
          kvlst
          (list 'car body))))

(defmacro xlet (arglst &body body)
  (let ((argname-lst (mapcar #'car arglst))
        (argval-lst (mapcar #'cadr arglst)))
    (backquote ((lambda (comma argname-lst)
                  (comma-at body))
                (comma-at argval-lst)))))

(xlet ((a 10)
       (b 20))
  (+ a b))
