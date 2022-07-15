name "superficie"

DATOS SEGMENT
;DECLARAR VARIABLES ---------------------
temp db ?
condicion db ?     
x dw 2
cadena1 db 42,?,42 dup (?) 
cadena2 db 42,?,42 dup (?)
salto db 10,13, "$"       
respuesta db ?
msg1 db 10,13, "ES ANAGRAMA$" 
msg2 db 10,13, "Primera cadena: $"
msg3 db 10,13, "Segunda cadena: $" 
msg4 db 10,13, "NO ES ANAGRAMA$"
msg5 db 10,13, "QUIERES INTENTARLO DE NUEVO S/N$"
 

;----------------------
DATOS ENDS
PILA SEGMENT
    DB 64 DUP(0)
PILA ENDS
CODIGO SEGMENT
INICIO PROC FAR ;NEAR Y FAR
ASSUME DS:DATOS, CS:CODIGO, SS:PILA
PUSH DS
MOV AX,0
PUSH AX

MOV AX,DATOS
MOV DS,AX
MOV ES,AX
mov cx, 0h
;CODIGO DEL PROGRAMA--------------- 
;sacar los 20, 24 y los 00
reproces:
call saltoL 
     
;agregamos contenido en la cadena 1
mov ah, 09h
lea dx, msg2
int 21h
mov ah, 0ah
mov dx, offset cadena1
int 21h   
mov al, cadena1[1] 
add al, 2 
mov ah, 0
mov di, ax
mov cadena1[di], 24h
call saltoL 

;agregamos contenido en la cadena 2
mov ah, 09h
lea dx, msg3
int 21h
mov ah, 0ah
mov dx, offset cadena2
int 21h   
mov al, cadena2[1] 
add al, 2 
mov ah, 0
mov di, ax
mov cadena2[di], 24h
call saltoL

;modificando los registros iniciales
mov si, 2
mov di, 0

;metemos a cadena 2 en la pila
proceso1:
mov condicion, 0
cmp cadena2[si],24h
je proceso2
mov ah, 0
mov al, cadena2[si]
push ax            
cmp al, 30h
jg mayor
retmayor:
cmp al, 39h
jl menor
retmenor:

cmp condicion, 2
je noes

inc si
inc di
loop proceso1

mayor:
add condicion, 1
jmp retmayor
menor:         
add condicion, 1
jmp retmenor


proceso2:
pop ax
mov si, 2
mov temp, 0
rrecorrerp2:
mov bl, cadena1[si]
cmp al,bl
je rp2r
returnrp2r:
cmp cadena1[si],24h  
je verinterna       
inc si
jne rrecorrerp2

verinterna:
mov cl,temp
cmp cl,0
je noes  

cmp di, 1
je verificar
dec di
loop proceso2



rp2r:
mov temp, 1
mov cadena1[si], 20h
jmp returnrp2r


verificar:
mov si, 2
loopverificar:    
cmp cadena1[si], 24h
je  sies
cmp cadena1[si], 20h
jne noes 
inc si
loop loopverificar


sies:
mov ah, 09h
lea dx, msg1
int 21h
call saltoL
jmp repetir

noes:
mov ah, 09h
lea dx, msg4
int 21h
call saltoL
jmp repetir

repetir:
mov ah, 09h
lea dx, msg5
int 21h

MOV AH, 01H
INT 21H
cmp al, 53h
je reproces
cmp al, 73h
je reproces
jmp exit

 


;hacemos un salto de linea       
saltoL proc
mov ah, 09h
lea dx, salto
int 21h
ret
endp

;convertimos los numeros para imprimir
convertir proc           
mov cx, 0
mov bl, 10           
div bl              
mov dh, ah           
mov dl, al         
mov ah, 00h          
mov al, dh           
push ax              
mov ax, 0000h        
mov al, dl           
add cx, 1            
cmp dl, 0            
jne convertir        
je mostrar
ret
endp

;mostramos los numeros
mostrar proc             
sub cx, 1            
pop ax               
mov ah, 02h          
mov dl, al           
add dl, 30h          
int 21h              
cmp cx, 0            
jne mostrar
ret
endp          

;---------------
exit:
CODIGO ENDS

END INICIO