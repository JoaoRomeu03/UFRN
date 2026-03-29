.data
    msg_codificada: .word 0x00051010, 0x116A23B1, 0x21347582, 0x10061231, 0x11642467, 0x008695AB, 0x21CD6EEF, 0x00071323
                    .word 0x11264517, 0x2089A2B0, 0x00E5F601, 0x212360F1, 0x11624533, 0x21676455, 0x00627089, 0x20AB8691
                    .word 0x10A6CDB3, 0x21EF6C5D, 0x10E701F2, 0x00071423, 0x0162F345, 0x21677455, 0x10628971, 0x1082AB90
                    .word 0x10A4CDB6, 0x016C9DEF, 0x21016031, 0x212362F3, 0x01745545, 0x10626770, 0x10868993, 0x21AB6AFB
                    .word 0x00C6DDCD, 0x00E2F0EF, 0x116001E1, 0x0162F323, 0x20454754, 0x00667167, 0x20898290, 0x113AAB1B
                    .word 0x113CCD0D, 0x000211EF
    empty_string: .asciiz ""

.text
    .globl main

main:
    la $t9, msg_codificada #Aponta para o início do vetor de palavras

loop:
    lw $t0, 0($t9) #Carrega a palavra atual
    beq $t0, $zero, end_loop #Sai do loop se a palavra for zero

    #Extrai bytes da palavra
    andi  $t1, $t0, 0xFF000000 #Extração do byte 3
    srl  $t1, $t1, 24          
    andi  $t2, $t0, 0x00FF0000 #Extração do byte 2
    srl  $t2, $t2, 16         
    andi  $t3, $t0, 0x0000FF00 #Extração do byte 1
    srl  $t3, $t3, 8          
    andi  $t4, $t0, 0x000000FF #Extração do byte 0

    # Extrai nibbles do byte mais significativo (byte 3)
    andi $t5, $t1, 0xF0 #Extração do nibble 1     
    srl  $t5, $t5, 4           
    andi $t6, $t1, 0x0F #Extração do nibble 2      

    jal verifica_nibble1byte3
    addi $t9, $t9, 4 #Avança para a próxima palavra
    j loop

end_loop:
    li $v0, 10 #Encerra o programa
    syscall

verifica_nibble1byte3:
    beq $t5, 0, extrai_nibble21
    beq $t5, 1, extrai_nibble20
    beq $t5, 2, extrai_nibble10
    jr $ra

extrai_nibble21: #Verifica o nibble menos significativo do Byte 3
    beq $t6, 0, concatena_nibbles_menos_significativos21
    beq $t6, 1, concatena_nibbles_mais_significativos21
    jr $ra

concatena_nibbles_menos_significativos21:
    andi $t7, $t2, 0x0F
    andi $t8, $t3, 0x0F
    sll $t7, $t7, 4 #Concatena os nibbles
    or $t7, $t7, $t8
    li $v0, 11 #Imprimi o caractere
    move $a0, $t7 
    syscall
    li $v0, 4 #Imprimi uma string vazio
    la $a0, empty_string
    syscall
    jr $ra

concatena_nibbles_mais_significativos21:
    andi $t7, $t2, 0xF0  
    srl $t7, $t7, 4      
    andi $t8, $t3, 0xF0  
    srl $t8, $t8, 4      
    sll $t7, $t7, 4
    or $t7, $t7, $t8
    li $v0, 11
    move $a0, $t7
    syscall
    li $v0, 4
    la $a0, empty_string
    syscall
    jr $ra

extrai_nibble20:
    beq $t6, 0, concatena_nibbles_menos_significativos20
    beq $t6, 1, concatena_nibbles_mais_significativos20
    jr $ra

concatena_nibbles_menos_significativos20:
    andi $t7, $t2, 0x0F
    andi $t8, $t4, 0x0F
    sll $t7, $t7, 4
    or $t7, $t7, $t8
    li $v0, 11
    move $a0, $t7
    syscall
    li $v0, 4
    la $a0, empty_string
    syscall
    jr $ra

concatena_nibbles_mais_significativos20:
    andi $t7, $t2, 0xF0  
    srl $t7, $t7, 4      
    andi $t8, $t4, 0xF0  
    srl $t8, $t8, 4      
    sll $t7, $t7, 4
    or $t7, $t7, $t8
    li $v0, 11
    move $a0, $t7
    syscall
    li $v0, 4
    la $a0, empty_string
    syscall
    jr $ra

extrai_nibble10:
    beq $t6, 0, concatena_nibbles_menos_significativos10
    beq $t6, 1, concatena_nibbles_mais_significativos10
    jr $ra

concatena_nibbles_menos_significativos10:
    andi $t7, $t3, 0x0F
    andi $t8, $t4, 0x0F
    sll $t7, $t7, 4
    or $t7, $t7, $t8
    li $v0, 11
    move $a0, $t7
    syscall
    li $v0, 4
    la $a0, empty_string
    syscall
    jr $ra

concatena_nibbles_mais_significativos10:
    andi $t7, $t3, 0xF0  
    srl $t7, $t7, 4      
    andi $t8, $t4, 0xF0  
    srl $t8, $t8, 4      
    sll $t7, $t7, 4
    or $t7, $t7, $t8
    li $v0, 11
    move $a0, $t7
    syscall
    li $v0, 4
    la $a0, empty_string
    syscall
    jr $ra
