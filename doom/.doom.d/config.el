;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Maximize
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

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
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "CaskaydiaCove NF" :size 14 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "CaskaydiaCove NF" :size 14))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-tomorrow-night)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

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

;; F14 as leader key
(map! :map key-translation-map
      "<XF86Launch5>" "C-c"
      "<Launch5>" "C-c"
      "<f14>" "C-c")

;; Ivy
(map! :after ivy
      :map ivy-minibuffer-map
      "C-o" #'ivy-occur)

;; Copilot
(after! copilot
  (setq copilot-indent-offset-warning-disable t))
(add-hook 'prog-mode-hook 'copilot-mode)
(map! :after copilot :map copilot-completion-map
      "<tab>" #'copilot-accept-completion
      "TAB" #'copilot-accept-completion)

;; LSP
(after! lsp-mode
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-ui-sideline-enable +1)
  (setq lsp-enable-snippet nil))
(add-hook 'go-mode-hook #'lsp-deferred)
(add-hook 'typescript-mode-hook #'lsp-deferred)
(add-hook 'post-command-hook 
          (lambda ()
            (flycheck-popup-tip-mode -1)))
(map! :after lsp-mode :map lsp-mode-map
      "C-c g d" #'lsp-find-definition
      "C-c g r" #'lsp-find-references
      "C-c g i" #'lsp-find-implementation
      "C-c h" #'lsp-ui-doc-glance ;; @todo: figure out lsp-ui-mode
      "C-c ." #'lsp-execute-code-action)

;; Projectile
;; (after! projectile
;;   (projectile-buffers-filter-function 'projectile-buffers-with-file-or-process))
(map! :after projectile
      "C-<prior>" #'projectile-previous-project-buffer
      "C-<next>" #'projectile-next-project-buffer
      "C-\\" #'projectile-switch-to-buffer
      :map projectile-mode-map
      :prefix "C-p"
      "p" #'projectile-switch-project
      "a" #'projectile-add-known-project
      "f" #'projectile-find-file
      "b" #'projectile-compile-project
      "r" #'projectile-run-project
      "t" #'projectile-test-project)

;; Counsel
(map! :after counsel-projectile
      "C-c f r" #'counsel-projectile-rg
      "C-c f f" #'counsel-projectile-find-file)

;; Treemacs
(after! treemacs
  (setq treemacs-width 50)
  (setq treemacs-position 'right)
  (setq treemacs-show-hidden-files t)
  (setq treemacs-follow-mode t)
  (setq treemacs-filewatch-mode t)
  (setq treemacs-file-event-delay 500)
  (setq treemacs-display-current-project-exclusively t))
(map! "C-e" #'treemacs)
(map! :after treemacs
      :map treemacs-mode-map
      "<right>" #'treemacs-RET-action ;; Open folder
      "<left>" #'treemacs-COLLAPSE-action ;; Focus parent or close folder
      "r" #'treemacs-rename-file ;; Rename entry
      "p" #'treemacs-peek-mode) ;; Peek file

;; Undo tree
(map! :after undo-tree
      "C-z" #'undo-tree-undo
      "C-S-z" #'undo-tree-redo
      "C-M-z" #'undo-tree-visualize)

;; HL TODO
(after! hl-todo
  (setq hl-todo-keyword-faces
        '(("todo"   . "#F6E96B")
          ("dont"   . "#FF5246")
          ("fail"   . "#FF5246")
          ("bug"    . "#FF5246")
          ("issue"  . "#FF5246")
          ("note"   . "#5B99C2")
          ("maybe"  . "#B5CFB7")
          ("hack"   . "#A652FF")
          ("fixme"  . "#FF8343"))))

;; Multiple cursors
(map! :after multiple-cursors
      "M-<mouse-1>" #'mc/add-cursor-on-click
      "C-d" #'mc/mark-next-like-this
      "C-S-d" #'mc/mark-all-like-this)

;; Keybindings

;; F1 for commands
(map! :map key-translation-map [f1] "M-x")

;; ESC for abort
(map! :map key-translation-map "ESC" "C-g")

;; Find and Replace
(map! "C-f" #'isearch-forward)
(map! "C-S-f" #'isearch-backward)
(map! :map isearch-mode-map "C-f" #'isearch-repeat-forward)
(map! :map key-translation-map "C-h" "C-M-%")

;; Save with C-s
(map! "C-s" #'save-buffer)

;; Editing
(map! "C-S-k" #'kill-whole-line)
(map! :map key-translation-map "C-c" "C-c x")
(map! "C-c x" (lambda () (interactive) (let (ξp1 ξp2 (deactivate-mark nil))
                                         (if current-prefix-arg
                                             (setq ξp1 (point-min) ξp2 (point-max))
                                           (if (use-region-p)
                                               (progn (setq ξp1 (region-beginning) ξp2 (region-end))
                                                      (kill-ring-save ξp1 ξp2))
                                             (progn
                                               (setq ξp1 (line-beginning-position) ξp2 (line-end-position))
                                               (kill-ring-save ξp1 ξp2)
                                               (kill-append "\n" t)))))))
(map! "C-v" #'yank)
(map! "C-/" #'comment-line)
(map! "C-a" #'mark-whole-buffer)

;; Navigation
(map! [home] #'back-to-indentation)
(map! "C-<left>" (lambda () (interactive "^") (forward-same-syntax -1))) ;; Jump left until different symbol type
(map! "C-<right>" (lambda () (interactive "^") (forward-same-syntax 1))) ;; Jump right until different symbol type
(map! "M-<right>" #'windmove-right) ;; Focus right window
(map! "M-<left>" #'windmove-left) ;; Focus left window
(global-unset-key (kbd "C-w"))
(map! "C-w w" #'delete-window) ;; Close window
(map! "C-w C-w" #'delete-window)
(map! "C-w q" #'kill-buffer-and-window) ;; Close window and buffer
(map! "C-w C-q" #'kill-buffer-and-window)
(map! "C-w v" #'split-window-below) ;; Split vertically
(map! "C-w C-v" #'split-window-below)
(map! "C-w h" #'split-window-right) ;; Split horizontally
(map! "C-w C-h" #'split-window-right)
(map! "C-w <left>" #'windmove-left) ;; Focus left window
(map! "C-w <right>" #'windmove-right) ;; Focus right window
(map! "C-w <up>" #'windmove-up) ;; Focus top window
(map! "C-w <down>" #'windmove-down) ;; Focus bottom window
(map! "C-w f" #'toggle-maximize-buffer) ;; Fullscreen window
(map! "C-q" #'kill-this-buffer) ;; Close buffer
(map! "C-l" #'goto-line) ;; Go to line
(map! "C-n" #'scratch-buffer) ;; New buffer
