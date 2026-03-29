.data
msg:    .asciiz " "           # Mensagem de espaço
array:  .space 40             # Alocar espaço para 10 inteiros (10 * 4 bytes)
.align 2                     # Alinhar a memória para 4 bytes

.text

main:
    addi $t1, $zero, 10       # $t1 = 10 (limite do loop)
    add $t2, $zero, $zero     # $t2 = 0 (contador)
    la $t3, array             # Carregar o endereço base do array em $t3

loop: beq $t2, $t1, exit # Se $t2 == 10, sair do loop

    # Geração de um número aleatório usando syscall 42
    add $a0, $zero, $zero
    addi $a1, $zero, 255      # Limite superior para número aleatório
    addi $v0, $zero, 42       # Syscall para gerar número aleatório
    syscall
    
    addi $v0, $zero,1
    syscall

    # Imprimir um espaço
    la $a0, msg
    addi $v0, $zero, 4        # Syscall para print string
    syscall

    # Incrementar o contador e continuar o loop
    addi $t2, $t2, 1
    j loop

exit:


addi $v0, $zero, 10
syscall
