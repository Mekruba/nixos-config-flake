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
;; - `doom-symbol-font' -- for symbols
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
                                        ;
;; Theme options for doom-gruvbox-light
(setq
 ;; brighter mode-line?
 doom-gruvbox-light-brighter-modeline t

 ;; brighter comments?
 doom-gruvbox-light-brighter-comments nil

 ;; comment background
 doom-gruvbox-light-comment-bg nil

 ;; padded modeline: t for default (4px), number for exact px
 doom-gruvbox-light-padded-modeline 4

 ;; contrast variant
 doom-gruvbox-light-variant "soft")

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox-light)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
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

;; (use-package! justl
;;   :config
;;   (map! :n "e" 'justl-exec-recipe))
;;

;; disable system clipboard insta sync
(setq select-enable-clipboard nil
      select-enable-primary nil)

;; Unbind Doom's default `gr` (quickrn)
(map! :n "gr" nil)

(map! :after lsp-mode
      :map lsp-mode-map
      :n "gr" #'lsp-find-references
      :n "gi" #'lsp-find-implementation)

(after! treesit
  (add-to-list 'treesit-language-source-alist
               '(c-sharp "https://github.com/tree-sitter/tree-sitter-c-sharp")))

(after! treesit
  (setq treesit-font-lock-level 4))

(add-hook 'csharp-ts-mode-hook
          (lambda ()
            (setq-local treesit-font-lock-level 4)
            (font-lock-flush)
            (font-lock-ensure)))



;; Angular templates: use web-mode
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))


;; Optional: Angular component templates sometimes benefit from slightly tweaked web-mode settings
(after! web-mode
  (setq web-mode-markup-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-css-indent-offset 2))

(use-package jj-mode
  :commands (jj-log))

;; Ensure LSP starts for relevant buffers
(add-hook 'web-mode-hook #'lsp-deferred)
(add-hook 'typescript-mode-hook #'lsp-deferred)
(after! lsp-mode
  (require 'lsp-angular)
  (setq lsp-angular-server-command
        (list (executable-find "ngserver") "--stdio")))

;; TODO states
(setq org-todo-keywords
      '((sequence "TODO(t)" "PLANNING(p)" "IN-PROGRESS(i@/!)" "VERIFYING(v!)" "BLOCKED(b@)"  "|" "DONE(d!)" "OBE(o@!)" "WONT-DO(w@/!)" )
        ))

(defun my/majutsu-log-emacs-state ()
  "Open the Majutsu log and immediately switch to Emacs state."
  (interactive)
  (majutsu-log)
  ;; Wait a moment for the buffer to open, then switch to emacs state
  (run-at-time
   0.05 nil
   (lambda ()
     (when (derived-mode-p 'majutsu-log-mode)
       (evil-emacs-state)))))

(with-eval-after-load 'majutsu
  ;; Ensure Majutsu's Evil setup runs if available
  (when (fboundp 'majutsu-evil-setup)
    (majutsu-evil-setup))

  ;; Bind relevant keys in Evil normal state for the Majutsu log UI
  (evil-define-key 'normal majutsu-log-mode-map
    "G" #'majutsu-git-transient))

(defvar my/j-map (make-sparse-keymap)
  "My custom leader submap for SPC j …")

(map! :leader "j" my/j-map)
(map! :map my/j-map
      :desc "Majutsu Log (Emacs state)" "l" #'my/majutsu-log-emacs-state
      :desc "Justfile tasks"            "f" #'justl)


;; (use-package! justl
;;   :custom
;;   (justl-per-recipe-buffer t)
;;   :config
;;   (map! :n "e" #'justl-exec-vterm))

(map! :leader
      :desc "Fuzzy switch workspace"
      "r" #'+workspace/switch-to)

(use-package! grease
  :commands (grease-open grease-toggle grease-here)
  :init
  (setq grease-sort-method 'type
        grease-show-hidden nil
        grease-preview-window-width 0.4)
  :config
  (map! :leader
        (:prefix ("o g" . "Grease")
         :desc "Toggle Grease"           "g" #'grease-toggle
         :desc "Open Grease (current)"   "o" #'grease-open
         :desc "Open at project root"    "h" #'grease-here)))

;; Silence byte-compiler: tell it this is a special (dynamic) var.
(defvar vterm-buffer-name)

(after! vterm
  (after! justl
    (defun my/justl-vterm-per-recipe (orig-fn &rest args)
      (let* ((recipe (justl--get-recipe-under-cursor))
             (vterm-buffer-name (format "*just-%s*" (justl--recipe-name recipe))))
        (apply orig-fn args)))
    (advice-add #'justl-exec-vterm :around #'my/justl-vterm-per-recipe)))
(after! justl
  (setq justl-shell 'vterm)

  (map! :map justl-mode-map
        :localleader
        :desc "Execute recipe in vterm"
        "x" #'justl-exec-vterm
        :desc "Execute recipe"
        "e" #'justl-exec-recipe
        :desc "Execute default in vterm"
        "d" #'justl-exec-default-recipe))


(use-package! envrc
  :config
  (envrc-global-mode))

(add-hook 'after-save-hook
          (lambda ()
            (when (and (bound-and-true-p envrc-global-mode)
                       buffer-file-name
                       (string-match-p (rx (or ".env" ".envrc") eos) buffer-file-name))
              (envrc-reload))))


;; (use-package! evil-colemak-basics
;;   :after evil
;;   :init
;;   ;; Enable Mod-DH / DHm support (swaps bindings for `m` and `h`)
;;   (setq evil-colemak-basics-layout-mod 'mod-dh)
;;   :config
;;   (global-evil-colemak-basics-mode))

;; (after! evil
;;   ;; Window movement (C-w …)
;;   (map! :map evil-window-map
;;         "m" #'evil-window-left
;;         "n" #'evil-window-down
;;         "e" #'evil-window-up
;;         "i" #'evil-window-right)

;;   ;; Optional: put old hjkl window keys back where they came from
;;   (map! :map evil-window-map
;;         "h" #'evil-window-prev
;;         "j" #'evil-window-next
;;         "k" #'evil-window-up
;;         "l" #'evil-window-right))

;; (after! evil
;;   (map! :map evil-window-map
;;         "M" #'evil-window-decrease-width
;;         "I" #'evil-window-increase-width
;;         "N" #'evil-window-decrease-height
;;         "E" #'evil-window-increase-height))

;; ─────────────────────────────────────────────────────────────
;; Colemak-DH toggleable Evil layer
;; ─────────────────────────────────────────────────────────────

(defvar my/colemak-dh-evil-map (make-sparse-keymap)
  "Keymap enabled when `my/colemak-dh-evil-mode' is active.")

