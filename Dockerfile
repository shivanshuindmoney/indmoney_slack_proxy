# Use the Dart runtime for the build stage
FROM dart:stable AS build
WORKDIR /app

# Install dart_frog globally
RUN dart pub global activate dart_frog

# Debug Step 1: Find dart_frog binary in relevant directories
RUN find /root/.pub-cache /usr/local /usr/bin /bin -name dart_frog > /tmp/dart_frog_paths.txt 2>/dev/null

# Debug Step 2: List the contents of the pub-cache directory
RUN ls -lR /root/.pub-cache/ > /tmp/dart_pub_cache_contents.txt 2>/dev/null

# Copy debug output to the final image for inspection
FROM alpine AS debug
WORKDIR /output

# Copy debug files from the build stage
COPY --from=build /tmp/dart_frog_paths.txt .
COPY --from=build /tmp/dart_pub_cache_contents.txt .

# Include a command to keep the output
CMD ["sh"]
