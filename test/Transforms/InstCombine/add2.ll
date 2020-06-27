; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define i64 @test1(i64 %A, i32 %B) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[TMP6:%.*]] = and i64 [[A:%.*]], 123
; CHECK-NEXT:    ret i64 [[TMP6]]
;
  %tmp12 = zext i32 %B to i64
  %tmp3 = shl i64 %tmp12, 32
  %tmp5 = add i64 %tmp3, %A
  %tmp6 = and i64 %tmp5, 123
  ret i64 %tmp6
}

define i32 @test2(i32 %A) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[F:%.*]] = and i32 [[A:%.*]], 39
; CHECK-NEXT:    ret i32 [[F]]
;
  %B = and i32 %A, 7
  %C = and i32 %A, 32
  %F = add i32 %B, %C
  ret i32 %F
}

define i32 @test3(i32 %A) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[B:%.*]] = and i32 [[A:%.*]], 128
; CHECK-NEXT:    [[C:%.*]] = lshr i32 [[A]], 30
; CHECK-NEXT:    [[F:%.*]] = or i32 [[B]], [[C]]
; CHECK-NEXT:    ret i32 [[F]]
;
  %B = and i32 %A, 128
  %C = lshr i32 %A, 30
  %F = add i32 %B, %C
  ret i32 %F
}

define i32 @test4(i32 %A) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[B:%.*]] = shl nuw i32 [[A:%.*]], 1
; CHECK-NEXT:    ret i32 [[B]]
;
  %B = add nuw i32 %A, %A
  ret i32 %B
}

define <2 x i1> @test5(<2 x i1> %A, <2 x i1> %B) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[ADD:%.*]] = xor <2 x i1> [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    ret <2 x i1> [[ADD]]
;
  %add = add <2 x i1> %A, %B
  ret <2 x i1> %add
}

define <2 x i64> @test6(<2 x i64> %A) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[ADD:%.*]] = mul <2 x i64> [[A:%.*]], <i64 5, i64 9>
; CHECK-NEXT:    ret <2 x i64> [[ADD]]
;
  %shl = shl <2 x i64> %A, <i64 2, i64 3>
  %add = add <2 x i64> %shl, %A
  ret <2 x i64> %add
}

define <2 x i64> @test7(<2 x i64> %A) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[ADD:%.*]] = mul <2 x i64> [[A:%.*]], <i64 7, i64 12>
; CHECK-NEXT:    ret <2 x i64> [[ADD]]
;
  %shl = shl <2 x i64> %A, <i64 2, i64 3>
  %mul = mul <2 x i64> %A, <i64 3, i64 4>
  %add = add <2 x i64> %shl, %mul
  ret <2 x i64> %add
}

define i16 @test9(i16 %a) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    [[D:%.*]] = mul i16 [[A:%.*]], -32767
; CHECK-NEXT:    ret i16 [[D]]
;
  %b = mul i16 %a, 2
  %c = mul i16 %a, 32767
  %d = add i16 %b, %c
  ret i16 %d
}

; y + (~((x >> 3) & 0x55555555) + 1) -> y - ((x >> 3) & 0x55555555)
define i32 @test10(i32 %x, i32 %y) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    [[SHR:%.*]] = ashr i32 [[X:%.*]], 3
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[SHR]], 1431655765
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[Y:%.*]], [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB]]
;
  %shr = ashr i32 %x, 3
  %shr.not = or i32 %shr, -1431655766
  %neg = xor i32 %shr.not, 1431655765
  %add = add i32 %y, 1
  %add1 = add i32 %add, %neg
  ret i32 %add1
}

; y + (~(x & 0x55555555) + 1) -> y - (x & 0x55555555)
define i32 @test11(i32 %x, i32 %y) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[X:%.*]], 1431655765
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[Y:%.*]], [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB]]
;
  %x.not = or i32 %x, -1431655766
  %neg = xor i32 %x.not, 1431655765
  %add = add i32 %y, 1
  %add1 = add i32 %add, %neg
  ret i32 %add1
}

; (y + 1) + ~(x & 0x55555555) -> y - (x & 0x55555555)
define i32 @test12(i32 %x, i32 %y) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[X:%.*]], 1431655765
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[Y:%.*]], [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB]]
;
  %add = add nsw i32 %y, 1
  %x.not = or i32 %x, -1431655766
  %neg = xor i32 %x.not, 1431655765
  %add1 = add nsw i32 %add, %neg
  ret i32 %add1
}

