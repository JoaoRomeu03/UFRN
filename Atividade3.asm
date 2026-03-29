# Programa para teste de mapeamento cache
# Objetivo do programa:
# - Alocar espaço para 256 words na memória
# - Preencher este espaço com valores aleatórios entre 0 e 255 (operação de escrita)
# - Exibir em tela (operação de leitura)
# - Incrementar e atualizar cada elemento (operação de escrita)
# - Exibir em tela (operação de leitura)
# - Total de 1024 acessos à memória (512 de leitura + 512 de escrita)

.data

vetor: .space 1024
msg1: .asciiz "\nGerando vetor com 256 elementos!"
msg2: .asciiz "\nExibindo vetor:\n"
novalinha: .asciiz "\n"

.text

main:

la $s0, vetor             # Endereço base do vetor
add $t0, $zero, $zero     # Índice 'i' do vetor
add $t1, $zero, $zero     # Endereço base auxiliar = endereço base + 4*índice [v[j]]

add $a1, $zero, 255       # Valor máximo do gerador de inteiros

addi $t2, $zero, 256      # Valor máximo do laço

addi $v0, $zero, 4        # Exibindo mensagem...
la $a0, msg1
syscall

addi $v0, $zero, 42      # Gravando código da chamada do sistema para gerar número aleatório

loop1: beq $t0, $t2, exit1  # Testa se i < 256
       sll $t1, $t0, 2      # j = 4*i
       add $t1, $t1, $s0    # Encontrando endereço base auxiliar
       
       syscall              # Chamada de sistema para número aleatório
       
       sw $a0, 0($t1)       # Armazenando na memória (ESCRITA)
       
       addi $t0, $t0, 1
       
       j loop1              # Voltando para o laço

exit1:

addi $v0, $zero, 4    # Exibindo mensagem...
la $a0, msg2
syscall

# Exibindo vetor...
add $t0, $zero, $zero     # Índice 'i' do vetor
add $t1, $zero, $zero     # Endereço base auxiliar = endereço base + 4*índice [v[j]]


loop2: beq $t0, $t2, exit2  # Testa se i < 256
       sll $t1, $t0, 2      # j = 4*i
       add $t1, $t1, $s0    # Encontrando endereço base auxiliar
       
       lw $t3, 0($t1)       # Lendo da memória (LEITURA)
              
       addi $v0, $zero, 1   # Gravando código da chamada de sistema para exibir inteiro
       add $a0, $t3, $zero  # Gravando número inteiro para ser exibido no registrador argumento
       syscall
       
       addi $v0, $zero, 11  # Gravando código da chamada de sistema para exibir caractere
       addi $a0, $zero, 32  # Gravando valor do caractere 'espaço' no registrador argumento
       syscall
       
       add $t3, $t3, 1      # Incrementando valor lido da memória
       sw $t3, 0($t1)       # Atualizando valor do vetor na memória (ESCRITA)
       
       addi $t0, $t0, 1
       
       j loop2
exit2:

addi $v0, $zero, 4    # Exibindo mensagem...
la $a0, msg2
syscall

# Exibindo vetor...
add $t0, $zero, $zero     # Índice 'i' do vetor
add $t1, $zero, $zero     # Endereço base auxiliar = endereço base + 4*índice [v[j]]

loop3: beq $t0, $t2, exit3  # Testa se i < 256
       sll $t1, $t0, 2      # j = 4*i
       add $t1, $t1, $s0    # Encontrando endereço base auxiliar
       
       lw $t3, 0($t1)       # Lendo da memória (LEITURA)
              
       addi $v0, $zero, 1   # Gravando código da chamada de sistema para exibir inteiro
       add $a0, $t3, $zero  # Gravando número inteiro para ser exibido no registrador argumento
       syscall
       
       addi $v0, $zero, 11  # Gravando código da chamada de sistema para exibir caractere
       addi $a0, $zero, 32  # Gravando valor do caractere 'espaço' no registrador argumento
       syscall
       
       addi $t0, $t0, 1
       
       j loop3
exit3:

# Exit()
li $v0, 10
syscall