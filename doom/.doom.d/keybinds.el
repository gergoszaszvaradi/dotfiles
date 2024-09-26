;; General defaults

;; F14 as leader key
(map! :map key-translation-map
      "<XF86Launch5>" "C-c"
      "<Launch5>" "C-c"
      "<f14>" "C-c")

;; F1 for commands
(map! :map key-translation-map [f1] "M-x")

;; ESC to abort
(map! :map key-translation-map "ESC" "C-g")

;; Save with C-s
(map! "C-s" #'save-buffer)

;; New buffer
(map! "C-n" #'scratch-buffer)

;; Quit buffer
(map! "C-q" #'kill-this-buffer)

;; Select all
(map! "C-a" #'mark-whole-buffer)

;; Copy/Paste
(map! :map key-translation-map "C-c" "C-c x")
(map! "C-c x" (lambda () (interactive) (let (p1 p2 (deactivate-mark nil))
                                         (if current-prefix-arg
                                             (setq p1 (point-min) p2 (point-max))
                                           (if (use-region-p)
                                               (progn (setq p1 (region-beginning) p2 (region-end))
                                                      (kill-ring-save p1 p2))
                                             (progn
                                               (setq p1 (line-beginning-position) p2 (line-end-position))
                                               (kill-ring-save p1 p2)
                                               (kill-append "\n" t)))))))
(map! "C-v" #'yank)

;; Find and Replace
(map! "C-f" #'isearch-forward)
(map! "C-S-f" #'isearch-backward)
(map! :map isearch-mode-map "C-f" #'isearch-repeat-forward)
(map! :map key-translation-map "C-h" "C-M-%")

;; Undo/Redo
(map! :after undo-tree
      "C-z" #'undo-tree-undo
      "C-S-z" #'undo-tree-redo
      "C-M-z" #'undo-tree-visualize)

;; Minibuffer to buffer
(map! :after ivy
      :map ivy-minibuffer-map
      "C-o" #'ivy-occur)

;; Navigation

;; Home to indentation
(map! "<home>" #'back-to-indentation)

;; Jump words
(map! "C-<left>" (lambda () (interactive "^") (forward-same-syntax -1)))
(map! "C-<right>" (lambda () (interactive "^") (forward-same-syntax 1)))

;; Window navigation
(map! :leader :prefix "w"
      "w" #'delete-window
      "q" #'kill-buffer-and-window
      "h" #'split-window-right
      "v" #'split-window-below
      "f" (lambda () (interactive)
            (if (= 1 (length (cl-remove-if #'treemacs-is-treemacs-window? (window-list))))
                (jump-to-register '_)
              (progn
                (window-configuration-to-register '_)
                (delete-other-windows))))
      "m <left>" #'windmove-left
      "m <right>" #'windmove-right
      "m <up>" #'windmove-up
      "m <down>" #'windmove-down)

;; Go to line
(map! :leader "g l" #'goto-line)

;; LSP navigation
(map! :after lsp-mode :map lsp-mode-map :leader
      "g d" #'lsp-find-definition
      "g r" #'lsp-find-references
      "g i" #'lsp-find-implementation
      ;; "h" #'lsp-ui-doc-glance ;; @todo: figure out lsp-ui-mode
      "." #'lsp-execute-code-action)

;; Projectile
(map! :after projectile
      "C-<prior>" #'projectile-previous-project-buffer
      "C-<next>" #'projectile-next-project-buffer
      "C-\\" #'projectile-switch-to-buffer
      :map projectile-mode-map
      :leader
      :prefix "p"
      "p" #'projectile-switch-project
      "a" #'projectile-add-known-project
      "f" #'projectile-find-file
      "b" #'projectile-compile-project
      "r" #'projectile-run-project
      "t" #'projectile-test-project)
(map! :after counsel-projectile
      "C-c f r" #'counsel-projectile-rg
      "C-c f f" #'counsel-projectile-find-file)

;; Treemacs
(map! "C-e" #'treemacs)
(map! :map treemacs-mode-map
      "<right>" #'treemacs-RET-action
      "<left>" #'treemacs-COLLAPSE-action
      "r" #'treemacs-rename-file
      "p" #'treemacs-peek-mode)

;; Magit
(map! :leader "g g" #'magit-status)

;; Multiple cursors
(map! :after multiple-cursors
      "M-<mouse-1>" #'mc/add-cursor-on-click
      "C-d" #'mc/mark-next-like-this
      "C-S-d" #'mc/mark-all-like-this)

;; Editing

;; Comment/uncomment
(map! "C-/" #'comment-line)


;; Other

;; Copilot
(map! :after copilot :map copilot-completion-map
      "<tab>" #'copilot-accept-completion
      "TAB" #'copilot-accept-completion)
