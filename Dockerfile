# Use the Dart runtime for the build stage
FROM dart:stable AS build
WORKDIR /app

# Copy project files
COPY . .

# Install dependencies
RUN dart pub get

# Install dart_frog globally
RUN dart pub global activate dart_frog

# Add the global pub cache to PATH
ENV PATH="$PATH:/root/.pub-cache/bin"

# Verify dart_frog installation
RUN dart_frog --version

# Build the Dart Frog application
RUN dart_frog build

# Use the Dart runtime for production
FROM dart:stable AS runtime
WORKDIR /app

# Copy built files from the build stage
COPY --from=build /app/build .

# Expose the application port
EXPOSE 8080

# Run the Dart Frog server
CMD ["dart", "start"]
