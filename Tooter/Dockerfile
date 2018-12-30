# Base image
FROM alpine:3.8

# Dockerfile version
VAR VER 0.0.1-20181230-2044

# Feature cURL
RUN apk update && apk add curl

# Set ENV value for an image
ENV ENDPOINT=' ' STATUS='' VISIBILITY=' ' ACCESS_TOKEN=' ' VER_DOCKERFILE=$VER

# Define toot command
CMD if \
    echo $STATUS$VISIBILITY$ACCESS_TOKEN \
    | grep '[^a-zA-Z0-9\-\._~%]' > /dev/null; \
  then \
    echo "Invalid character included. Only '[^a-zA-Z0-9\-\._~%]' allowed."; \
    exit 1; \
  fi; \
  curl -X POST \
    -d "status=${STATUS}" \
    -d "visibility=${VISIBILITY}" \
    --header "Authorization: Bearer ${ACCESS_TOKEN}" \
    -sS $ENDPOINT
