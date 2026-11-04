import numpy as np
import os

# ============================================================
# CONFIGURATION
# ============================================================

# IFM size
IFM_HEIGHT = 4
IFM_WIDTH  = 128

# Number of input channels
# For 2D convolution with one IFM, use 1
IN_CHANNEL = 3

# Number of output channels
OUT_CHANNEL = 16

# Kernel size
KERNEL_SIZE = 3

# Convolution parameters
STRIDE  = 1
PADDING = 0

# Data width
DATA_WIDTH = 16

# Random data range
DATA_MIN = 0
DATA_MAX = 4

# Random seed
SEED = 1234

# Output directory
OUTPUT_DIR = "cnn_2d_data"


# ============================================================
# CALCULATE OFM SIZE
# ============================================================

OFM_HEIGHT = (
    IFM_HEIGHT + 2 * PADDING - KERNEL_SIZE
) // STRIDE + 1

OFM_WIDTH = (
    IFM_WIDTH + 2 * PADDING - KERNEL_SIZE
) // STRIDE + 1


if OFM_HEIGHT <= 0 or OFM_WIDTH <= 0:
    raise ValueError("Invalid IFM / kernel / padding configuration")


# ============================================================
# PRINT CONFIGURATION
# ============================================================

print("=" * 60)
print("2D CNN CONVOLUTION")
print("=" * 60)

print(f"IFM          : {IN_CHANNEL} x {IFM_HEIGHT} x {IFM_WIDTH}")
print(f"Kernel       : {OUT_CHANNEL} x {IN_CHANNEL} "
      f"x {KERNEL_SIZE} x {KERNEL_SIZE}")
print(f"Stride       : {STRIDE}")
print(f"Padding      : {PADDING}")
print(f"OFM          : {OUT_CHANNEL} x {OFM_HEIGHT} x {OFM_WIDTH}")
print(f"DATA_WIDTH   : {DATA_WIDTH}")

print("=" * 60)


# ============================================================
# GENERATE RANDOM DATA
# ============================================================

np.random.seed(SEED)

# IFM
#
# [input_channel][row][column]
#
# Example:
# IN_CHANNEL = 1
#
# IFM[0] =
#   1  2  3  4  5
#   6  7  8  9 10
#   ...

IFM = np.random.randint(
    DATA_MIN,
    DATA_MAX + 1,
    size=(IN_CHANNEL, IFM_HEIGHT, IFM_WIDTH),
    dtype=np.int16
)


# WEIGHT
#
# [output_channel]
# [input_channel]
# [kernel_row]
# [kernel_column]
#
# Example:
#
# Weight[0][0] =
#
#   1  2  3
#   4  5  6
#   7  8  9

WEIGHT = np.random.randint(
    DATA_MIN,
    DATA_MAX + 1,
    size=(
        OUT_CHANNEL,
        IN_CHANNEL,
        KERNEL_SIZE,
        KERNEL_SIZE
    ),
    dtype=np.int16
)


# ============================================================
# PADDING
# ============================================================

if PADDING > 0:

    IFM_PAD = np.pad(
        IFM,
        (
            (0, 0),
            (PADDING, PADDING),
            (PADDING, PADDING)
        ),
        mode="constant",
        constant_values=0
    )

else:

    IFM_PAD = IFM


# ============================================================
# 2D CNN CONVOLUTION
# ============================================================

# Use int32 for accumulation
OFM = np.zeros(
    (
        OUT_CHANNEL,
        OFM_HEIGHT,
        OFM_WIDTH
    ),
    dtype=np.int32
)


for oc in range(OUT_CHANNEL):

    for oh in range(OFM_HEIGHT):

        for ow in range(OFM_WIDTH):

            acc = 0

            for ic in range(IN_CHANNEL):

                for kh in range(KERNEL_SIZE):

                    for kw in range(KERNEL_SIZE):

                        ih = oh * STRIDE + kh
                        iw = ow * STRIDE + kw

                        acc += (
                            int(IFM_PAD[ic, ih, iw])
                            *
                            int(WEIGHT[oc, ic, kh, kw])
                        )

            OFM[oc, oh, ow] = acc


