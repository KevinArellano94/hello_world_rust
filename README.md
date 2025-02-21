# Hello World Rust Tutorial with optomized Docker build

#rust #dockerfile #template

## Image size

```bash
$ docker images
REPOSITORY               TAG       IMAGE ID       CREATED             SIZE
hello_world_rs           latest    3b1ef5639bbe   About an hour ago   1.82MB
```

## Project structure

```tree
hello_world/
├── src/
│   └── main.rs
├── target/
│   ├── debug/
│   │   └── ...
│   └── release/
│       └── ...
├── .gitignore
├── Cargo.lock
├── Cargo.toml
└── Dockerfile
```

## Dockerfile

```Dockerfile
# Build stage
FROM rust:1.76-slim AS builder
LABEL authors="kev"

WORKDIR /app

# Copy manifest files
COPY Cargo.toml Cargo.lock ./

# Create a dummy source file and fetch dependencies
RUN mkdir src && echo "fn main() { println!(\"Hello, world!\"); }" > src/main.rs && cargo fetch

# Copy source code
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
```

## .gitignore

```.gitignore
/target
```

## Cargo.toml

```toml
[package]
name = "hello_world"
version = "0.1.0"
edition = "2021"

[dependencies]
```

## main.rs

```rust
fn main() {
    println!("Hello, world!");
}
```

## Docker commands

### Build app in docker

```bash
docker build -t hello_world_rs .
```

### Run app in docker

```bash
docker run -it --rm --name hello_world_rs_running hello_world_rs
```