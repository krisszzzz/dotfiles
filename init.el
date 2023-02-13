(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")))

(add-to-list 'package-archives '("elpa" . "https://elpa.gnu.org/packages/"))

(package-initialize)
(unless package-archive-contents
    (package-refresh-contents))
;; Download packages
;; which-key - show keys in emacs
;; flycheck - syntax checker
;; evil - vim integration in emacs
;; doom-themes - cool themes for emacs
;; company - completion plugin
;; ivy - completion plugin not only for code
;; use-package managing packages
;; ivy-xref ivy-like references in lsp
;; undo-tree next generation of undo/redo
;; tree-sitter       -+ Better highlighting
;; tree-sitter-langs -+
;; graphviz-dot-mode - convinient graphviz preview 

(setq package-selected-packages '(lsp-ui tree-sitter-langs tree-sitter undo-tree
					 ivy-xref use-package helm ivy company
					 which-key flycheck lsp-mode evil doom-themes
					 graphviz-dot-mode uncrustify-mode))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
 (mapc #' package-install package-selected-packages))

;; load theme
(load-theme 'doom-monokai-classic t)
;; Turn off menu and tool bar
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
;; which-key enable
(use-package which-key
  :config (which-key-mode 1))


;; Enable helm
(helm-mode 1)

;; Enable flycheck and company
(global-company-mode)
(global-flycheck-mode)

;; Lsp config
(use-package lsp-mode
  :hook (((c-mode c++-mode) . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :config
  (setq lsp-enable-on-type-formatting nil)
  :commands lsp)


(setq gc-cons-threshold (* 1000 1024 1024)
      read-process-output-max (* 100 1024 1024)
      company-idle-delay 0.0
      lsp-idle-delay 0.500)


;;(use-package cc-mode);; Enable undo-tree
(use-package undo-tree
  :config
  (global-undo-tree-mode)
  (setq undo-tree-auto-save-history t)
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo/"))))

;; Enable evil
(use-package evil
  :init
  (evil-mode 1)
   :bind (:map evil-normal-state-map
  	("g r" . lsp-ui-peek-find-references))
  :config
  (setq evil-undo-system 'undo-tree))

;; graphviz-dot-mode
(use-package graphviz-dot-mode
  :ensure t
  :config
  (setq graphviz-dot-indent-width 4))

;; ivy config
(ivy-mode)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(global-set-key (kbd "M-x") 'execute-extended-command)
(global-set-key (kbd "C-x C-f") 'find-file)

(defun my-c-mode ()
  (setq c-basic-offset 4
	c-default-style "linux")
  (c-set-offset 'arglist-intro '+)
)

;; c/c++ code style config
(use-package cc-mode
  :init
  :hook ((c-mode c++-mode) . my-c-mode)
)

(use-package uncrustify-mode
  :hook ((c-mode c++-mode) . uncrustify-mode)
)

;; global config

;; (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(setq backup-directory-alist '((".*" . "~/.emacs.d/autosaves/")))
(setq auto-save-file-name-transforms `((".*" "~/.emacs.d/autosaves/" t)))
(make-directory "~/.emacs.d/autosaves/" t)

(setq create-lockfiles nil)



;; ivy-xref config
(use-package ivy-xref
  :ensure t
  :init
  ;; xref initialization is different in Emacs 27 - there are two different
  ;; variables which can be set rather than just one
  (when (>= emacs-major-version 27)
    (setq xref-show-definitions-function #'ivy-xref-show-defs))
  ;; Necessary in Emacs <27. In Emacs 27 it will affect all xref-based
  ;; commands other than xref-find-definitions (e.g. project-find-regexp)
  ;; as well
  (setq xref-show-xrefs-function #'ivy-xref-show-xrefs))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(graphviz-dot-preview-extension "jpg")
 '(package-selected-packages '(evil doom-themes)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
