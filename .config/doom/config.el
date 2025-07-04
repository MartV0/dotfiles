;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative lin numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq org-image-actual-width nil)

(require 'org-download)

;; Drag-and-drop to `dired`
(add-hook 'dired-mode-hook 'org-download-enable)

(defun fix-slide-haskell ()
    "test"
    (interactive)
    (setq return_line (line-number-at-pos)) ;; TODO: use save-excursion
    (while (re-search-forward "λ" nil t)
           (replace-match "\\\\"))
    (with-no-warnings (goto-line return_line))
    (while (re-search-forward "→" nil t)
           (replace-match "->"))
    (with-no-warnings (goto-line return_line))
    )

(setq catppuccin-flavor 'mocha)
(setq doom-theme 'catppuccin)
;(setq default-frame-alist '((alpha-background . 80))) ;;set background opacity

(scroll-bar-mode -1) ; remove scroll bar

(global-display-fill-column-indicator-mode)
(setq display-fill-column-indicator-column 90)

;; Org stuff
(setq org-priority-highest 1
      org-priority-default 5
      org-priority-lowest 10)

; Function scale latex fragments along with the text
(defun update-org-latex-fragments ()
  (org-latex-preview '(64))
  (plist-put org-format-latex-options :scale text-scale-mode-amount)
  (org-latex-preview '(16)))

(add-hook 'org-mode-hook (lambda () (add-hook 'text-scale-mode-hook 'update-org-latex-fragments nil 'make-it-local)))

(map! :map pdf-view-mode-map
      :n "i" 'org-noter-insert-note
      :n "I" 'org-noter-insert-precise-note
      :n "M-j" 'org-noter-sync-next-note
      :n "M-k" 'org-noter-sync-prev-note
      :n "M-q" 'org-noter-kill-session
      :n "n" 'org-noter
      :n "N" 'org-noter-kill-session
      :n "J" 'pdf-view-next-page
      :n "K" 'pdf-view-previous-page)

(map! :leader
      (:prefix ("n". "notes")
        :desc "kill org noter" "E" 'org-noter-kill-session
        :desc "Goto node location" "g" 'org-noter-sync-current-note))

(setq
  org-noter-notes-window-location 'horizontal-split
  org-noter-hide-other nil
  org-noter-always-create-frame nil
  org-noter-disable-narrowing t
  org-noter-use-indirect-buffer nil
  org-noter-default-heading-title "$p$"
)

(setq
  ;; org-directory "~/Documents/Org"
  org-use-property-inheritance t
  org-startup-with-inline-images t
  org-hide-emphasis-markers t
  org-edit-src-content-indentation 0
  org-startup-with-latex-preview t)

;; Keybindings
(map! :leader
      (:prefix ("o". "open")
       :desc "magit"  "m" #'magit))


;; latex stuff
(setq +latex-viewers '(pdf-tools))
(add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer) ; automatically refresh the pdf tools buffer
(add-hook 'TeX-after-compilation-finished-functions
          (lambda (_) (message "Compilation finished!")))
(add-hook 'LaTeX-mode-hook (lambda () (add-hook 'after-save-hook (lambda () (TeX-command-run-all nil)) nil 'make-it-local))) ; compile tex after saving
(setq TeX-save-query nil) ; before compiling do not ask for permission to save
(map! :map cdlatex-mode-map :i "TAB" #'cdlatex-tab) ; overwrite the tab bound by yas snippet
(setq lsp-tex-server 'texlab)
