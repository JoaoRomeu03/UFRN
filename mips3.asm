.data
array: .word 7, 3, 9, 5, 2, 8, 4, 6, 1, 0   # Array com 10 elementos para ordenar
msg_unsorted: .asciiz "\nArray desordenado:\n"
msg_sorted:   .asciiz "\nArray ordenado:\n"
space: .asciiz " "

.text
.globl main

main:
    # Exibir o array desordenado
    la $a0, msg_unsorted       # Carregar mensagem "Array desordenado"
    li $v0, 4                  # Syscall para print string
    syscall

    # Imprimir o array original
    la $t0, array              # Carregar o endereço do array em $t0
    li $t1, 10                 # Tamanho do array (10 elementos)
    jal print_array            # Chamar função para imprimir o array

    # Ordenar o array usando Bubble Sort
    la $t0, array              # Carregar o endereço do array
    li $t1, 10                 # Tamanho do array (10 elementos)
    jal bubble_sort            # Chamar função de ordenação

    # Exibir o array ordenado
    la $a0, msg_sorted         # Carregar mensagem "Array ordenado"
    li $v0, 4                  # Syscall para print string
    syscall

    # Imprimir o array ordenado
    la $t0, array              # Carregar o endereço do array
    li $t1, 10                 # Tamanho do array (10 elementos)
    jal print_array            # Chamar função para imprimir o array

    # Finalizar o programa
    li $v0, 10                 # Syscall para encerrar o programa
    syscall

# Função para imprimir o array
print_array:
    move $t2, $zero            # Inicializar o contador em 0

print_loop:
    beq $t2, $t1, print_exit   # Se $t2 == tamanho do array, sair do loop

    lw $a0, 0($t0)             # Carregar o próximo elemento do array em $a0
    li $v0, 1                  # Syscall para print integer
    syscall

    # Imprimir um espaço
    la $a0, space
    li $v0, 4                  # Syscall para print string
    syscall

    addi $t0, $t0, 4           # Avançar para o próximo elemento (4 bytes)
    addi $t2, $t2, 1           # Incrementar o contador
    j print_loop

print_exit:
    jr $ra                     # Retornar da função

# Função Bubble Sort
bubble_sort:
    addi $t3, $t1, -1          # $t3 = tamanho do array - 1

outer_loop:
    addi $t3, $t3, -1          # Decrementar o tamanho do loop externo
    beq $t3, -1, sort_exit     # Se $t3 < 0, terminar o loop

    la $t0, array              # Reiniciar o ponteiro do array
    move $t2, $zero            # Reiniciar o contador interno

inner_loop:
    addi $t4, $t2, 1           # $t4 = $t2 + 1
    beq $t4, $t1, outer_loop   # Se $t4 == tamanho do array, voltar ao outer loop

    lw $a0, 0($t0)             # Carregar array[$t2] em $a0
    lw $a1, 4($t0)             # Carregar array[$t2 + 1] em $a1

    # Comparar array[$t2] e array[$t2 + 1]
    ble $a0, $a1, no_swap      # Se array[$t2] <= array[$t2 + 1], não troque

    # Trocar elementos
    sw $a1, 0($t0)             # array[$t2] = array[$t2 + 1]
    sw $a0, 4($t0)             # array[$t2 + 1] = array[$t2]

no_swap:
    addi $t0, $t0, 4           # Avançar para o próximo elemento (4 bytes)
    addi $t2, $t2, 1           # Incrementar o contador
    j inner_loop

sort_exit:
    jr $ra                     # Retornar da função
