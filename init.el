;;;;
;; Packages
;;;;

;; Define package repositories
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("tromey" . "http://tromey.com/elpa/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

;; (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
;;                          ("marmalade" . "http://marmalade-repo.org/packages/")
;;                          ("melpa" . "http://melpa-stable.milkbox.net/packages/")))


;; Load and activate emacs packages. Do this first so that the
;; packages are loaded before you start trying to modify them.
;; This also sets the load path.
(package-initialize)

;; Download the ELPA archive description if needed.
;; This informs Emacs about the latest versions of all packages, and
;; makes them available for download.
(when (not package-archive-contents)
  (package-refresh-contents))

;; The packages you want installed. You can also install these
;; manually with M-x package-install
;; Add in your own as you wish:
(defvar my-packages
  '(;; makes handling lisp expressions much, much easier
    ;; Cheatsheet: http://www.emacswiki.org/emacs/PareditCheatsheet
    paredit

    ;; key bindings and code colorization for Clojure
    ;; https://github.com/clojure-emacs/clojure-mode
    clojure-mode

    ;; extra syntax highlighting for clojure
    clojure-mode-extra-font-locking

    ;; integration with a Clojure REPL
    ;; https://github.com/clojure-emacs/cider
    cider

    ;; allow ido usage in as many contexts as possible. see
    ;; customizations/navigation.el line 23 for a description
    ;; of ido
    ido-ubiquitous

    ;; Enhances M-x to allow easier execution of commands. Provides
    ;; a filterable list of possible commands in the minibuffer
    ;; http://www.emacswiki.org/emacs/Smex
    smex

    ;; project navigation
    projectile

    ;; colorful parenthesis matching
    rainbow-delimiters

    ;; edit html tags like sexps
    tagedit

    ;; git integration
    magit))

;; On OS X, an Emacs instance started from the graphical user
;; interface will have a different environment than a shell in a
;; terminal window, because OS X does not run a shell during the
;; login. Obviously this will lead to unexpected results when
;; calling external utilities like make from Emacs.
;; This library works around this problem by copying important
;; environment variables from the user's shell.
;; https://github.com/purcell/exec-path-from-shell
(if (eq system-type 'darwin)
    (add-to-list 'my-packages 'exec-path-from-shell))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))


;; Place downloaded elisp files in ~/.emacs.d/vendor. You'll then be able
;; to load them.
;;
;; For example, if you download yaml-mode.el to ~/.emacs.d/vendor,
;; then you can add the following code to this file:
;;
;; (require 'yaml-mode)
;; (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
;;
;; Adding this code will make Emacs enter yaml mode whenever you open
;; a .yml file
(add-to-list 'load-path "~/.emacs.d/vendor")


;;;;
;; Customization
;;;;

;; Add a directory to our load path so that when you `load` things
;; below, Emacs knows where to look for the corresponding file.
(add-to-list 'load-path "~/.emacs.d/customizations")

;; Sets up exec-path-from-shell so that Emacs will use the correct
;; environment variables
(load "shell-integration.el")

;; These customizations make it easier for you to navigate files,
;; switch buffers, and choose options from the minibuffer.
(load "navigation.el")

;; These customizations change the way emacs looks and disable/enable
;; some user interface elements
(load "ui.el")

;; These customizations make editing a bit nicer.
(load "editing.el")

;; Hard-to-categorize customizations
(load "misc.el")

;; For editing lisps
(load "elisp-editing.el")

;; Langauage-specific
(load "setup-clojure.el")
(load "setup-js.el")

;; theme
(load "theme.el")

;; auto complete
(load "support.el")

;; scala mode
(unless (package-installed-p 'scala-mode2)
   (package-refresh-contents) (package-install 'scala-mode2))

(tool-bar-mode -1)
(menu-bar-mode -1)

;; folder tree
(unless (package-installed-p 'neotree)
   (package-refresh-contents) (package-install 'neotree))

(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

;; php-mode
(unless (package-installed-p 'php-mode)
   (package-refresh-contents) (package-install 'php-mode))
(require 'php-mode)

;; ensime
(unless (package-installed-p 'ensime)
   (package-refresh-contents) (package-install 'ensime))
(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

(defun scala/enable-eldoc ()
  "Show error message at point by Eldoc."
    (setq-local eldoc-documentation-function
  #'(lambda ()
    (when (ensime-connected-p)
     (let ((err (ensime-print-errors-at-point)))
      (and err (not (string= err "")) err)))))
    (eldoc-mode +1))
(add-hook 'ensime-mode-hook #'scala/enable-eldoc)

;; web mode
(unless (package-installed-p 'web-mode)
   (package-refresh-contents) (package-install 'web-mode))
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x$"   . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.js?$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsx$"     . web-mode))

(defun web-mode-hook ()
   "Hooks for Web mode."
    (setq web-mode-html-offset   2)
    (setq web-mode-css-offset    2)
    (setq web-mode-script-offset 2)
    (setq web-mode-php-offset    2)
    (setq web-mode-java-offset   2)
    (setq web-mode-asp-offset    2))
  (add-hook 'web-mode-hook 'web-mode-hook)

(custom-set-faces
  '(web-mode-doctype-face
    ((t (:foreground "#82AE46"))))                          ; doctype
  '(web-mode-html-tag-face
    ((t (:foreground "#E6B422" :weight bold))))             ; 要素名
  '(web-mode-html-attr-name-face
    ((t (:foreground "#C97586"))))                          ; 属性名など
  '(web-mode-html-attr-value-face
    ((t (:foreground "#82AE46"))))                          ; 属性値
  '(web-mode-comment-face
    ((t (:foreground "#D9333F"))))                          ; コメント
  '(web-mode-server-comment-face
    ((t (:foreground "#D9333F"))))                          ; コメント
  '(web-mode-css-rule-face
    ((t (:foreground "#A0D8EF"))))                          ; cssのタグ
  '(web-mode-css-pseudo-class-face
    ((t (:foreground "#FF7F00"))))                          ; css 疑似クラス
  '(web-mode-css-at-rule-face
    ((t (:foreground "#FF7F00"))))                          ; cssのタグ
   )

;; whitespace
(require 'whitespace)
(setq whitespace-style '(face           ; faceで可視化
                         trailing       ; 行末
                         tabs           ; タブ
                         empty          ; 先頭/末尾の空行
                         space-mark     ; 表示のマッピング
                         tab-mark
                         ))
(setq whitespace-display-mappings
       '((tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))
(setq whitespace-space-regexp "\\(\u3000\\)")
(setq whitespace-style '(face tabs tab-mark spaces space-mark))
(setq whitespace-display-mappings ())
(set-face-foreground 'whitespace-tab "#F1C40F")
(set-face-background 'whitespace-space "#E74C3C")
(global-whitespace-mode 1)

;; disable tab indent
(setq-default indent-tabs-mode nil)

; 勝手にインデントしないようにする設定
(electric-indent-mode 0)
