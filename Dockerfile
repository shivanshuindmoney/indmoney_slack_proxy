# Use the Dart runtime for the build stage
FROM dart:stable AS build
WORKDIR /app

# Copy project files
COPY . .

# Install dependencies and build the project
RUN dart pub get
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
