;;; proofreadr.el --- A Proofreader for Chinese tech articles
;;
;; Copyright (C) 2012 lispython <lispython@gmail.com>
;;
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Extra thanks to:
;; The author of artbollocks-mode and writegood-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Commentary:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Usage
;;
;; (require 'proofreadr-mode)
;; (add-hook 'text-mode-hook 'proofreadr-mode)
;; (add-hook 'org-mode-hook 'proofreadr-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Customization
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Enable features individually

(defcustom proofreadr-lexical-illusions t
  "Whether to check for lexical illusions"
  :type '(boolean)
  :group 'proofreadr-mode)

(defcustom proofreadr-verbose-word t
  "Whether to check for verbose Chinese words"
  :type '(boolean)
  :group 'proofreadr-mode)

(defcustom proofreadr-weasel-words t
  "Whether to check for weasel words"
  :type '(boolean)
  :group 'proofreadr-mode)

(defcustom proofreadr-jargon t
  "Whether to check for proofreadr jargon"
  :type '(boolean)
  :group 'proofreadr-mode)

;; Lexical illusion face

(defcustom proofreadr-lexical-illusions-foreground-color "black"
  "Lexical illusions face foreground colour"
  :group 'proofreadr-mode)

(defcustom proofreadr-lexical-illusions-background-color "magenta"
  "Lexical illusions face background color"
  :group 'proofreadr-mode)

(defcustom proofreadr-font-lock-lexical-illusions-face 'font-lock-lexical-illusions-face
  "The face for lexical illusions in proofreadr mode"
  :group 'proofreadr-mode)

(make-face 'proofreadr-font-lock-lexical-illusions-face)
(modify-face 'proofreadr-font-lock-lexical-illusions-face
	     proofreadr-lexical-illusions-foreground-color
             proofreadr-lexical-illusions-background-color
	     nil t nil t nil nil)

;; Verbose word face

(defcustom proofreadr-verbose-word-foreground-color "Gray"
  "Verbose word face foreground colour"
  :group 'proofreadr-mode)

(defcustom proofreadr-verbose-word-background-color "White"
  "Verbose word face background color"
  :group 'proofreadr-mode)

(defcustom proofreadr-font-lock-verbose-word-face 'font-lock-verbose-word-face
  "The face for verbose word words in proofreadr mode"
  :group 'proofreadr-mode)

(make-face 'proofreadr-font-lock-verbose-word-face)
(modify-face 'proofreadr-font-lock-verbose-word-face
             proofreadr-verbose-word-foreground-color
             proofreadr-verbose-word-background-color nil t nil t nil nil)

;; Weasel words face

(defcustom proofreadr-weasel-words-foreground-color "Brown"
  "Weasel words face foreground colour"
  :group 'proofreadr-mode)

(defcustom proofreadr-weasel-words-background-color "White"
  "Weasel words face background color"
  :group 'proofreadr-mode)

(defcustom proofreadr-font-lock-weasel-words-face 'proofreadr-font-lock-weasel-words-face
  "The face for weasel-words words in proofreadr mode"
  :group 'proofreadr-mode)

(make-face 'proofreadr-font-lock-weasel-words-face)
(modify-face 'proofreadr-font-lock-weasel-words-face
             proofreadr-weasel-words-foreground-color
             proofreadr-weasel-words-background-color nil t nil t nil nil)

;; Proofreadr face

(defcustom proofreadr-foreground-color "Purple"
  "Font foreground colour"
  :group 'proofreadr-mode)

(defcustom proofreadr-background-color "White"
  "Font background color"
  :group 'proofreadr-mode)

(defcustom proofreadr-font-lock-proofreadr-face 'font-lock-proofreadr-face
  "The face for proofreadr words in proofreadr mode"
  :group 'proofreadr-mode)

(make-face 'proofreadr-font-lock-proofreadr-face)
(modify-face 'proofreadr-font-lock-proofreadr-face proofreadr-foreground-color
             proofreadr-background-color nil t nil t nil nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Lexical illusions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconst proofreadr-lexical-illusions-regex "\\b\\(\\w+\\)\\W+\\(\\1\\)\\b")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Verbose Word
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconst proofreadr-verbose-word-regex "\\(\\cc+\\)\\1+")

;; 只处理两个重复中文字符 \\(\\cc\\{1,2\\}\\)\\1+
;; 但CPU占用率没有区别

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Weasel words
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconst proofreadr-weasel-words-regex "\\(帐号\\|部份\\|其它\\|图型\\|分枝\\|登陆\\|步道\\|当作\\|c\\+\\+\\|:\\|,\\|繁琐\\|largely\\|huge\\|tiny\\|\\(\\(are\\|is\\) a number\\)\\|excellent\\|interestingly\\|significantly\\|substantially\\|clearly\\|vast\\|relatively\\|completely\\)")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Proofreadr
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconst proofreadr-jargon-regex "\\(\\cc [a-z]\\|[a-z] \\cc\\|,\\|有的时候\\|等等\\|美金\\|下图\\|上图\\|左图\\|右图\\|但是\\|->\\|通讯\\|\"\\|\(\\|\)\\|比如\\|上表\\|下表\\|左表\\|右表\\|里面\\|已经\\|所以\\|去年\\|前年\\|今年\\|明年\\)")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Highlighting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun proofreadr-search-for-keyword (regex limit)
  "Match REGEX in buffer until LIMIT."
  (let (match-data-to-set
	found)
    (save-match-data
      (while (and (null match-data-to-set)
		  (re-search-forward regex limit t))
	    (setq match-data-to-set (match-data))))
    (when match-data-to-set
      (set-match-data match-data-to-set)
      (goto-char (match-end 0)) 
      t)))

(defun proofreadr-lexical-illusions-search-for-keyword (limit)
  (proofreadr-search-for-keyword proofreadr-lexical-illusions-regex limit))

(defun proofreadr-verbose-word-search-for-keyword (limit)
  (proofreadr-search-for-keyword proofreadr-verbose-word-regex limit))

(defun proofreadr-weasel-words-search-for-keyword (limit)
  (proofreadr-search-for-keyword proofreadr-weasel-words-regex limit))

(defun proofreadr-search-for-jargon (limit)
  (proofreadr-search-for-keyword proofreadr-jargon-regex limit))

(defconst proofreadr-lexicalkwlist
  '((proofreadr-lexical-illusions-search-for-keyword 
     (2 'proofreadr-font-lock-lexical-illusions-face t))))

(defconst proofreadr-verbosekwlist
  '((proofreadr-verbose-word-search-for-keyword 
     (0 'proofreadr-font-lock-verbose-word-face t))))

(defconst proofreadr-weaselkwlist
  '((proofreadr-weasel-words-search-for-keyword 
     (0 'proofreadr-font-lock-weasel-words-face t))))

(defconst proofreadr-kwlist
  '((proofreadr-search-for-jargon 
     (0 'proofreadr-font-lock-proofreadr-face t))))

(defun proofreadr-add-keywords ()
  (when proofreadr-lexical-illusions
    (font-lock-add-keywords nil proofreadr-lexicalkwlist))
  (when proofreadr-verbose-word
    (font-lock-add-keywords nil proofreadr-verbosekwlist))
  (when proofreadr-weasel-words
    (font-lock-add-keywords nil proofreadr-weaselkwlist))
  (when proofreadr-jargon
    (font-lock-add-keywords nil proofreadr-kwlist)))

(defun proofreadr-remove-keywords ()
  (font-lock-remove-keywords nil proofreadr-lexicalkwlist)
  (font-lock-remove-keywords nil proofreadr-verbosekwlist)
  (font-lock-remove-keywords nil proofreadr-weaselkwlist)
  (font-lock-remove-keywords nil proofreadr-kwlist))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconst proofreadr-mode-keymap (make-keymap))


;;;###autoload
(define-minor-mode proofreadr-mode "Highlight verbose word, weasel words and proofreadr jargon in text, and provide useful text metrics"
  :lighter " AB"
  :keymap proofreadr-mode-keymap
  :group 'proofreadr-mode
  (if proofreadr-mode
      (proofreadr-add-keywords)
    (proofreadr-remove-keywords)))

(provide 'proofreadr-mode)
