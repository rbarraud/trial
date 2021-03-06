#|
 This file is a part of trial
 (c) 2017 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.shirakumo.fraf.trial)

(defvar *selection-color-counter* 0)

(defun ensure-selection-color (color)
  (etypecase color
    ((unsigned-byte 32) color)
    (vec4
     (let ((id 0))
       (setf (ldb (byte 8 0) id)  (floor (* 255 (vw color))))
       (setf (ldb (byte 8 8) id)  (floor (* 255 (vz color))))
       (setf (ldb (byte 8 16) id) (floor (* 255 (vy color))))
       (setf (ldb (byte 8 24) id) (floor (* 255 (vx color))))
       id))
    (cons
     (let ((id 0))
       (setf (ldb (byte 8 0) id) (fourth color))
       (setf (ldb (byte 8 8) id) (third color))
       (setf (ldb (byte 8 16) id) (second color))
       (setf (ldb (byte 8 24) id) (first color))
       id))
    ((vector integer 4)
     (let ((id 0))
       (setf (ldb (byte 8 0) id) (aref color 3))
       (setf (ldb (byte 8 8) id) (aref color 2))
       (setf (ldb (byte 8 16) id) (aref color 1))
       (setf (ldb (byte 8 24) id) (aref color 0))
       id))))

(defclass selection-buffer (render-texture)
  ((width :initarg :width :accessor width)
   (height :initarg :height :accessor height)
   (scene :initarg :scene :accessor scene)
   (color->object-map :initform (make-hash-table :test 'eql) :accessor color->object-map))
  (:default-initargs
   :width (error "WIDTH required.")
   :height (error "HEIGHT required.")
   :scene (error "SCENE required.")))

(defmethod initialize-instance :after ((buffer selection-buffer) &key scene)
  (register (make-instance 'selection-buffer-pass) buffer)
  (pack buffer)
  (add-handler buffer scene))

(defmethod object-at-point ((point vec2) (buffer selection-buffer))
  (color->object (gl:read-pixels (round (vx point)) (round (vy point)) 1 1 :rgba :unsigned-byte)
                 buffer))

(defmethod color->object (color (buffer selection-buffer))
  (gethash (ensure-selection-color color)
           (color->object-map buffer)))

(defmethod (setf color->object) (object color (buffer selection-buffer))
  (if object
      (setf (gethash (ensure-selection-color color)
                     (color->object-map buffer))
            object)
      (remhash (ensure-selection-color color)
               (color->object-map buffer))))

(defmethod handle (thing (buffer selection-buffer)))

(defmethod handle ((enter enter) (buffer selection-buffer))
  (let ((entity (entity enter)))
    (when (typep entity 'selectable)
      (setf (color->object (selection-color entity) buffer) entity))))

(defmethod handle ((leave leave) (buffer selection-buffer))
  (let ((entity (entity leave)))
    (when (typep entity 'selectable)
      (setf (color->object (selection-color entity) buffer) NIL))))

(defmethod paint ((thing (eql T)) (buffer selection-buffer))
  (paint (scene buffer) buffer))

(defmethod paint :around (thing (buffer selection-buffer))
  (with-pushed-attribs
    (disable :blend)
    (call-next-method)))

(define-shader-subject selection-buffer-pass (render-pass)
  ())

(define-class-shader (selection-buffer-pass :fragment-shader)
  "uniform vec4 selection_color;
out vec4 color;

void main(){
  color = selection_color;
}")

(define-shader-subject selectable ()
  ((selection-color :initarg :selection-color :accessor selection-color))
  (:default-initargs :selection-color (find-new-selection-color)))

(defun find-new-selection-color ()
  (let ((num (incf *selection-color-counter*)))
    (vec4 (ldb (byte 8 24) num)
          (ldb (byte 8 16) num)
          (ldb (byte 8 8) num)
          (ldb (byte 8 0) num))))

(defmethod paint :around ((subject shader-subject) (pass selection-buffer-pass)))

(defmethod paint :before ((subject selectable) (pass selection-buffer-pass))
  (let ((shader (shader-program-for-pass pass subject)))
    (setf (uniform shader "selection_color") (selection-color subject))))
