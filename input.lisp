#|
 This file is a part of trial
 (c) 2016 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.shirakumo.fraf.trial)

(defclass input-event (event)
  ())

(defclass keyboard-event (input-event)
  ((key :initarg :key :reader key)
   (text :initarg :text :reader text)
   (modifiers :initarg :modifiers :reader modifiers))
  (:default-initargs
   :key (error "KEY required.")
   :text (error "TEXT required.")
   :modifiers ()))

(defmethod print-object ((event keyboard-event) stream)
  (print-unreadable-object (event stream :type T)
    (format stream "~a" (key event))))

(defclass key-press (keyboard-event)
  ())

(defclass key-release (keyboard-event)
  ())

(defclass mouse-event (input-event)
  ((pos :initarg :pos :reader pos))
  (:default-initargs
   :pos (error "POS required.")))

(defclass mouse-button-event (mouse-event)
  ((button :initarg :button :reader button))
  (:default-initargs
   :button (error "BUTTON required.")))

(defmethod print-object ((event mouse-button-event) stream)
  (print-unreadable-object (event stream :type T)
    (format stream "~a" (button event))))

(defclass mouse-press (mouse-button-event)
  ())

(defclass mouse-release (mouse-button-event)
  ())

(defclass mouse-scroll (mouse-event)
  ((delta :initarg :delta :reader delta))
  (:default-initargs
   :delta (error "DELTA required.")))

(defmethod print-object ((event mouse-scroll) stream)
  (print-unreadable-object (event stream :type T)
    (format stream "~a" (delta event))))

(defclass mouse-move (mouse-event)
  ((old-pos :initarg :old-pos :reader old-pos))
  (:default-initargs
   :old-pos (error "OLD-POS required.")))

(defmethod print-object ((event mouse-move) stream)
  (print-unreadable-object (event stream :type T)
    (format stream "~a => ~a" (old-pos event) (pos event))))

(defclass gamepad-event (input-event)
  ((device :initarg :device :reader device))
  (:default-initargs
   :device (error "DEVICE required.")))

(defclass gamepad-attach (gamepad-event)
  ())

(defclass gamepad-remove (gamepad-event)
  ())

(defclass gamepad-press (gamepad-event)
  ((button :initarg :button :reader button))
  (:default-initargs
   :button (error "BUTTON required.")))

(defclass gamepad-release (gamepad-event)
  ((button :initarg :button :reader button))
  (:default-initargs
   :button (error "BUTTON required.")))

(defclass gamepad-move (gamepad-event)
  ((axis :initarg :axis :reader axis)
   (old-pos :initarg :old-pos :reader old-pos)
   (pos :initarg :pos :reader pos))
  (:default-initargs
   :axis (error "AXIS required.")
   :old-pos (error "OLD-POS required.")
   :pos (error "POS required.")))

(define-uniform-retention key (key-press key-release key)
  key)

(define-uniform-retention mouse (mouse-press mouse-release button)
  button)

(define-uniform-retention gamepad (gamepad-press gamepad-release button)
  button)
