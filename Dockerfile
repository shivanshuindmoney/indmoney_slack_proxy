# Use the Dart runtime
FROM dart:stable AS build
WORKDIR /app

# Copy the project files
COPY . .

# Install dependencies and build the project
RUN dart pub get
RUN dart_frog build

# Use a smaller runtime image for production
FROM dart:stable-slim AS runtime
WORKDIR /app

# Copy the built server files
COPY --from=build /app/build .

# Expose the port Dart Frog will run on
EXPOSE 8080

# Run the Dart Frog server
CMD ["dart", "start"]
