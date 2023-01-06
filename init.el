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
;; ccls - ccls language server
;; ivy - completion plugin not only for code
;; use-package managing packages
;; ivy-xref ivy-like references in lsp
;; undo-tree next generation of undo/redo
;; tree-sitter       -+ Better highlighting
;; tree-sitter-langs -+
(setq package-selected-packages '(lsp-ui tree-sitter-langs tree-sitter undo-tree ivy-xref use-package ivy ccls company which-key flycheck lsp-mode evil doom-themes))

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

;; Enable flycheck and company
(global-company-mode)
(global-flycheck-mode)

;; Turn off flymake
(setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))

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

;; ccls config
(use-package ccls
  :bind ("C-l" . ccls-code-lens-mode))

;; Useful function for ccls
(defun ccls/callee () (interactive) (lsp-ui-peek-find-custom "$ccls/call" '(:callee t)))
(defun ccls/caller () (interactive) (lsp-ui-peek-find-custom "$ccls/call"))
(defun ccls/vars (kind) (lsp-ui-peek-find-custom "$ccls/vars" `(:kind ,kind)))
(defun ccls/base (levels) (lsp-ui-peek-find-custom "$ccls/inheritance" `(:levels ,levels)))
(defun ccls/derived (levels) (lsp-ui-peek-find-custom "$ccls/inheritance" `(:levels ,levels :derived t)))
(defun ccls/member (kind) (interactive) (lsp-ui-peek-find-custom "$ccls/member" `(:kind ,kind)))
	
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
	("g r" . lsp-ui-peek-find-references)  
	("g i" . (lambda () (interactive) (ccls/derived 1)))    ;; get direct derived classes
	("g I" . (lambda () (interactive) (ccls/derived 1000))) ;; get all derived classes
	("g b" . (lambda () (interactive) (ccls/base 1)))       ;; get direct base classes
	("g B" . (lambda () (interactive) (ccls/base 1000)))    ;; get all base classes
	("g f" . (lambda () (interactive) (ccls/member 3)))     ;; => member function / function in namespace
	("g c" . ccls/caller)
	("g C" . ccls/callee))
  :config
  (setq evil-undo-system 'undo-tree))


;; ivy config
(ivy-mode)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(global-set-key (kbd "M-x") 'execute-extended-command)
(global-set-key (kbd "C-x C-f") 'find-file)

(defun my-c-mode-hook ()
  (setq c-basic-offset 4)
  (setq indent-tabs-mode nil)
  (setq c-default-style "stroustrup")
  (setq c++-tab-always-indent t)
  (c-set-offset 'substatement-open 0)
  (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
  (setq tab-width 4)
)

(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c-mode-hook)


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
 '(package-selected-packages '(evil doom-themes)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
