" Vim syntax file
" Language:	ProGuard configuration
" Maintainer:	David Reiss <dreiss@fb.com>
" Version:	2

" Quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

syn region proguardComment start=/#/ end=/$/
syn match proguardDirective "-keep[a-z,]*\>"
syn match proguardDirective "-\(optimizations\|dontwarn\|assumenosideeffects\)\>"
syn match proguardDirective "-\(dontshrink\|dontoptimize\|dontobfuscate\)\>"
syn match proguardWildcard "\*"
syn match proguardMembers "<\(fields\|methods\)>"

syn keyword javaType boolean char byte short int long float double
syn keyword javaType void
syn keyword javaStorageClass static transient final
syn keyword javaScopeDecl public protected private abstract
syn keyword javaClassDecl class enum
syn keyword javaClassDecl extends implements interface
syn match javaClassDecl "@interface\>"
syn match javaAnnotation "@\([_$a-zA-Z][_$a-zA-Z0-9]*\.\)*[_$a-zA-Z][_$a-zA-Z0-9]*\>"

hi def link proguardComment Comment
hi def link proguardDirective Statement
hi def link proguardWildcard Special
hi def link proguardMembers Identifier
hi def link javaStorageClass StorageClass
hi def link javaScopeDecl javaStorageClass
hi def link javaClassDecl javaStorageClass
hi def link javaAnnotation PreProc

let b:current_syntax = "proguard"
