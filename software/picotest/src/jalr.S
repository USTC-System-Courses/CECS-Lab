# See LICENSE for license details.

#*****************************************************************************
# jalr.S
#-----------------------------------------------------------------------------
#
# Test jalr instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

.option norvc
.global jalr
jalr: 

  #-------------------------------------------------------------
  # Test 2: Basic test
  #-------------------------------------------------------------

test_2:
  li  TESTNUM, 2
  li  x31, 0
  la  x2, target_2

linkaddr_2:
  jalr x19, x2, 0
  nop
  nop

  j fail

target_2:
  la  x31, linkaddr_2
  addi x31, x31, 4
  bne x31, x19, fail

  #-------------------------------------------------------------
  # Test 3: Check r0 target and that r31 is not modified
  #-------------------------------------------------------------

test_3:
  li  TESTNUM, 3
  li  x31, 0
  la  x3, target_3

linkaddr_3:
  jalr x0, x3, 0
  nop

  j fail

target_3:
  bne x31, x0, fail

  #-------------------------------------------------------------
  # Bypassing tests
  #-------------------------------------------------------------

  TEST_JALR_SRC1_BYPASS( 4, 0, jalr );
  TEST_JALR_SRC1_BYPASS( 5, 1, jalr );
  TEST_JALR_SRC1_BYPASS( 6, 2, jalr );

  #-------------------------------------------------------------
  # Test delay slot instructions not executed nor bypassed
  #-------------------------------------------------------------

  TEST_CASE( 7, x31, 4, \
    li  x31, 1; \
    la  x2, 1f;
    jalr x19, x2, -4; \
    addi x31, x31, 1; \
    addi x31, x31, 1; \
    addi x31, x31, 1; \
    addi x31, x31, 1; \
1:  addi x31, x31, 1; \
    addi x31, x31, 1; \
  )

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
