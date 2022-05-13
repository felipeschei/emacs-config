;; set directory to load lisp files
(add-to-list 'load-path "~/.emacs.d/lisp/")

;; set up IDO mode by default
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;; hide toolbar
(if(fboundp 'tool-bar-mode)(tool-bar-mode -1))

;; show line numbers
(global-linum-mode 1)

;; show column number
(column-number-mode 1)

;; highlight current line
(global-hl-line-mode 1)

;; enable auto-indent by default when pressing return
(define-key global-map (kbd "RET") 'newline-and-indent)

;; open emacs maximized by default
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; set tooltip so it only shows in the echo area
(tooltip-mode -1)
(setq tooltip-use-echo-area t)

;;configure package repositories
(setq package-archives
       '(("gnu" . "http://elpa.gnu.org/packages/")
	 ("melpa" . "http://melpa.org/packages/")))

;; rebind M-o to switch to other window
(global-set-key (kbd "M-o") 'other-window)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(adwaita))
 '(delete-selection-mode t)
 '(package-selected-packages '(helm))
 '(winner-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
