#|
 This file is a part of trial
 (c) 2016 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.shirakumo.fraf.trial)

(defclass display (renderable)
  ((context :initarg :context :accessor context)
   (clear-color :initarg :clear-color :accessor clear-color))
  (:default-initargs
   :clear-color (vec 0.2 0.3 0.3)))

(defmethod initialize-instance :after ((display display) &rest initargs &key context title width height version profile double-buffering stereo-buffer vsync)
  (declare (ignore title width height version profile double-buffering stereo-buffer vsync))
  (unless context
    (let ((args (loop for (k v) on initargs by #'cddr
                      for keep = (find k '(:title :width :height :version :profile :double-buffering :stereo-buffer :vsync))
                      when keep collect k when keep collect v)))
      (setf context (setf (context display) (apply #'make-context NIL args)))))
  (setf (handler context) display)
  (add-gamepad-handler display)
  (with-context ((context display))
    (setup-rendering display)))

(defmethod finalize :after ((display display))
  (remove-gamepad-handler display)
  (finalize (context display)))

(defmethod handle (event (display display)))

(defmethod setup-rendering ((display display))
  (reset-matrix (model-matrix))
  (reset-matrix (view-matrix))
  (reset-matrix (projection-matrix))
  (reset-attributes (attribute-table))
  (gl:depth-mask T)
  (gl:depth-func :lequal)
  (gl:blend-func :src-alpha :one-minus-src-alpha)
  (gl:clear-depth 1.0)
  (gl:front-face :ccw)
  (gl:cull-face :back)
  (gl:hint :line-smooth-hint :nicest)
  (enable :blend :multisample :line-smooth :depth-test :depth-clamp))

(defmethod paint (source (target display)))

(defmethod render (source (target display))
  (paint source target))

(defmethod render :around (source (target display))
  ;; Potentially release context every time to allow
  ;; other threads to grab it.
  (let ((context (context target)))
    (with-context (context :reentrant T)
      (let ((c (clear-color target)))
        (gl:clear-color (vx c) (vy c) (vz c) (if (vec4-p c) (vw c) 0.0)))
      (gl:clear :color-buffer :depth-buffer)
      (call-next-method)
      (swap-buffers context))))

(defmethod width ((display display))
  (width (context display)))

(defmethod height ((display display))
  (height (context display)))
