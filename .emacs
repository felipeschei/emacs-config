;; use command as meta key - I find this to be more comfortable than the default option key
(setq mac-command-modifier 'meta)

;; set directory to load lisp files
(add-to-list 'load-path "~/.emacs.d/lisp/")

;; add breathing room between line #s and text
(set-fringe-mode 10)

;; set up visible bell - commenting this line because the bell is very annoying on MacOS
;; (setq visible-bell t)

;; set up fira code font
(set-face-attribute 'default nil :font "Fira Code" :height 140)

;; remove splash screen
(setq inhibit-startup-message t)


;; hide toolbar
(if(fboundp 'tool-bar-mode)(tool-bar-mode -1))

;; show line numbers
(global-linum-mode 1)

;; disable line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))



;; show column number
(column-number-mode 1)

;; highlight current line
(global-hl-line-mode 1)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; enable auto-indent by default when pressing return
(define-key global-map (kbd "RET") 'newline-and-indent)

;; open emacs maximized by default
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; set tooltip so it only shows in the echo area
(tooltip-mode -1)
(setq tooltip-use-echo-area t)

;;configure package repositories
(require 'package)

(setq package-archives
       '(("gnu" . "https://elpa.gnu.org/packages/")
	 ("melpa" . "https://melpa.org/packages/")
	 ("org" . "https://orgmode.org/elpa/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package (needed for non-Linux platforms)
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)


(use-package command-log-mode) ;; displays history of commands & descriptions in buffer

;; set up ivy
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

;; set up minimalistic mode line
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

;; set up mode bar icons
;; when configuring machine for the first time, remember to run
;; M-x all-the-icon-install-fonts

(use-package all-the-icons)

;; set up doom themes
(use-package doom-themes)

;; set up rainbow delimiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))


;; the which key package displays key binding options after entering a prefix key
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))


;; ivi-rich displays command information when using M-x
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

;; set up counsel for better buffer and directory navigation
(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil)) ;; don't start searches with ^



;; set up helpful to complement emacs native help functions
(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))


;; set up general to handle keybindings
(use-package general
  :config
  (general-create-definer fls/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (fls/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))


;; set up Hydra
(use-package hydra)

;; use j and k to zoom in and out when using hydra-text-scale
(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(fls/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))


(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/.code")
    (setq projectile-project-search-path '("~/.code")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; For reference: evil-magit has been delisted from MELPA because it has been merged into
;; evil-collection
;;(use-package evil-magit
;;  :after magit)

;; NOTE: Make sure to configure a GitHub token before using this package!
;; - https://magit.vc/manual/forge/Token-Creation.html#Token-Creation
;; - https://magit.vc/manual/ghub/Getting-Started.html#Getting-Started
(use-package forge)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(doom-gruvbox))
 '(custom-safe-themes
   '("c4063322b5011829f7fdd7509979b5823e8eea2abf1fe5572ec4b7af1dd78519" default))
 '(delete-selection-mode t)
 '(helm-minibuffer-history-key "M-p")
 '(package-selected-packages
   '(forge evil-magit magit counsel-projectile projectile hydra general all-the-icons doom-themes helpful counsel ivy-rich which-key rainbow-delimiters doom-modeline ivy command-log-mode use-package lsp-mode dash ag xref-js2 js2-refactor js2-mode helm))
 '(winner-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
