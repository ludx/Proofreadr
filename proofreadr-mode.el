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
;; (add-hook 'text-mode-hook 'turn-on-proofreadr-mode)
;; (add-hook 'org-mode-hook 'turn-on-proofreadr-mode)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Customization
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Enable features individually

(defcustom proofreadr-lexical-illusions t
  "Whether to check for lexical illusions"
  :type '(boolean)
  :group 'proofreadr-mode)

(defcustom proofreadr-passive-voice t
  "Whether to check for passive voice"
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

;; Passive voice face

(defcustom proofreadr-passive-voice-foreground-color "Gray"
  "Passive voice face foreground colour"
  :group 'proofreadr-mode)

(defcustom proofreadr-passive-voice-background-color "White"
  "Passive voice face background color"
  :group 'proofreadr-mode)

(defcustom proofreadr-font-lock-passive-voice-face 'font-lock-passive-voice-face
  "The face for passive voice words in proofreadr mode"
  :group 'proofreadr-mode)

(make-face 'proofreadr-font-lock-passive-voice-face)
(modify-face 'proofreadr-font-lock-passive-voice-face
             proofreadr-passive-voice-foreground-color
             proofreadr-passive-voice-background-color nil t nil t nil nil)

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
;; Passive voice
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconst proofreadr-passive-voice-regex "\\b\\(am\\|are\\|were\\|being\\|is\\|been\\|was\\|be\\)\\s-+\\(\\w+ed\\|awoken\\|been\\|born\\|beat\\|become\\|begun\\|bent\\|beset\\|bet\\|bid\\|bidden\\|bound\\|bitten\\|bled\\|blown\\|broken\\|bred\\|brought\\|broadcast\\|built\\|burnt\\|burst\\|bought\\|cast\\|caught\\|chosen\\|clung\\|come\\|cost\\|crept\\|cut\\|dealt\\|dug\\|dived\\|done\\|drawn\\|dreamt\\|driven\\|drunk\\|eaten\\|fallen\\|fed\\|felt\\|fought\\|found\\|fit\\|fled\\|flung\\|flown\\|forbidden\\|forgotten\\|foregone\\|forgiven\\|forsaken\\|frozen\\|gotten\\|given\\|gone\\|ground\\|grown\\|hung\\|heard\\|hidden\\|hit\\|held\\|hurt\\|kept\\|knelt\\|knit\\|known\\|laid\\|led\\|leapt\\|learnt\\|left\\|lent\\|let\\|lain\\|lighted\\|lost\\|made\\|meant\\|met\\|misspelt\\|mistaken\\|mown\\|overcome\\|overdone\\|overtaken\\|overthrown\\|paid\\|pled\\|proven\\|put\\|quit\\|read\\|rid\\|ridden\\|rung\\|risen\\|run\\|sawn\\|said\\|seen\\|sought\\|sold\\|sent\\|set\\|sewn\\|shaken\\|shaven\\|shorn\\|shed\\|shone\\|shod\\|shot\\|shown\\|shrunk\\|shut\\|sung\\|sunk\\|sat\\|slept\\|slain\\|slid\\|slung\\|slit\\|smitten\\|sown\\|spoken\\|sped\\|spent\\|spilt\\|spun\\|spit\\|split\\|spread\\|sprung\\|stood\\|stolen\\|stuck\\|stung\\|stunk\\|stridden\\|struck\\|strung\\|striven\\|sworn\\|swept\\|swollen\\|swum\\|swung\\|taken\\|taught\\|torn\\|told\\|thought\\|thrived\\|thrown\\|thrust\\|trodden\\|understood\\|upheld\\|upset\\|woken\\|worn\\|woven\\|wed\\|wept\\|wound\\|won\\|withheld\\|withstood\\|wrung\\|written\\)\\b")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Weasel words
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconst proofreadr-weasel-words-regex "\\b\\(many\\|various\\|very\\|fairly\\|several\\|extremely\\|exceedingly\\|quite\\|remarkably\\|few\\|surprisingly\\|mostly\\|largely\\|huge\\|tiny\\|\\(\\(are\\|is\\) a number\\)\\|excellent\\|interestingly\\|significantly\\|substantially\\|clearly\\|vast\\|relatively\\|completely\\)\\b")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Proofreadr
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconst proofreadr-jargon-regex "\\(a priori\\|ad hoc\\|有的时候\\|affirmation\\|affirm\\|affirms\\|alterity\\|altermodern\\|aporia\\|aporetic\\|appropriates\\|appropriation\\|archetypal\\|archetypical\\|archetype\\|archetypes\\|autonomous\\|autonomy\\|baudrillardian\\|baudrillarian\\|commodification\\|committed\\|commitment\\|commonalities\\|contemporaneity\\|context\\|contexts\\|contextual\\|contextualise\\|contextualises\\|contextualisation\\|contextialize\\|contextializes\\|contextualization\\|contextuality\\|convention\\|conventional\\|conventions\\|coterminous\\|critique\\|cunning\\|cunningly\\|death of the author\\|debunk\\|debunked\\|debunking\\|debunks\\|deconstruct\\|deconstruction\\|deconstructs\\|deleuzian\\|desire\\|desires\\|dialectic\\|dialectical\\|dialectically\\|discourse\\|discursive\\|disrupt\\|disrupts\\|engage\\|engagement\\|engages\\|episteme\\|epistemic\\|ergo\\|fetish\\|fetishes\\|fetishise\\|fetishised\\|fetishize\\|fetishized\\|gaze\\|gender\\|gendered\\|historicise\\|historicisation\\|historicize\\|historicization\\|hegemonic\\|hegemony\\|identity\\|identity politics\\|intensifies\\|intensify\\|intensifying\\|interrogate\\|interrogates\\|interrogation\\|intertextual\\|intertextuality\\|irony\\|ironic\\|ironical\\|ironically\\|ironisation\\|ironization\\|ironises\\|ironizes\\|jouissance\\|juxtapose\\|juxtaposes\\|juxtaposition\\|lacanian\\|lack\\|loci\\|locus\\|locuses\\|matrix\\|mise en abyme\\|mocking\\|mockingly\\|modalities\\|modality\\|myth\\|mythologies\\|mythology\\|myths\\|narrative\\|narrativisation\\|narrativization\\|narrativity\\|nexus\\|nodal\\|node\\|normative\\|normativity\\|notion\\|notions\\|objective\\|objectivity\\|objectivities\\|objet petit a\\|ontology\\|ontological\\|operate\\|operates\\|otherness\\|othering\\|paradigm\\|paradigmatic\\|paradigms\\|parody\\|parodic\\|parodies\\|physicality\\|plenitude\\|poetics\\|popular notions\\|position\\|post hoc\\|post internet\\|post-internet\\|postmodernism\\|postmodernist\\|postmodernity\\|postmodern\\|practice\\|practise\\|praxis\\|problematic\\|problematics\\|problematise\\|problematize\\|proposition\\|qua\\|reading\\|readings\\|reification\\|relation\\|relational\\|relationality\\|relations\\|representation\\|representations\\|rhizomatic\\|rhizome\\|simulacra\\|simulacral\\|simulation\\|simulationism\\|simulationism\\|situate\\|situated\\|situates\\|stereotype\\|stereotypes\\|strategy\\|strategies\\|subjective\\|subjectivity\\|subjectivities\\|subvert\\|subversion\\|subverts\\|text\\|textual\\|textuality\\|thinker\\|thinkers\\|trajectory\\|transgress\\|transgresses\\|transgression\\|transgressive\\|unfolding\\|undermine\\|undermining\\|undermines\\|work\\|works\\|wry\\|wryly\\|zizekian\\)")

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

(defun proofreadr-passive-voice-search-for-keyword (limit)
  (proofreadr-search-for-keyword proofreadr-passive-voice-regex limit))

(defun proofreadr-weasel-words-search-for-keyword (limit)
  (proofreadr-search-for-keyword proofreadr-weasel-words-regex limit))

(defun proofreadr-search-for-jargon (limit)
  (proofreadr-search-for-keyword proofreadr-jargon-regex limit))

(defconst proofreadr-lexicalkwlist
  '((proofreadr-lexical-illusions-search-for-keyword 
     (2 'proofreadr-font-lock-lexical-illusions-face t))))

(defconst proofreadr-passivekwlist
  '((proofreadr-passive-voice-search-for-keyword 
     (0 'proofreadr-font-lock-passive-voice-face t))))

(defconst proofreadr-weaselkwlist
  '((proofreadr-weasel-words-search-for-keyword 
     (0 'proofreadr-font-lock-weasel-words-face t))))

(defconst proofreadr-kwlist
  '((proofreadr-search-for-jargon 
     (0 'proofreadr-font-lock-proofreadr-face t))))

(defun proofreadr-add-keywords ()
  (when proofreadr-lexical-illusions
    (font-lock-add-keywords nil proofreadr-lexicalkwlist))
  (when proofreadr-passive-voice
    (font-lock-add-keywords nil proofreadr-passivekwlist))
  (when proofreadr-weasel-words
    (font-lock-add-keywords nil proofreadr-weaselkwlist))
  (when proofreadr-jargon
    (font-lock-add-keywords nil proofreadr-kwlist)))

(defun proofreadr-remove-keywords ()
  (font-lock-remove-keywords nil proofreadr-lexicalkwlist)
  (font-lock-remove-keywords nil proofreadr-passivekwlist)
  (font-lock-remove-keywords nil proofreadr-weaselkwlist)
  (font-lock-remove-keywords nil proofreadr-kwlist))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconst proofreadr-mode-keymap (make-keymap))


;;;###autoload
(define-minor-mode proofreadr-mode "Highlight passive voice, weasel words and proofreadr jargon in text, and provide useful text metrics"
  :lighter " AB"
  :keymap proofreadr-mode-keymap
  :group 'proofreadr-mode
  (if proofreadr-mode
      (proofreadr-add-keywords)
    (proofreadr-remove-keywords)))

(provide 'proofreadr-mode)
