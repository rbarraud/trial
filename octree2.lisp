#|
 This file is a part of trial
 (c) 2016 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.shirakumo.fraf.trial)
(in-readtable :qtools)

(define-subject octree2 (located-subject)
  ((root :initform NIL :accessor root)
   (size :initarg :size :accessor size)
   (max-depth :initarg :max-depth :accessor max-depth)
   (threshold :initarg :threshold :accessor threshold))
  (:default-initargs
   ;; XYZ range from center
   :size 500.0f0
   :max-depth 8
   :threshold 8))

(deftype octree-node ()
  `(vector * 8))

(deftype octree-leaf ()
  `list)

(defun vec-in-cube-p (vec center size)
  (declare (optimize speed)
           (type vec vec center)
           (type single-float size))
  (with-vec (x y z) vec
    (with-vec (cx cy cz) center
      (and (<= (- cx size) x (+ cx size))
           (<= (- cy size) y (+ cy size))
           (<= (- cz size) z (+ cz size))))))

(defmacro %with-matching-octree-node ((node nodes) &body body)
  `(cond ,@(loop for i from 0
                 for x in '(- - - - + + + +)
                 for y in '(- - + + - - + +)
                 for z in '(- + - + - + - +)
                 collect `((vec-in-cube-p
                            vec (vsetf tcenter
                                       (,x (the single-float (vx center)) size)
                                       (,y (the single-float (vy center)) size)
                                       (,z (the single-float (vz center)) size))
                            size)
                           (symbol-macrolet ((,node (aref ,nodes ,i)))
                             ,@body)))
         (T (error "WTF: ~a does not fit at all." vec))))

(defmethod test ((subject located-entity) (vec vec))
  (v= (location subject) vec))

(defmethod test ((octree octree2) (vec vec))
  (let ((center (location octree))
        (size (size octree)))
    (declare (optimize speed)
             (type single-float size)
             (type vec vec center))
    (when (vec-in-cube-p vec center size)
      (loop with tcenter = (vec 0 0 0)
            with node = (root octree)
            do (etypecase node
                 (octree-node
                  (setf size (/ size 2))
                  (%with-matching-octree-node (sub node)
                    (setf center tcenter)
                    (setf node sub)))
                 (octree-leaf
                  (return (remove-if-not (lambda (el) (test el vec)) node))))))))

(defmethod enter ((el located-entity) (octree octree2))
  (let ((center (location octree))
        (vec (location el))
        (tcenter (vec 0 0 0))
        (size (size octree))
        (threshold (threshold octree))
        (level 0))
    (declare (optimize speed)
             (type single-float size)
             (type fixnum threshold level)
             (type vec vec center))
    (flet ((insert-or-split (target)
             (declare (type list target))
             (cond ((or (< (length target) threshold)
                        (<= (the fixnum (max-depth octree)) level))
                    (cons el target))
                   ;; Subdivide
                   (T (let ((nodes (make-array 8 :initial-element NIL)))
                        (%with-matching-octree-node (sub nodes)
                          (push el sub))
                        ;; Push old ones
                        (dolist (el target nodes)
                          (setf vec (location el))
                          (%with-matching-octree-node (sub nodes)
                            (push el sub))))))))
      (when (vec-in-cube-p vec center size)
        (etypecase (root octree)
          (octree-node
           (loop with node = (root octree)
                 do (setf size (/ size 2))
                    (%with-matching-octree-node (sub node)
                      (let ((subval sub))
                        (etypecase subval
                          (octree-node
                           (rotatef center tcenter)
                           (setf node subval))
                          (octree-leaf
                           (setf sub (insert-or-split subval))
                           (return)))))))
          (octree-leaf
           (setf size (/ size 2))
           (setf (root octree) (insert-or-split (root octree)))))))))

(defmethod leave ((el located-entity) (octree octree2))
  (let ((center (location octree))
        (size (size octree))
        (vec (location el)))
    (declare (optimize speed)
             (type single-float size)
             (type vec vec center))
    (when (vec-in-cube-p vec center size)
      (etypecase (root octree)
        (octree-node
         (loop with tcenter = (vec 0 0 0)
               with node = (root octree)
               do (setf size (/ size 2))
                  (%with-matching-octree-node (sub node)
                    (let ((subval sub))
                      (etypecase subval
                        (octree-node
                         (setf center tcenter)
                         (setf node subval))
                        (octree-leaf
                         (setf sub (delete el subval))
                         ;; FIXME: Clean hook if none left or something
                         (return)))))))
        (octree-leaf
         (setf (root octree) (delete el (the list (root octree)))))))))

(define-handler (octree2 enter) (ev entity)
  (when (typep entity 'collidable-entity)
    (enter entity octree2)))

(define-handler (octree2 leave) (ev entity)
  (when (typep entity 'collidable-entity)
    (leave entity octree2)))