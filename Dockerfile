# Build stage
FROM rust:1.76-slim AS builder

LABEL authors="kev"

WORKDIR /app

# Copy manifest files
COPY Cargo.toml Cargo.lock ./

# Create a dummy source file and fetch dependencies
RUN mkdir src && echo "fn main() { println!(\"Hello, world!\"); }" > src/main.rs && cargo fetch

# Copy actual source code
COPY src ./src

# Build with static linking
RUN RUSTFLAGS="-C target-feature=+crt-static" cargo build --release

# Strip the binary
RUN strip /app/target/release/hello_world

# Final stage
FROM scratch

# Copy the binary
COPY --from=builder /app/target/release/hello_world /hello_world

ENTRYPOINT ["/hello_world"]