; y + (~(x & 0x55555556) + 1) -> y - (x & 0x55555556)
define i32 @test13(i32 %x, i32 %y) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[X:%.*]], 1431655766
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[Y:%.*]], [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB]]
;
  %x.not = or i32 %x, -1431655767
  %neg = xor i32 %x.not, 1431655766
  %add = add i32 %y, 1
  %add1 = add i32 %add, %neg
  ret i32 %add1
}

; (y + 1) + ~(x & 0x55555556) -> y - (x & 0x55555556)
define i32 @test14(i32 %x, i32 %y) {
; CHECK-LABEL: @test14(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[X:%.*]], 1431655766
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[Y:%.*]], [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB]]
;
  %add = add nsw i32 %y, 1
  %x.not = or i32 %x, -1431655767
  %neg = xor i32 %x.not, 1431655766
  %add1 = add nsw i32 %add, %neg
  ret i32 %add1
}

; y + (~(x | 0x55555556) + 1) -> y - (x | 0x55555556)
define i32 @test15(i32 %x, i32 %y) {
; CHECK-LABEL: @test15(
; CHECK-NEXT:    [[TMP1:%.*]] = or i32 [[X:%.*]], 1431655766
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[Y:%.*]], [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB]]
;
  %x.not = and i32 %x, -1431655767
  %neg = xor i32 %x.not, -1431655767
  %add = add i32 %y, 1
  %add1 = add i32 %add, %neg
  ret i32 %add1
}

; (y + 1) + ~(x | 0x55555556) -> y - (x | 0x555555556)
define i32 @test16(i32 %x, i32 %y) {
; CHECK-LABEL: @test16(
; CHECK-NEXT:    [[TMP1:%.*]] = or i32 [[X:%.*]], 1431655766
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[Y:%.*]], [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB]]
;
  %add = add nsw i32 %y, 1
  %x.not = and i32 %x, -1431655767
  %neg = xor i32 %x.not, -1431655767
  %add1 = add nsw i32 %add, %neg
  ret i32 %add1
}

; y + (~(x | 0x55555555) + 1) -> y - (x | 0x55555555)
define i32 @test17(i32 %x, i32 %y) {
; CHECK-LABEL: @test17(
; CHECK-NEXT:    [[TMP1:%.*]] = or i32 [[X:%.*]], 1431655765
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[Y:%.*]], [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB]]
;
  %x.not = and i32 %x, -1431655766
  %add2 = xor i32 %x.not, -1431655765
  %add1 = add nsw i32 %add2, %y
  ret i32 %add1
}

; (y + 1) + ~(x | 0x55555555) -> y - (x | 0x55555555)
define i32 @test18(i32 %x, i32 %y) {
; CHECK-LABEL: @test18(
; CHECK-NEXT:    [[TMP1:%.*]] = or i32 [[X:%.*]], 1431655765
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[Y:%.*]], [[TMP1]]
; CHECK-NEXT:    ret i32 [[SUB]]
;
  %add = add nsw i32 %y, 1
  %x.not = and i32 %x, -1431655766
  %neg = xor i32 %x.not, -1431655766
  %add1 = add nsw i32 %add, %neg
  ret i32 %add1
}