# ============================================================
# CREATE OUTPUT DIRECTORY
# ============================================================

os.makedirs(OUTPUT_DIR, exist_ok=True)


# ============================================================
# SIGNED INTEGER -> BINARY STRING
# ============================================================

def signed_to_binary(value, width):

    value = int(value)

    # Two's complement
    mask = (1 << width) - 1

    value = value & mask

    return format(value, f"0{width}b")


# ============================================================
# WRITE IFM.DEC
# ============================================================
#
# IFM is written row-by-row.
#
# For IN_CHANNEL = 1:
#
# row 0
# row 1
# row 2
# ...
#
# If multiple input channels:
#
# CHANNEL 0
# row 0
# row 1
# ...
#
# CHANNEL 1
# row 0
# ...

ifm_dec_file = os.path.join(
    OUTPUT_DIR,
    "ifm.dec"
)

with open(ifm_dec_file, "w") as f:

    for ic in range(IN_CHANNEL):

        if IN_CHANNEL > 1:
            f.write(f"# INPUT CHANNEL {ic}\n")

        for h in range(IFM_HEIGHT):

            for w in range(IFM_WIDTH):

                f.write(
                    str(int(IFM[ic, h, w]))
                )

                if w != IFM_WIDTH - 1:
                    f.write(" ")

            f.write("\n")

        if IN_CHANNEL > 1:
            f.write("\n")


# ============================================================
# WRITE IFM.BIN
# ============================================================
#
# Each pixel = DATA_WIDTH bits
#
# Ordering:
#
# Channel 0:
#   row 0
#   row 1
#   ...
#
# Channel 1:
#   row 0
#   ...
#
# Suitable for $readmemb

ifm_bin_file = os.path.join(
    OUTPUT_DIR,
    "ifm.bin"
)

with open(ifm_bin_file, "w") as f:

    for ic in range(IN_CHANNEL):

        for h in range(IFM_HEIGHT):

            for w in range(IFM_WIDTH):

                binary = signed_to_binary(
                    IFM[ic, h, w],
                    DATA_WIDTH
                )

                f.write(binary)
                f.write("\n")


# ============================================================
# WRITE OFM.DEC
# ============================================================
#
# OFM is written row-by-row.
#
# Output channel 0:
#   row 0
#   row 1
#   ...
#
# Output channel 1:
#   row 0
#   ...

ofm_dec_file = os.path.join(
    OUTPUT_DIR,
    "ofm.dec"
)

with open(ofm_dec_file, "w") as f:

    for oc in range(OUT_CHANNEL):

        f.write(
            f"# OUTPUT CHANNEL {oc}\n"
        )

        for h in range(OFM_HEIGHT):

            for w in range(OFM_WIDTH):

                f.write(
                    str(int(OFM[oc, h, w]))
                )

                if w != OFM_WIDTH - 1:
                    f.write(" ")

            f.write("\n")

        f.write("\n")


# ============================================================
# WRITE OFM.BIN
# ============================================================
#
# OFM uses 32-bit because convolution accumulation
# can be larger than DATA_WIDTH.

OFM_WIDTH_BITS = 32

ofm_bin_file = os.path.join(
    OUTPUT_DIR,
    "ofm.bin"
)

with open(ofm_bin_file, "w") as f:

    for oc in range(OUT_CHANNEL):

        for h in range(OFM_HEIGHT):

            for w in range(OFM_WIDTH):

                binary = signed_to_binary(
                    OFM[oc, h, w],
                    OFM_WIDTH_BITS
                )

                f.write(binary)
                f.write("\n")


# ============================================================
# WRITE WEIGHT.DEC
# ============================================================
#
# IMPORTANT:
#
# Weight is written as MATRIX.
#
# For each output channel:
#
#   Input channel 0:
#
#       KERNEL ROW 0
#       KERNEL ROW 1
#       KERNEL ROW 2
#
#   Input channel 1:
#
#       KERNEL ROW 0
#       KERNEL ROW 1
#       KERNEL ROW 2
#
#
# Example K=3:
#
#  1  2  3
#  4  5  6
#  7  8  9

