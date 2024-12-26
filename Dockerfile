# Use the Dart runtime for the build stage
FROM dart:stable AS build
WORKDIR /app

# Copy project files
COPY . .

# Install dependencies
RUN dart pub get

# Install dart_frog globally
RUN dart pub global activate dart_frog

# Dynamically find the dart_frog binary and verify it
RUN DART_FROG_BINARY=$(find /root/.pub-cache/ -type f -name dart_frog -executable | head -n 1) && \
    echo "Dart Frog Binary Found At: $DART_FROG_BINARY" && \
    $DART_FROG_BINARY --version && \
    $DART_FROG_BINARY build

# Use the Dart runtime for production
FROM dart:stable AS runtime
WORKDIR /app

# Copy built files from the build stage
COPY --from=build /app/build .

# Expose the application port
EXPOSE 8080

# Run the Dart Frog server
CMD ["dart", "start"]
