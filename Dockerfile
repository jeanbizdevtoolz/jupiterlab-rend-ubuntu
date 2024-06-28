# Use the Ubuntu 22.04 (jammy) image
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install required packages
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Upgrade pip and install JupyterLab
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir jupyterlab notebook

# Generate JupyterLab password hash
RUN python3 -c "from notebook.auth import passwd; print(passwd('&j#mpT8tyBpe[z[7E+k('))" > /root/.jupyter/jupyter_passwd.txt

# Create Jupyter configuration directory
RUN mkdir -p /root/.jupyter

# Set Jupyter configuration to require password
RUN echo "c.NotebookApp.password = open('/root/.jupyter/jupyter_passwd.txt').read().strip()" > /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.open_browser = False" >> /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.port = 8080" >> /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.allow_root = True" >> /root/.jupyter/jupyter_notebook_config.py

# Expose port 8080
EXPOSE 8080

# Start JupyterLab on port 8080 with authentication
CMD ["jupyter", "lab"]
