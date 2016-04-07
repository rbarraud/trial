#|
This file is a part of trial
(c) 2016 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.shirakumo.fraf.trial)
(in-readtable :qtools)

(defparameter *key-table*
  (alexandria:alist-hash-table
   '((#x01000000 . :escape)
     (#x01000001 . :tab)
     (#x01000002 . :backtab)
     (#x01000003 . :backspace)
     (#x01000004 . :return)
     (#x01000005 . :enter)
     (#x01000006 . :insert)
     (#x01000007 . :delete)
     (#x01000008 . :pause)
     (#x01000009 . :print)
     (#x0100000a . :sysreq)
     (#x0100000b . :clear)
     (#x01000010 . :home)
     (#x01000011 . :end)
     (#x01000012 . :left)
     (#x01000013 . :up)
     (#x01000014 . :right)
     (#x01000015 . :down)
     (#x01000016 . :page-up)
     (#x01000017 . :page-down)
     (#x01000020 . :shift)
     (#x01000021 . :control)
     (#x01000022 . :meta)
     (#x01000023 . :alt)
     (#x01001103 . :altgr)
     (#x01000024 . :caps-lock)
     (#x01000025 . :num-lock)
     (#x01000026 . :scroll-lock)
     (#x01000030 . :f1)
     (#x01000031 . :f2)
     (#x01000032 . :f3)
     (#x01000033 . :f4)
     (#x01000034 . :f5)
     (#x01000035 . :f6)
     (#x01000036 . :f7)
     (#x01000037 . :f8)
     (#x01000038 . :f9)
     (#x01000039 . :f10)
     (#x0100003a . :f11)
     (#x0100003b . :f12)
     (#x0100003c . :f13)
     (#x0100003d . :f14)
     (#x0100003e . :f15)
     (#x0100003f . :f16)
     (#x01000040 . :f17)
     (#x01000041 . :f18)
     (#x01000042 . :f19)
     (#x01000043 . :f20)
     (#x01000044 . :f21)
     (#x01000045 . :f22)
     (#x01000046 . :f23)
     (#x01000047 . :f24)
     (#x01000048 . :f25)
     (#x01000049 . :f26)
     (#x0100004a . :f27)
     (#x0100004b . :f28)
     (#x0100004c . :f29)
     (#x0100004d . :f30)
     (#x0100004e . :f31)
     (#x0100004f . :f32)
     (#x01000050 . :f33)
     (#x01000051 . :f34)
     (#x01000052 . :f35)
     (#x01000053 . :super-l)
     (#x01000054 . :super-r)
     (#x01000055 . :menu)
     (#x01000056 . :hyper-l)
     (#x01000057 . :hyper-r)
     (#x01000058 . :help)
     (#x01000059 . :direction-l)
     (#x01000060 . :direction-r)
     (#x00000020 . :space)
     (#x00000021 . :exclam)
     (#x00000022 . :quotedbl)
     (#x00000023 . :numbersign)
     (#x00000024 . :dollar)
     (#x00000025 . :percent)
     (#x00000026 . :ampersand)
     (#x00000027 . :apostrophe)
     (#x00000028 . :paren-left)
     (#x00000029 . :paren-right)
     (#x0000002a . :asterisk)
     (#x0000002b . :plus)
     (#x0000002c . :comma)
     (#x0000002d . :minus)
     (#x0000002e . :period)
     (#x0000002f . :slash)
     (#x00000030 . :0)
     (#x00000031 . :1)
     (#x00000032 . :2)
     (#x00000033 . :3)
     (#x00000034 . :4)
     (#x00000035 . :5)
     (#x00000036 . :6)
     (#x00000037 . :7)
     (#x00000038 . :8)
     (#x00000039 . :9)
     (#x0000003a . :colon)
     (#x0000003b . :semicolon)
     (#x0000003c . :less)
     (#x0000003d . :equal)
     (#x0000003e . :greater)
     (#x0000003f . :question)
     (#x00000040 . :at)
     (#x00000041 . :a)
     (#x00000042 . :b)
     (#x00000043 . :c)
     (#x00000044 . :d)
     (#x00000045 . :e)
     (#x00000046 . :f)
     (#x00000047 . :g)
     (#x00000048 . :h)
     (#x00000049 . :i)
     (#x0000004a . :j)
     (#x0000004b . :k)
     (#x0000004c . :l)
     (#x0000004d . :m)
     (#x0000004e . :n)
     (#x0000004f . :o)
     (#x00000050 . :p)
     (#x00000051 . :q)
     (#x00000052 . :r)
     (#x00000053 . :s)
     (#x00000054 . :t)
     (#x00000055 . :u)
     (#x00000056 . :v)
     (#x00000057 . :w)
     (#x00000058 . :x)
     (#x00000059 . :y)
     (#x0000005a . :z))
   :test 'eql))

(defparameter *mouse-button-table*
  (alexandria:alist-hash-table
   '((#x00000001 . :left)
     (#x00000002 . :right)
     (#x00000004 . :middle)
     (#x00000008 . :x1)
     (#x00000010 . :x2))
   :test 'eql))

(defparameter *gamepad-device-table*
  (alexandria:alist-hash-table
   '(((1118 . 654) . :xbox360)
     ((1133 . 49693) . :logitech-f310)
     ((1356 . 616) . :dualshock3)
     ((10462 . 4604) . :steamcontroller))
   :test 'equal))

;;; General name mapping conventions:
;; :left-h      -- Left analog stick, horizontal movement
;; :left-v      -- Left analog stick, vertical movement
;; :right-h     -- Right analog stick, horizontal movement
;; :right-v     -- Right analog stick, vertical movement
;; :dpad-up     -- Directional pad up
;; :dpad-right  -- Directional pad right
;; :dpad-down   -- Directional pad down
;; :dpad-left   -- Directional pad left
;; :l1          -- Left upper trigger or bumper
;; :l2          -- Left lower trigger or bumper
;; :r1          -- Right upper trigger or bumper
;; :r2          -- Right lower trigger or bumper
;; :y           -- Upper button (Y on Xbox pads)
;; :b           -- Right button (B on Xbox pads)
;; :a           -- Lower button (A on Xbox pads)
;; :x           -- Left button  (X on Xbox pads)
;; :left        -- Left analog stick click
;; :right       -- Right analog stick click
;; :select      -- Left menu button
;; :home        -- Middle menu button
;; :start       -- Right menu button
;;
;; Gamepads with special hardware may have additional axes
;; and buttons and thus additional names. If you wish to
;; use those, see the respective mapping table for the
;; device.

(defparameter *gamepad-axis-table*
  (alexandria:alist-hash-table
   `((:dualshock3
      ,(alexandria:alist-hash-table
        '(( 0 . :left-h)
          ( 1 . :left-v)
          ( 2 . :right-h)
          ( 3 . :right-v)
          ( 8 . :dpad-up)
          ( 9 . :dpad-right)
          (10 . :dpad-down)
          (11 . :dpad-left)
          (12 . :l2)
          (13 . :r2)
          (14 . :l1)
          (15 . :r1)
          (16 . :y) ; triangle
          (17 . :b) ; circle
          (18 . :a) ; cross
          (19 . :x) ; square
          (23 . :axis-x)
          (24 . :axis-z)
          (25 . :axis-y)
          (26 . :axis-r))
        :test 'eql))
     (:xbox360
      ,(alexandria:alist-hash-table
        '(( 0 . :left-h)
          ( 1 . :left-v)
          ( 2 . :l2)
          ( 3 . :right-h)
          ( 4 . :right-v)
          ( 5 . :r2)
          ( 6 . :dpad-h)
          ( 7 . :dpad-v)))))
   :test 'eql))

(defparameter *gamepad-button-table*
  (alexandria:alist-hash-table
   `((:dualshock3
      ,(alexandria:alist-hash-table
        '(( 0 . :select)
          ( 1 . :left)
          ( 2 . :right)
          ( 3 . :start)
          ( 4 . :dpad-up)
          ( 5 . :dpad-right)
          ( 6 . :dpad-down)
          ( 7 . :dpad-left)
          ( 8 . :l2)
          ( 9 . :r2)
          (10 . :l1)
          (11 . :r1)
          (12 . :y) ; triangle
          (13 . :b) ; circle
          (14 . :a) ; cross
          (15 . :x) ; square
          (16 . :home))
        :test 'eql))
     (:xbox360
      ,(alexandria:alist-hash-table
        '(( 0 . :a)
          ( 1 . :b)
          ( 2 . :x)
          ( 3 . :y)
          ( 4 . :l1)
          ( 5 . :r1)
          ( 6 . :select)
          ( 7 . :start)
          ( 8 . :home)
          ( 9 . :left)
          (10 . :right)))))
   :test 'eql))

(defun qt-key->symbol (enum)
  (let ((key (etypecase enum
               (integer enum)
               (qt::enum (qt:enum-value enum)))))
    (or (gethash key *key-table*)
        key)))

(defun qt-button->symbol (enum)
  (let ((button (etypecase enum
                  (integer enum)
                  (qt::enum (qt:enum-value enum)))))
    (or (gethash button *mouse-button-table*)
        button)))

(defun gamepad-axis->symbol (device axis)
  (let ((device (or (gethash (cons (cl-gamepad:vendor device)
                                   (cl-gamepad:product device))
                             *gamepad-device-table*)
                    :xbox360)))
    (or (when device (gethash axis (gethash device *gamepad-button-table*)))
        axis)))

(defun gamepad-button->symbol (device button)
  (let ((device (or (gethash (cons (cl-gamepad:vendor device)
                                   (cl-gamepad:product device))
                             *gamepad-device-table*)
                    :xbox360)))
    (or (when device (gethash button (gethash device *gamepad-button-table*)))
        button)))
