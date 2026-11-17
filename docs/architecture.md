# Architecture

## Top-level interface

| Signal | Width | Description |
|---|---:|---|
| `A` | 8 | First operand |
| `B` | 8 | Second operand |
| `OP` | 3 | Operation selector |
| `RESULT` | 8 | Operation result |
| `ZERO` | 1 | High when RESULT is zero |
| `CARRY` | 1 | Carry-out, borrow, or shifted-out bit |
| `OVERFLOW` | 1 | Signed two's-complement overflow for ADD/SUB |
| `NEGATIVE` | 1 | Copy of RESULT[7] |

## Operation table

| OP | Operation | Definition |
|---|---|---|
| `000` | Addition | `A + B` |
| `001` | Subtraction | `A - B` |
| `010` | AND | `A & B` |
| `011` | OR | `A | B` |
| `100` | XOR | `A ^ B` |
| `101` | NOT | `~A` |
| `110` | Logical left shift | `A << 1` |
| `111` | Logical right shift | `A >> 1` |

## Flag conventions

- Addition `CARRY` is the unsigned carry-out.
- Subtraction `CARRY` is a borrow indicator (`A < B`), as stated in the project synopsis.
- Shift `CARRY` is the bit shifted out.
- Logical operations clear `CARRY` and `OVERFLOW`.
- `OVERFLOW` is meaningful for signed ADD and SUB.
- `ZERO` and `NEGATIVE` are derived from the final result.

## Datapath overview

A and B feed the arithmetic and bitwise logic. OP selects one of the eight results. The selected result drives RESULT and the status-flag logic. This is a combinational block: it has no clock, reset, or state registers.
