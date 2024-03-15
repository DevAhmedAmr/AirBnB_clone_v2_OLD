FROM ubuntu:latest

# Install necessary packages
RUN apt-get update

# Install sudo
RUN apt-get install -y sudo

# Copy the script into the container
COPY create_user.sh /create_user.sh

# Set execute permissions for the script
RUN chmod +x /create_user.sh

# Run the script when the container starts
CMD ["/create_user.sh"]
