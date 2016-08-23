README.md
=========

Implement the "Backquote" in Common Lisp.

Example:

```lisp
(defmacro xlet (arglst &body body)
  (let ((argname-lst (mapcar #'car arglst))
        (argval-lst (mapcar #'cadr arglst)))
    (backquote ((lambda (comma argname-lst)
                  (comma-at body))
                (comma-at argval-lst)))))

(xlet ((a 10)
       (b 20))
  (+ a b))
```
