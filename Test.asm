.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

.data
Cap db "Test", 0
Body db "First", 0
.code
start:
    invoke MessageBox, NULL, addr Body, addr Cap, MB_OK 
    invoke ExitProcess, NULL
end start
