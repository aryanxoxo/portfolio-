
/*
r0 = i
r1 = j
r2 = k
r3 = N
r4 = 0 for sum 
r6 = ADDRESS
r7 = MAT A ADDRESS
R8 = MAT B ADDRESS
R9 = MAT C ADDRESS
 */

          .text
          .global          _start
_start: 
    PUSH {R0 - R12, LR}
    MOV  R0, #0      // i
    MOV  R3, #3      // N
COMPARE_i:
    CMP  R0, R3     // CMP i < N
    BLT  FOR1    // 
    B FINISHED

FINISHED: 
    POP {R0 - R12, LR}
    //MOV PC, LR
    B END

END: 
    B END 

FOR1: 
    MOV R1, #0      // j
COMPARE_j: 
    CMP R1, R3      // CMP j < N
    BLT FOR2
    ADD R0, R0, #1  // INCRIMENT i++
    B COMPARE_i

FOR2: 
    MOV R4, #0       // 0 CODE TO INITIALIZE SUM = 0 
    LDR R6, =SUM     // R6 = ADDRESS OF SUM 
    .word 0xED164B00 // FSTD R4, [R6]   SUM = DOUBLE 0 (1110_1101_0001 OR 0000)
    MOV R2, #0       // k 

COMPARE_k:
    CMP R2, R3      // CMP k < N
    BLT COMPUTE_MAT
EXIT: 
    LDR R6, =SUM       // SUM ADDRESS 
    .word 0xED164B00   //FLDD R4, [R6]      // R4 = CONTENT OF SUM

    MUL R12, R0, R3    // R12 = i * N
    ADD R12, R12, R1   // R12 = iN + j
    MOV R12, R12 , LSL #3
    LDR R8, =MAT_C     // R8 = ADDRESS OF ARRAY C 
    ADD R6, R12, R8    // R6 = ADDRESS OF ARRAY C + (iN + j)*8 = C[i,j]

    .word 0xED164B00   // FSTD R4, [R6] (1110_1101_0001 OR 0000)
    ADD R1, R1, #1     // INCRIMENT J++
    B COMPARE_j

COMPUTE_MAT:
    PUSH {R0 - R12, LR}

    LDR R4, =MAT_A 
    LDR R5, =MAT_B

    MUL R12, R0, R3     // i * N 
    ADD R12, R12, R2    // iN + k
    MOV R12, R12, LSL #3
    ADD R6, R12, R4     // R6 = (iN + k)*8 + ADDRESS OF ARRAY A
    .word 0xED167B00    // FLDD R7, [R6]

    MUL R12, R2, R3     //  k * N 
    ADD R12, R12, R1    //  kN + j
    MOV R12, R12, LSL #3
    ADD R6, R12, R5     //  R6 = (kN + j)*8 + ADDRESS OF ARRAY B 
    .word 0xED168B00    //  FLDD R8, [R6]

    LDR R6, =SUM        //  R6 = ADDRESS OF SUM 
    .word 0xED169B00    //  FLDD R9, [R6]       // R9 = VALUE OF SUM    
    .word 0xEE27AB08    //  FMULD R12, R7, R8   //  R12 = A[i][k] * B[k][j]
    .word 0xEE3A9B09    //  FADDD R9, R12, R9   //  R9 = VALUE OF SUM + (A[i][k]*B[k][j])
    .word 0xED169B00    //  FSTD R9, [R6] (1110_1101_0001 OR 0000)

    POP  {R0 - R12, LR}
    ADD R2, R2, #1      // INCRIMENT K++
    B COMPARE_k 

SUM:
 .double 0

MAT_A:
 .double 1.1
 .double 1.2
 .double 1.3
 .double 1.4
 .double 1.5
 .double 1.6
 .double 1.4
 .double 1.5
 .double 1.6

MAT_B:
 .double 2.1
 .double 2.2
 .double 2.3
 .double 2.4
 .double 2.5
 .double 2.6
 .double 1.4
 .double 1.5
 .double 1.6

MAT_C:
 .double 0
 .double 0
 .double 0
 .double 0
 .double 0
 .double 0
 .double 0
 .double 0
 .double 0