weight_dec_file = os.path.join(
    OUTPUT_DIR,
    "weight.dec"
)

with open(weight_dec_file, "w") as f:

    for oc in range(OUT_CHANNEL):

        f.write(
            f"# OUTPUT CHANNEL {oc}\n"
        )

        for ic in range(IN_CHANNEL):

            if IN_CHANNEL > 1:
                f.write(
                    f"# INPUT CHANNEL {ic}\n"
                )

            for kh in range(KERNEL_SIZE):

                for kw in range(KERNEL_SIZE):

                    f.write(
                        str(
                            int(
                                WEIGHT[
                                    oc,
                                    ic,
                                    kh,
                                    kw
                                ]
                            )
                        )
                    )

                    if kw != KERNEL_SIZE - 1:
                        f.write(" ")

                f.write("\n")

            f.write("\n")


# ============================================================
# WRITE WEIGHT.BIN
# ============================================================
#
# THIS IS THE IMPORTANT ORDER.
#
# Weight is written:
#
# Kernel 1
#   Row 1
#   Row 2
#   Row 3
#
# Kernel 2
#   Row 1
#   Row 2
#   Row 3
#
# ...
#
# For multiple input channels:
#
# Kernel (OC0, IC0)
#   row 0
#   row 1
#   row 2
#
# Kernel (OC0, IC1)
#   row 0
#   row 1
#   row 2
#
# Kernel (OC1, IC0)
#   ...
#

weight_bin_file = os.path.join(
    OUTPUT_DIR,
    "weight.bin"
)

with open(weight_bin_file, "w") as f:

    for oc in range(OUT_CHANNEL):

        for ic in range(IN_CHANNEL):

            # One complete kernel
            for kh in range(KERNEL_SIZE):

                # One kernel row
                for kw in range(KERNEL_SIZE):

                    binary = signed_to_binary(
                        WEIGHT[
                            oc,
                            ic,
                            kh,
                            kw
                        ],
                        DATA_WIDTH
                    )

                    f.write(binary)
                    f.write("\n")


# ============================================================
# PRINT IFM
# ============================================================

print("\n")
print("=" * 60)
print("IFM")
print("=" * 60)

for ic in range(IN_CHANNEL):

    print(f"\nInput Channel {ic}")

    for h in range(IFM_HEIGHT):

        print(
            " ".join(
                f"{int(IFM[ic, h, w]):4d}"
                for w in range(IFM_WIDTH)
            )
        )


# ============================================================
# PRINT WEIGHT
# ============================================================

print("\n")
print("=" * 60)
print("WEIGHT")
print("=" * 60)

for oc in range(OUT_CHANNEL):

    print(f"\nOutput Channel {oc}")

    for ic in range(IN_CHANNEL):

        print(f"\nInput Channel {ic}")

        for kh in range(KERNEL_SIZE):

            print(
                " ".join(
                    f"{int(WEIGHT[oc, ic, kh, kw]):4d}"
                    for kw in range(KERNEL_SIZE)
                )
            )


# ============================================================
# PRINT OFM
# ============================================================

print("\n")
print("=" * 60)
print("OFM")
print("=" * 60)

for oc in range(OUT_CHANNEL):

    print(f"\nOutput Channel {oc}")

    for h in range(OFM_HEIGHT):

        print(
            " ".join(
                f"{int(OFM[oc, h, w]):6d}"
                for w in range(OFM_WIDTH)
            )
        )


# ============================================================
# FILE SUMMARY
# ============================================================

print("\n")
print("=" * 60)
print("FILES GENERATED")
print("=" * 60)

print(f"IFM DEC      : {ifm_dec_file}")
print(f"IFM BIN      : {ifm_bin_file}")
print(f"WEIGHT DEC   : {weight_dec_file}")
print(f"WEIGHT BIN   : {weight_bin_file}")
print(f"OFM DEC      : {ofm_dec_file}")
print(f"OFM BIN      : {ofm_bin_file}")

print("=" * 60)
