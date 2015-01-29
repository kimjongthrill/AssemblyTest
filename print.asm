.386 
.model flat,stdcall 
option casemap:none 
include \masm32\include\windows.inc 
include \masm32\include\user32.inc           
include \masm32\include\kernel32.inc
include \masm32\include\gdi32.inc 
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\gdi32.lib

WinMain proto :DWORD,:DWORD,:DWORD,:DWORD       ;main prototype

.DATA                     
ClassName db "Learn",0         
AppName db "Window",0
Text db "Friends, Romans, countrymen, lend me your ears I come to bury Caesar, not to praise him. The evil that men do lives after them",0        

.DATA?                ; Uninitialized data 
hInstance HINSTANCE ?         ; Instance Handle of Window DWORDsz
CommandLine LPSTR ?           ; Cmd Line DWORDsz

.CODE                
start: 
invoke GetModuleHandle, NULL            ; get the instance handle (NULL parameter) 
mov hInstance,eax                               ; GMH stored in eax
invoke GetCommandLine                        ; get the command line.  
mov CommandLine,eax 
invoke WinMain, hInstance,NULL,CommandLine, SW_SHOWDEFAULT        ; call the main function (WinMain proc)
invoke ExitProcess, eax                           ; quit window. The exit code is returned in eax from WinMain.

WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD 
    LOCAL wc:WNDCLASSEX                                            ; local vars must follow immediately after Proc 
    LOCAL msg:MSG                                                  ; name of var:type
    LOCAL hwnd:HWND

    mov   wc.cbSize,SIZEOF WNDCLASSEX                   ; makes the sizr of cbsize cbsize
    mov   wc.style, CS_HREDRAW or CS_VREDRAW           ; allows resize of window
    mov   wc.lpfnWndProc, OFFSET WndProc                            ;sets lpfn point to window
    mov   wc.cbClsExtra,NULL 
    mov   wc.cbWndExtra,NULL 
    push  hInstance 
    pop   wc.hInstance 
    mov   wc.hbrBackground,COLOR_WINDOW+1               ;black background
    mov   wc.lpszMenuName,NULL                          ;no menu name
    mov   wc.lpszClassName,OFFSET ClassName             ;set classname of window
    invoke LoadIcon,NULL,IDI_QUESTION                   ;Null use default icons questionsmark
    mov   wc.hIcon,eax 
    mov   wc.hIconSm,eax 
    invoke LoadCursor,NULL,IDC_CROSS
    mov   wc.hCursor,eax 
    invoke RegisterClassEx, addr wc                       ; register our window class 
    invoke CreateWindowEx,NULL,\ 
                ADDR ClassName,\ 
                ADDR AppName,\ 
                WS_OVERLAPPEDWINDOW,\                   
                CW_USEDEFAULT,\                         ;XY
                CW_USEDEFAULT,\     
                CW_USEDEFAULT,\                         ;sizer
                CW_USEDEFAULT,\ 
                NULL,\ 
                NULL,\ 
                hInst,\                                 ;instance handler
                NULL 
    mov   hwnd,eax                                ;window handler was stored in eax
    invoke ShowWindow, hwnd,SW_SHOWNORMAL               ; display window
    invoke UpdateWindow, hwnd                     ; refresh the client area

    .WHILE TRUE                                                         ; Enter while loop lookin for msg 
                invoke GetMessage, ADDR msg,NULL,0,0 
                .BREAK .IF (!eax) 
                invoke TranslateMessage, ADDR msg                   ;process kb input
                invoke DispatchMessage, ADDR msg                    ;sends input
   .ENDW 
    mov     eax,msg.wParam                                            ; return exit code in eax 
    ret 
WinMain endp

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM 
    LOCAL hdc:HDC
    LOCAL ps:PAINTSTRUCT
    LOCAL rect:RECT
        .IF uMsg==WM_DESTROY                           ; if closing window
        invoke PostQuitMessage,NULL             ; quit application terminates while loop
        .ELSEIF uMsg==WM_PAINT
            invoke BeginPaint,hWnd, ADDR ps
            mov hdc,eax                         ;contains handle of device context
            invoke GetClientRect,hWnd, ADDR rect
            invoke DrawText, hdc, ADDR Text,-1, ADDR rect,\
            DT_CENTER or DT_SINGLELINE or DT_VCENTER
            invoke EndPaint,hWnd, ADDR ps 
        .ELSE
        invoke DefWindowProc,hWnd,uMsg,wParam,lParam     ; Default message processing 
        ret 
    .ENDIF 
    xor eax,eax 
    ret 
WndProc endp
end start
