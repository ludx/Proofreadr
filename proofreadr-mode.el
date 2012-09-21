;; proofreadr.el -- proofreading helper for Mandarin Chinese
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

;;; Todo:

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

(defcustom proofreadr-verbose-words t
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

;; Verbose words face

(defcustom proofreadr-verbose-words-foreground-color "Gray"
  "Verbose words face foreground colour"
  :group 'proofreadr-mode)

(defcustom proofreadr-verbose-words-background-color "White"
  "Verbose words face background color"
  :group 'proofreadr-mode)

(defcustom proofreadr-font-lock-verbose-words-face 'font-lock-verbose-words-face
  "The face for verbose words in proofreadr mode"
  :group 'proofreadr-mode)

(make-face 'proofreadr-font-lock-verbose-words-face)
(modify-face 'proofreadr-font-lock-verbose-words-face
             proofreadr-verbose-words-foreground-color
             proofreadr-verbose-words-background-color nil t nil t nil nil)

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
;; Verbose Words
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconst proofreadr-verbose-words-regex "\\(\\cc+\\)\\1+")

;; 只处理两个重复中文字符 \\(\\cc\\{1,2\\}\\)\\1+
;; 但CPU占用率没有区别

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Weasel words
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 「100个最常见的错别字」 http://www.yuwen123.com/Article/200512/17313.html

(defconst proofreadr-weasel-words-regex "\\(帐号\\|部份\\|其它\\|图型\\|分枝\\|登陆\\|步道\\|当作\\|c\\+\\+\\|:\\|,\\|繁琐\\|按装\\|甘败下风\\|自抱自弃\\|针贬\\|泊来品\\|脉博\\|松驰\\|一愁莫展\\|穿流不息\\|精萃\\|重迭\\|渡假\\|防碍\\|幅射\\|天翻地复\\|言简意骇\\|气慨\\|一股作气\\|悬梁刺骨\\|粗旷\\|食不裹腹\\|震憾\\|凑和\\|侯车\\|迫不急待\\|既使\\|一如继往\\|草管人命\\|娇揉造作\\|挖墙角\\|一诺千斤\\|不径而走\\|峻工\\|不落巢臼\\|烩炙人口\\|打腊\\|死皮癞脸\\|兰天\\|鼎立相助\\|再接再励\\|老俩口\\|黄梁\\|了望\\|水笼头\\|杀戳\\|痉孪\\|美仑美奂\\|罗嗦\\|蛛丝蚂迹\\|萎糜不振\\|沉缅\\|默守\\|姆指\\|沤心沥血\\|凭添\\|出奇不意\\|修茸\\|亲睐\\|磬竹难书\\|入场卷\\|声名雀起\\|发韧\\|欣尝\\|谈笑风声\\|人情事故\\|有持无恐\\|追朔\\|上朔\\|鬼鬼崇崇\\|金榜提名\\|走头无路\\|趋之若骛\\|迁徒\\|洁白无暇\\|九宵\\|渲泄\\|寒喧\\|弦律\\|膺品\\|不能自己\\|尤如\\|竭泽而鱼\\|滥芋充数\\|世外桃园\\|脏款\\|醮水\\|蜇伏\\|装祯\\|饮鸠\\|\\坐阵|旁证博引\\|灸手可热\\|九洲\\|床第\\|姿意\\|编篡\\|做月子\\|英特网\\|一但\\|做为\\|抽像\\|通通\\|粘合\\|踹踹不安\\|帐户\\)")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Proofreadr
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 中英文间的空格对Markdown做了优化

(defconst proofreadr-jargon-regex "\\(\\cc \\ca\\|\\ca[^#\.] \\cc\\|,\\|时候\\|等等\\|美金\\|下图\\|上图\\|左图\\|右图\\|但是\\|->\\|通讯\\|\"\\|\(\\|\)\\|比如\\|上表\\|下表\\|左表\\|右表\\|里面\\|已经\\|所以\\|去年\\|前年\\|今年\\|明年\\|甲骨文\\|IO\\|->\\|[0-9]+\\(~\\|～\\)[0-9]+\\(年\\|月\\|日\\)\\)")

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

(defun proofreadr-verbose-words-search-for-keyword (limit)
  (proofreadr-search-for-keyword proofreadr-verbose-words-regex limit))

(defun proofreadr-weasel-words-search-for-keyword (limit)
  (proofreadr-search-for-keyword proofreadr-weasel-words-regex limit))

(defun proofreadr-search-for-jargon (limit)
  (proofreadr-search-for-keyword proofreadr-jargon-regex limit))

(defconst proofreadr-lexicalkwlist
  '((proofreadr-lexical-illusions-search-for-keyword 
     (2 'proofreadr-font-lock-lexical-illusions-face t))))

(defconst proofreadr-verbosekwlist
  '((proofreadr-verbose-words-search-for-keyword 
     (0 'proofreadr-font-lock-verbose-words-face t))))

(defconst proofreadr-weaselkwlist
  '((proofreadr-weasel-words-search-for-keyword 
     (0 'proofreadr-font-lock-weasel-words-face t))))

(defconst proofreadr-kwlist
  '((proofreadr-search-for-jargon 
     (0 'proofreadr-font-lock-proofreadr-face t))))

(defun proofreadr-add-keywords ()
  (when proofreadr-lexical-illusions
    (font-lock-add-keywords nil proofreadr-lexicalkwlist))
  (when proofreadr-verbose-words
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
(define-minor-mode proofreadr-mode "Highlight verbose words, weasel words and proofreadr jargon in text, and provide useful text metrics"
  :lighter " AB"
  :keymap proofreadr-mode-keymap
  :group 'proofreadr-mode
  (if proofreadr-mode
      (proofreadr-add-keywords)
    (proofreadr-remove-keywords)))

(provide 'proofreadr-mode)
