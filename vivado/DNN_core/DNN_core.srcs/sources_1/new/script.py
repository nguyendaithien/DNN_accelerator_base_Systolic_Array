import numpy as np

# ============================================================
# Configuration
# ============================================================

DATA_WIDTH = 16

# Matrix dimensions
A_shapes = [
    (16, 27),
    (16, 75),
    (16, 147)
]

B_shapes = [
    (27, 16),
    (75, 16),
    (147, 16)
]


# ============================================================
# Generate random matrices
# ============================================================

np.random.seed(1234)

A_list = []
B_list = []
C_list = []

for A_shape, B_shape in zip(A_shapes, B_shapes):

    A = np.random.randint(
        1,
        10,
        size=A_shape,
        dtype=np.int16
    )

    B = np.random.randint(
        1,
        10,
        size=B_shape,
        dtype=np.int16
    )

    # Matrix multiplication
    C = A.astype(np.int32) @ B.astype(np.int32)

    A_list.append(A)
    B_list.append(B)
    C_list.append(C)


# ============================================================
# Write matrix to text file
# ============================================================

def write_matrices(filename, matrices):

    with open(filename, "w") as f:
        for matrix_idx, matrix in enumerate(matrices):
            rows, cols = matrix.shape
            if filename == "B.txt":
                for j in range(cols):
                    for i in range(rows):
                        if i != 0:
                            f.write(" ")
                        f.write(str(int(matrix[i, j])))
                    f.write("\n")
            else:
                for i in range(rows):
                    for j in range(cols):
                        if j != 0:
                            f.write(" ")
                        f.write(str(int(matrix[i, j])))
                    f.write("\n")
            # Empty line between matrices
            if matrix_idx != len(matrices) - 1:
                f.write("\n")


# ============================================================
# Save files
# ============================================================

write_matrices("A.txt", A_list)
write_matrices("B.txt", B_list)
write_matrices("C.txt", C_list)


# ============================================================
# Print information
# ============================================================

print("Generated matrices:")

for i in range(3):

    print(f"\nMatrix set {i+1}")
    print(f"A{i+1}: {A_list[i].shape}")
    print(f"B{i+1}: {B_list[i].shape}")
    print(f"C{i+1}: {C_list[i].shape}")

print("\nFiles generated:")
print("  A.txt")
print("  B.txt")
print("  C.txt")