define i16 @add_nsw_mul_nsw(i16 %x) {
; CHECK-LABEL: @add_nsw_mul_nsw(
; CHECK-NEXT:    [[ADD2:%.*]] = mul nsw i16 [[X:%.*]], 3
; CHECK-NEXT:    ret i16 [[ADD2]]
;
  %add1 = add nsw i16 %x, %x
  %add2 = add nsw i16 %add1, %x
  ret i16 %add2
}

define i16 @mul_add_to_mul_1(i16 %x) {
; CHECK-LABEL: @mul_add_to_mul_1(
; CHECK-NEXT:    [[ADD2:%.*]] = mul nsw i16 [[X:%.*]], 9
; CHECK-NEXT:    ret i16 [[ADD2]]
;
  %mul1 = mul nsw i16 %x, 8
  %add2 = add nsw i16 %x, %mul1
  ret i16 %add2
}

define i16 @mul_add_to_mul_2(i16 %x) {
; CHECK-LABEL: @mul_add_to_mul_2(
; CHECK-NEXT:    [[ADD2:%.*]] = mul nsw i16 [[X:%.*]], 9
; CHECK-NEXT:    ret i16 [[ADD2]]
;
  %mul1 = mul nsw i16 %x, 8
  %add2 = add nsw i16 %mul1, %x
  ret i16 %add2
}

define i16 @mul_add_to_mul_3(i16 %a) {
; CHECK-LABEL: @mul_add_to_mul_3(
; CHECK-NEXT:    [[ADD:%.*]] = mul i16 [[A:%.*]], 5
; CHECK-NEXT:    ret i16 [[ADD]]
;
  %mul1 = mul i16 %a, 2
  %mul2 = mul i16 %a, 3
  %add = add nsw i16 %mul1, %mul2
  ret i16 %add
}

define i16 @mul_add_to_mul_4(i16 %a) {
; CHECK-LABEL: @mul_add_to_mul_4(
; CHECK-NEXT:    [[ADD:%.*]] = mul nsw i16 [[A:%.*]], 9
; CHECK-NEXT:    ret i16 [[ADD]]
;
  %mul1 = mul nsw i16 %a, 2
  %mul2 = mul nsw i16 %a, 7
  %add = add nsw i16 %mul1, %mul2
  ret i16 %add
}

define i16 @mul_add_to_mul_5(i16 %a) {
; CHECK-LABEL: @mul_add_to_mul_5(
; CHECK-NEXT:    [[ADD:%.*]] = mul nsw i16 [[A:%.*]], 10
; CHECK-NEXT:    ret i16 [[ADD]]
;
  %mul1 = mul nsw i16 %a, 3
  %mul2 = mul nsw i16 %a, 7
  %add = add nsw i16 %mul1, %mul2
  ret i16 %add
}

define i32 @mul_add_to_mul_6(i32 %x, i32 %y) {
; CHECK-LABEL: @mul_add_to_mul_6(
; CHECK-NEXT:    [[MUL1:%.*]] = mul nsw i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[ADD:%.*]] = mul nsw i32 [[MUL1]], 6
; CHECK-NEXT:    ret i32 [[ADD]]
;
  %mul1 = mul nsw i32 %x, %y
  %mul2 = mul nsw i32 %mul1, 5
  %add = add nsw i32 %mul1, %mul2
  ret i32 %add
}

define i16 @mul_add_to_mul_7(i16 %x) {
; CHECK-LABEL: @mul_add_to_mul_7(
; CHECK-NEXT:    [[ADD2:%.*]] = shl i16 [[X:%.*]], 15
; CHECK-NEXT:    ret i16 [[ADD2]]
;
  %mul1 = mul nsw i16 %x, 32767
  %add2 = add nsw i16 %x, %mul1
  ret i16 %add2
}

define i16 @mul_add_to_mul_8(i16 %a) {
; CHECK-LABEL: @mul_add_to_mul_8(
; CHECK-NEXT:    [[ADD:%.*]] = mul nsw i16 [[A:%.*]], 32767
; CHECK-NEXT:    ret i16 [[ADD]]
;
  %mul1 = mul nsw i16 %a, 16383
  %mul2 = mul nsw i16 %a, 16384
  %add = add nsw i16 %mul1, %mul2
  ret i16 %add
}

define i16 @mul_add_to_mul_9(i16 %a) {
; CHECK-LABEL: @mul_add_to_mul_9(
; CHECK-NEXT:    [[ADD:%.*]] = shl i16 [[A:%.*]], 15
; CHECK-NEXT:    ret i16 [[ADD]]
;
  %mul1 = mul nsw i16 %a, 16384
  %mul2 = mul nsw i16 %a, 16384
  %add = add nsw i16 %mul1, %mul2
  ret i16 %add
}

; This test and the next test verify that when a range metadata is attached to
; llvm.cttz, ValueTracking correctly intersects the range specified by the
; metadata and the range implied by the intrinsic.
;
; In this test, the range specified by the metadata is more strict. Therefore,
; ValueTracking uses that range.
define i16 @add_cttz(i16 %a) {
; CHECK-LABEL: @add_cttz(
; CHECK-NEXT:    [[CTTZ:%.*]] = call i16 @llvm.cttz.i16(i16 [[A:%.*]], i1 true), !range !0
; CHECK-NEXT:    [[B:%.*]] = or i16 [[CTTZ]], -8
; CHECK-NEXT:    ret i16 [[B]]
;
  ; llvm.cttz.i16(..., /*is_zero_undefined=*/true) implies the value returned
  ; is in [0, 16). The range metadata indicates the value returned is in [0, 8).
  ; Intersecting these ranges, we know the value returned is in [0, 8).
  ; Therefore, InstCombine will transform
  ;     add %cttz, 1111 1111 1111 1000 ; decimal -8
  ; to
  ;     or  %cttz, 1111 1111 1111 1000
  %cttz = call i16 @llvm.cttz.i16(i16 %a, i1 true), !range !0
  %b = add i16 %cttz, -8
  ret i16 %b
}
declare i16 @llvm.cttz.i16(i16, i1)
!0 = !{i16 0, i16 8}

; Similar to @add_cttz, but in this test, the range implied by the
; intrinsic is more strict. Therefore, ValueTracking uses that range.
define i16 @add_cttz_2(i16 %a) {
; CHECK-LABEL: @add_cttz_2(
; CHECK-NEXT:    [[CTTZ:%.*]] = call i16 @llvm.cttz.i16(i16 [[A:%.*]], i1 true), !range !1
; CHECK-NEXT:    [[B:%.*]] = or i16 [[CTTZ]], -16
; CHECK-NEXT:    ret i16 [[B]]
;
  ; llvm.cttz.i16(..., /*is_zero_undefined=*/true) implies the value returned
  ; is in [0, 16). The range metadata indicates the value returned is in
  ; [0, 32). Intersecting these ranges, we know the value returned is in
  ; [0, 16). Therefore, InstCombine will transform
  ;     add %cttz, 1111 1111 1111 0000 ; decimal -16
  ; to
  ;     or  %cttz, 1111 1111 1111 0000
  %cttz = call i16 @llvm.cttz.i16(i16 %a, i1 true), !range !1
  %b = add i16 %cttz, -16
  ret i16 %b
}
!1 = !{i16 0, i16 32}

define i32 @add_or_and(i32 %x, i32 %y) {
; CHECK-LABEL: @add_or_and(
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
  %or = or i32 %x, %y
  %and = and i32 %x, %y
  %add = add i32 %or, %and
  ret i32 %add
}

define i32 @add_or_and_commutative(i32 %x, i32 %y) {
; CHECK-LABEL: @add_or_and_commutative(
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
  %or = or i32 %x, %y
  %and = and i32 %y, %x ; swapped
  %add = add i32 %or, %and
  ret i32 %add
}

define i32 @add_and_or(i32 %x, i32 %y) {
; CHECK-LABEL: @add_and_or(
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
  %or = or i32 %x, %y
  %and = and i32 %x, %y
  %add = add i32 %and, %or
  ret i32 %add
}

define i32 @add_and_or_commutative(i32 %x, i32 %y) {
; CHECK-LABEL: @add_and_or_commutative(
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
  %or = or i32 %x, %y
  %and = and i32 %y, %x ; swapped
  %add = add i32 %and, %or
  ret i32 %add
}

define i32 @add_nsw_or_and(i32 %x, i32 %y) {
; CHECK-LABEL: @add_nsw_or_and(
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
  %or = or i32 %x, %y
  %and = and i32 %x, %y
  %add = add nsw i32 %or, %and
  ret i32 %add
}

define i32 @add_nuw_or_and(i32 %x, i32 %y) {
; CHECK-LABEL: @add_nuw_or_and(
; CHECK-NEXT:    [[ADD:%.*]] = add nuw i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
  %or = or i32 %x, %y
  %and = and i32 %x, %y
  %add = add nuw i32 %or, %and
  ret i32 %add
}

define i32 @add_nuw_nsw_or_and(i32 %x, i32 %y) {
; CHECK-LABEL: @add_nuw_nsw_or_and(
; CHECK-NEXT:    [[ADD:%.*]] = add nuw nsw i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
  %or = or i32 %x, %y
  %and = and i32 %x, %y
  %add = add nsw nuw i32 %or, %and
  ret i32 %add
}

; A *nsw B + A *nsw C != A *nsw (B + C)
; e.g. A = -1, B = 1, C = INT_SMAX

define i8 @add_of_mul(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @add_of_mul(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[MB1:%.*]] = add i8 [[Y:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[SUM:%.*]] = mul i8 [[MB1]], [[X:%.*]]
; CHECK-NEXT:    ret i8 [[SUM]]
;
  entry:
  %mA = mul nsw i8 %x, %y
  %mB = mul nsw i8 %x, %z
  %sum = add nsw i8 %mA, %mB
  ret i8 %sum
}

define i32 @add_of_selects(i1 %A, i32 %B) {
; CHECK-LABEL: @add_of_selects(
; CHECK-NEXT:    [[ADD:%.*]] = select i1 [[A:%.*]], i32 [[B:%.*]], i32 0
; CHECK-NEXT:    ret i32 [[ADD]]
;
  %sel0 = select i1 %A, i32 0, i32 -2
  %sel1 = select i1 %A, i32 %B, i32 2
  %add = add i32 %sel0, %sel1
  ret i32 %add
}
