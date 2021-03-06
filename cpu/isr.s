/*  
    This file is part of VK.
    Copyright (C) 2017 Valentin Haudiquet

    VK is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 2.

    VK is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with VK.  If not, see <http://www.gnu.org/licenses/>.
*/

.section .text
.align 4

.extern irq_handler
.macro IRQ index
    .global _irq\index
    _irq\index:
        cli
        push $\index
        call irq_handler
        add $4, %esp # clear index to restore stack
        push %ax # save ax
        mov $0x20, %al
        out %al, $0xA0 # -> tells the SLAVE PIC that interrupt handled
        out %al, $0x20 # -> tells the MASTER PIC that it's OK, we've handled the interrupt, you can send more
        pop %ax # restore ax
        iret
.endm

.macro ISR_NOERR index
    .global _isr\index
    _isr\index:
        cli
        push $0
        push $\index
        jmp isr_common
.endm

.macro ISR_ERR index
    .global _isr\index
    _isr\index:
        cli
        push $\index
        jmp isr_common
.endm

ISR_NOERR 0
ISR_NOERR 1
ISR_NOERR 2
ISR_NOERR 3
ISR_NOERR 4
ISR_NOERR 5
ISR_NOERR 6
ISR_NOERR 7
ISR_ERR   8
ISR_NOERR 9
ISR_ERR   10
ISR_ERR   11
ISR_ERR   12
ISR_ERR   13
ISR_ERR   14
ISR_NOERR 15
ISR_NOERR 16
ISR_NOERR 17
ISR_NOERR 18
ISR_NOERR 19
ISR_NOERR 20
ISR_NOERR 21
ISR_NOERR 22
ISR_NOERR 23
ISR_NOERR 24
ISR_NOERR 25
ISR_NOERR 26
ISR_NOERR 27
ISR_NOERR 28
ISR_NOERR 29
ISR_NOERR 30
ISR_NOERR 31

IRQ 1
IRQ 2
IRQ 3
IRQ 4
IRQ 5
IRQ 6
IRQ 7
IRQ 8
IRQ 9
IRQ 10
IRQ 11
IRQ 12
IRQ 13
IRQ 14
IRQ 15
IRQ 16
IRQ 17
IRQ 18
IRQ 19
IRQ 20

.extern fault_handler
.type fault_handler, @function

isr_common:
    /* Push all registers */
    pusha

    /* Save segment registers */
    push %ds
    push %es
    push %fs
    push %gs
    mov $0x10, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    cld

    /* Call fault handler */
    push %esp
    call fault_handler
    add $4, %esp

    /* Restore segment registers */
    pop %gs
    pop %fs
    pop %es
    pop %ds

    /* Restore registers */
    popa
    /* Cleanup error code and ISR # */
    add $8, %esp
    /* pop CS, EIP, EFLAGS, SS and ESP */
    iret

.global SYSCALL_H
.extern system_calls
SYSCALL_H:
    push %ds
    push %es
    push %fs
    push %gs
    push %esi
    push %edi
    push %ebp
    pushl %edx
    pushl %ecx
    pushl %ebx

    push %ebx
    movl $system_calls, %ebx
    leal (%ebx, %eax, 4), %eax
    mov (%eax), %eax
    pop %ebx

    call *%eax
    add $0xC, %esp

    pop %ebp
    pop %edi
    pop %esi
    pop %gs
    pop %fs
    pop %es
    pop %ds
    # popa
    iret
