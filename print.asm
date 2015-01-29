.386
.model flat,stdcall
option casemap:none
include \masm32\include\windoes.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

WinMain proto :dword,:DWORD,:dword,:dword

.DATA
Classname db "Learn",0
AppName db "Window",0
Text db "Friends, Romans, countrymen, lend me your ears
