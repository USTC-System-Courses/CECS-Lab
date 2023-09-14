# See LICENSE for license details.

#*****************************************************************************
# jal.S
#-----------------------------------------------------------------------------
#
# Test jal instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

.option norvc
.global jal
jal: 

  #-------------------------------------------------------------
  # Test 2: Basic test
  #-------------------------------------------------------------

test_2:
  li  TESTNUM, 2
  li  x31, 0

linkaddr_2:
  jal  x31, target_2
  nop
  nop

  j fail

target_2:
  la  x2, linkaddr_2
  addi x2, x2, 4
  bne x2, x31, fail

  #-------------------------------------------------------------
  # Test delay slot instructions not executed nor bypassed
  #-------------------------------------------------------------

  TEST_CASE( 3, x2, 3, \
    li  x2, 1; \
    jal x31, 1f; \
    addi x2, x2, 1; \
    addi x2, x2, 1; \
    addi x2, x2, 1; \
    addi x2, x2, 1; \
1:  addi x2, x2, 1; \
    addi x2, x2, 1; \
  )

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
