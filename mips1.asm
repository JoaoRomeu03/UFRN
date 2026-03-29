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
    
    la $t9, msg_codificada

loop:
    # Carregar a word atual no registrador $t0
    lw $t0, 0($t9)

    # Verificar se chegamos ao final da mensagem
    beq $t0, $zero, end_loop

    # Extração dos bytes
    # Byte 3:
    andi  $t1, $t0, 0xFF000000  
    srl  $t1, $t1, 24          

    # Byte 2:
    andi  $t2, $t0, 0x00FF0000
    srl  $t2, $t2, 16         

    # Byte 1:
    andi  $t3, $t0, 0x0000FF00
    srl  $t3, $t3, 8          

    # Byte 0:
    andi  $t4, $t0, 0x000000FF

    # Extração do nibble 1 do byte 3
    andi $t5, $t1, 0xF0        
    srl  $t5, $t5, 4           

    # Extração do nibble 2 do byte 3
    andi $t6, $t1, 0x0F        

    jal verificar_nible_1_byte_3

    # Avançar para a próxima word
    addi $t9, $t9, 4
    j loop

end_loop:
    # Finalizar o programa
    li $v0, 10
    syscall

verificar_nible_1_byte_3:
    
    beq $t5, 0, extrair_nibble_2_1
    beq $t5, 1, extrair_nibble_2_0
    beq $t5, 2, extrair_nibble_1_0
    jr $ra

extrair_nibble_2_1:
    # Verificar o valor do nibble menos significativo do byte 3
    beq $t6, 0, concatenar_nibbles_menos_significativos_2_1
    beq $t6, 1, concatenar_nibbles_mais_significativos_2_1
    jr $ra

concatenar_nibbles_menos_significativos_2_1:

    andi $t7, $t2, 0x0F
    andi $t8, $t3, 0x0F

    # Concatenar os nibbles
    sll $t7, $t7, 4
    or $t7, $t7, $t8

    li $v0, 11  # Código de syscall para imprimir caractere
    move $a0, $t7  # Valor a ser impresso
    syscall

    # Imprimir string vazia
    li $v0, 4
    la $a0, empty_string
    syscall

    jr $ra

concatenar_nibbles_mais_significativos_2_1:
    
    andi $t7, $t2, 0xF0  
    srl $t7, $t7, 4      
    andi $t8, $t3, 0xF0  
    srl $t8, $t8, 4      

    # Concatenar os nibbles
    sll $t7, $t7, 4
    or $t7, $t7, $t8

    li $v0, 11  # Código de syscall para imprimir caractere
    move $a0, $t7  # Valor a ser impresso
    syscall

    # Imprimir string vazia
    li $v0, 4
    la $a0, empty_string
    syscall

    jr $ra

extrair_nibble_2_0:
    # Verificar o valor do nibble menos significativo do byte 3
    beq $t6, 0, concatenar_nibbles_menos_significativos_2_0
    beq $t6, 1, concatenar_nibbles_mais_significativos_2_0
    jr $ra

concatenar_nibbles_menos_significativos_2_0:

    andi $t7, $t2, 0x0F
    andi $t8, $t4, 0x0F

    # Concatenar os nibbles
    sll $t7, $t7, 4
    or $t7, $t7, $t8

    li $v0, 11  # Código de syscall para imprimir caractere
    move $a0, $t7  # Valor a ser impresso
    syscall

    # Imprimir string vazia
    li $v0, 4
    la $a0, empty_string
    syscall

    jr $ra

concatenar_nibbles_mais_significativos_2_0:
    
    andi $t7, $t2, 0xF0  
    srl $t7, $t7, 4      
    andi $t8, $t4, 0xF0  
    srl $t8, $t8, 4      

    # Concatenar os nibbles
    sll $t7, $t7, 4
    or $t7, $t7, $t8

    li $v0, 11  # Código de syscall para imprimir caractere
    move $a0, $t7  # Valor a ser impresso
    syscall

    # Imprimir string vazia
    li $v0, 4
    la $a0, empty_string
    syscall

    jr $ra

extrair_nibble_1_0:
    # Verificar o valor do nibble menos significativo do byte 3
    beq $t6, 0, concatenar_nibbles_menos_significativos_1_0
    beq $t6, 1, concatenar_nibbles_mais_significativos_1_0
    jr $ra

concatenar_nibbles_menos_significativos_1_0:

    andi $t7, $t3, 0x0F
    andi $t8, $t4, 0x0F

    # Concatenar os nibbles
    sll $t7, $t7, 4
    or $t7, $t7, $t8

    li $v0, 11  # Código de syscall para imprimir caractere
    move $a0, $t7  # Valor a ser impresso
    syscall

    # Imprimir string vazia
    li $v0, 4
    la $a0, empty_string
    syscall

    jr $ra

concatenar_nibbles_mais_significativos_1_0:
    
    andi $t7, $t3, 0xF0  
    srl $t7, $t7, 4      
    andi $t8, $t4, 0xF0  
    srl $t8, $t8, 4      

    # Concatenar os nibbles
    sll $t7, $t7, 4
    or $t7, $t7, $t8

    li $v0, 11  # Código de syscall para imprimir caractere
    move $a0, $t7  # Valor a ser impresso
    syscall

    # Imprimir string vazia
    li $v0, 4
    la $a0, empty_string
    syscall

    jr $ra