(define-minor-mode my/colemak-dh-evil-mode
  "Toggle Colemak-DH Evil bindings."
  :init-value nil
  :global t
  ;; :keymap my/colemak-dh-evil-map
  :lighter " CDH")   ;; ← mode-line indicator

(after! evil
  ;; -----------------------------------------------------------
  ;; Core movement (Colemak-DH home row)
  ;; -----------------------------------------------------------
  ;; (evil-define-key '(normal visual motion operator)
  ;;     my/colemak-dh-evil-map
  ;;   ;; Movement
  ;;   "m" #'evil-backward-char     ; ←
  ;;   "n" #'evil-next-line         ; ↓
  ;;   "e" #'evil-previous-line     ; ↑
  ;;   "i" #'evil-forward-char      ; →

  ;;   ;; Old m n e i functionality → hjkl
  ;;   "h" #'evil-set-marker        ; old m
  ;;   "j" #'evil-search-next       ; old n
  ;;   "k" #'evil-end-of-word       ; old e
  ;;   "l" #'evil-insert)           ; old i

  ;; -----------------------------------------------------------
  ;; Window movement (C-w …)
  ;; -----------------------------------------------------------
  ;; Reuse evil-window-map under C-w
  (define-key my/colemak-dh-evil-map (kbd "C-w") evil-window-map)

  (map! :map evil-window-map
        "m" #'evil-window-left
        "n" #'evil-window-down
        "e" #'evil-window-up
        "i" #'evil-window-right)

  ;; Optional: window resizing (Shifted)
  (map! :map evil-window-map
        "M" #'evil-window-decrease-width
        "I" #'evil-window-increase-width
        "N" #'evil-window-decrease-height
        "E" #'evil-window-increase-height))

;; ─────────────────────────────────────────────────────────────
;; Leader key toggle
;; ─────────────────────────────────────────────────────────────
(map! :leader
      :desc "Toggle Colemak-DH Evil keys"
      "t C" #'my/colemak-dh-evil-mode)



;; TS/JS buffers
(add-hook 'typescript-mode-hook #'lsp-deferred)
(add-hook 'js-mode-hook #'lsp-deferred)

;; Angular templates are usually web-mode in Doom
(add-hook 'web-mode-hook #'lsp-deferred)


(after! lsp-mode
  (require 'lsp-angular)

  ;; Only treat a buffer as "Angular-project HTML" if we're under a folder
  ;; that contains angular.json (adjust if you use Nx or other layouts).
  (defun my/angular-project-p ()
    (locate-dominating-file default-directory "angular.json"))

  ;; Register an Angular LS client that can attach to web-mode HTML buffers
  ;; *in Angular projects*, without replacing your normal HTML server.
  (lsp-register-client
   (make-lsp-client
    :new-connection
    (lsp-stdio-connection
     (or lsp-clients-angular-language-server-command
         '("ngserver" "--stdio")))
    :activation-fn
    (lambda (filename _mode)
      (and filename
           (string-match-p "\\.html\\'" filename)
           (eq major-mode 'web-mode)
           (my/angular-project-p)))
    :add-on? t
    :server-id 'angular-ls-webmode)))

(after! corfu
  (setq corfu-auto t
        corfu-auto-prefix 1
        corfu-auto-delay 0
        corfu-preselect 'first
        corfu-cycle t)

  ;; keybindings while popup is active
  (map! :map corfu-map
        :i "C-n" #'corfu-next
        :i "C-p" #'corfu-previous
        :i "C-y" #'corfu-insert
        :i "TAB" #'corfu-insert
        :i [tab] #'corfu-insert

        ;; FIX: make backspace delete normally while corfu popup is active
        :i "DEL" #'evil-delete-backward-char
        :i [backspace] #'evil-delete-backward-char))

;; Disable Corfu in the minibuffer (so ":" / ":w" / ":q" don't auto-suggest)
(after! corfu
  (defun my/corfu-disable-in-minibuffer ()
    (when (minibufferp)
      (setq-local corfu-auto nil)
      (corfu-mode -1)))
  (add-hook 'minibuffer-setup-hook #'my/corfu-disable-in-minibuffer))


;; Global case-insensitive completion (minibuffer + capf/corfu)
(setq completion-ignore-case t
      read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t)

;; Doom commonly uses orderless; disable “smart case” so uppercase doesn't force case-sensitive matching
(after! orderless
  (setq orderless-smart-case nil))


(add-hook 'typescript-ts-mode-hook #'lsp-deferred)
(add-hook 'typescript-ts-mode-hook #'lsp)

(setq major-mode-remap-alist
      (append major-mode-remap-alist
              '((typescript-mode . typescript-ts-mode)
                (tsx-mode . tsx-ts-mode))))

;; Also ensure file extensions go to ts modes
(add-to-list 'auto-mode-alist '("\\.ts\\'"  . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))

(after! lsp-mode
  ;; Don't run LSP in diff buffers (majutsu / patches / vc diffs).
  (add-hook 'diff-mode-hook (lambda () (lsp-mode -1))))


;; Make Ediff temp/control buffers belong to the same project as the compared files.
(after! ediff
  (defun +my/ediff--project-root-from (buf)
    "Return a sensible project root for BUF (Projectile/Doom/project.el)."
    (when (buffer-live-p buf)
      (with-current-buffer buf
        (or (and (fboundp 'doom-project-root) (doom-project-root))
            (and (fboundp 'projectile-project-root) (projectile-project-root))
            (when-let ((proj (project-current nil default-directory)))
              (car (project-roots proj)))
            default-directory))))

  (defun +my/ediff-set-default-directory ()
    "Set `default-directory` in Ediff buffers to the compared buffers' project root."
    (let ((root (or (+my/ediff--project-root-from ediff-buffer-A)
                    (+my/ediff--project-root-from ediff-buffer-B)
                    (+my/ediff--project-root-from ediff-buffer-C))))
      (when root
        ;; Control panel
        (when (buffer-live-p ediff-control-buffer)
          (with-current-buffer ediff-control-buffer
            (setq default-directory root)))
        ;; Sometimes Ediff uses dedicated diff/registry buffers too
        (dolist (b (list ediff-buffer-A ediff-buffer-B ediff-buffer-C))
          (when (buffer-live-p b)
            (with-current-buffer b
              (setq default-directory root)))))))

  ;; Run after Ediff has created its buffers/windows
  (add-hook 'ediff-after-setup-windows-hook #'+my/ediff-set-default-directory))

;; (map! :n "C-s" 'harpoon-quick-menu-hydra)
;; (map! :n "C-s f" 'harpoon-add-file)
;; (after! harpoon
;;   ;; Jump keys for slots 1..9 (use whatever you want here)
;;   (defconst my/harpoon-hydra-keys
;;     '("m" "n" "e" "i" "o" "6" "7" "8" "9"))

;;   (defun harpoon--hydra-candidates (method)
;;     "Candidates for harpoon hydras.
;; METHOD is a string prefix like \"harpoon-go-to-\" or \"harpoon-delete-\"."
;;     (let* ((line-number 0)
;;            (files (seq-take (delete "" (split-string (harpoon--get-file-text) "\n")) 9)))
;;       (mapcar
;;        (lambda (item)
;;          (setq line-number (1+ line-number))
;;          (let ((key (nth (1- line-number) my/harpoon-hydra-keys)))
;;            (list (or key (format "%s" line-number)) ; fallback if list too short
;;                  (intern (concat method (format "%s" line-number)))
;;                  (harpoon--format-item-name item)
;;                  :column (if (< line-number 6) "1-5" "6-9"))))
;;        files))))

;; Open the hydra (this function already calls the hydra body internally)
;; (map! :n "C-s" #'harpoon-quick-menu-hydra)

;; (map! :n "C-s" #'harpoon-quick-menu-hydra/body)

;; (map! :leader "j c" 'harpoon-clear)
;; (map! :leader "j t" 'harpoon-toggle-file)
;; (map! "M-n" 'harpoon-go-to-1)
;; (map! "M-e" 'harpoon-go-to-2)
;; (map! "M-i" 'harpoon-go-to-3)
;; (map! "M-o" 'harpoon-go-to-4)
(map! :n "C-s n" (cmd! (+workspace/switch-to 0))
      :n "C-s e" (cmd! (+workspace/switch-to 1))
      :n "C-s i" (cmd! (+workspace/switch-to 2))
      :n "C-s o" (cmd! (+workspace/switch-to 3))
      :n "C-s u" (cmd! (+workspace/switch-to 4)))
;; (map! :leader "5" 'harpoon-go-to-5)
;; (map! :leader "6" 'harpoon-go-to-6)
;; (map! :leader "7" 'harpoon-go-to-7)
;; (map! :leader "8" 'harpoon-go-to-8)
;; (map! :leader "9" 'harpoon-go-to-9)

(defun my/org-refresh-dailies-call ()
  "Refresh the `#+CALL: dailies-links()` under the *Daily Notes* heading only."
  (when (derived-mode-p 'org-mode)
    (save-excursion
      (goto-char (point-min))
      (when (re-search-forward "^\\*+[ \t]+Daily Notes\\b" nil t)
        (org-narrow-to-subtree)
        (goto-char (point-min))
        (when (re-search-forward "^[ \t]*#\\+CALL:[ \t]*dailies-links()" nil t)
          (beginning-of-line)
          (org-babel-lob-execute-maybe))
        (widen)))))

(add-hook 'find-file-hook #'my/org-refresh-dailies-call)

;; uses git instead, so i dont have to worry about cache invalidation if creating files outside of emacs
(after! projectile
  (setq projectile-indexing-method 'alien)
  (setq projectile-enable-caching nil))

;; center my shit
(after! evil
  (defun my/evil-scroll-down-and-center ()
    (interactive)
    (call-interactively #'evil-scroll-down)
    (recenter))

  (defun my/evil-scroll-up-and-center ()
    (interactive)
    (call-interactively #'evil-scroll-up)
    (recenter))

  ;; Normal state (Vim-like)
  (define-key evil-normal-state-map (kbd "C-d") #'my/evil-scroll-down-and-center)
  (define-key evil-normal-state-map (kbd "C-u") #'my/evil-scroll-up-and-center)

  ;; Optional: also in visual state
  (define-key evil-visual-state-map (kbd "C-d") #'my/evil-scroll-down-and-center)
  (define-key evil-visual-state-map (kbd "C-u") #'my/evil-scroll-up-and-center))



(setq vulpea-db-sync-directories '("~/org/roam"))


(after! grease
  (map! :leader
        "e" #'grease-open))

(after! lsp-ui
  ;; Force peek UI even when there's only one definition location
  (setq lsp-ui-peek-always-show t

        ;; (optional) make sure peek is enabled + tune sizing
        lsp-ui-peek-enable t
        lsp-ui-peek-peek-height 20
        lsp-ui-peek-list-width 60))


(after! org
  (setq org-preview-latex-default-process 'dvisvgm)

  ;; Optional but usually fixes the “white box” on dark themes
  (setq org-format-latex-options
        (plist-put org-format-latex-options :background "Transparent")))

(eval-after-load "org"
  '(require 'ox-gfm nil t))

(use-package! org-transclusion
  :after org
  :config
  (add-to-list 'org-transclusion-extensions 'org-transclusion-indent-mode)
  (require 'org-transclusion-indent-mode))

(after! org-agenda
  (require 'org-super-agenda)
  (org-super-agenda-mode))

(after! org
  (setq org-agenda-custom-commands
        '(("a" "Agenda"
           ((agenda "")
            (alltodo ""))
           ((org-super-agenda-groups
             '((:name "Today"
                :scheduled today)

               (:name "Due Today"
                :deadline today)

               (:name "Overdue"
                :deadline past)

               (:name "Important"
                :priority "A")

               (:name "Work"
                :tag "work")

               (:discard (:anything t)))))))))
