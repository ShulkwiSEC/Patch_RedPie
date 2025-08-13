FROM --platform=linux/amd64 ubuntu:22.04
# --- General Setup ---
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    curl \
    git \
    sudo \
    python3-flask \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash redpie

# --- Setup RedPie--
RUN git clone https://github.com/ShulkwiSEC/RedPie.git /opt/RedPie
RUN pip3 install -r /opt/RedPie/requirement.txt
RUN python3 -m playwright install && python3 -m playwright install-deps

# --- Setup Wrapper ---
RUN echo '#!/bin/bash\npython3 /opt/RedPie/src/main.py "$@"' > /usr/local/bin/redpie \
    && chmod 755 /usr/local/bin/redpie
RUN chown -R root:root /opt/RedPie \
    && chmod -R 750 /opt/RedPie
RUN echo 'redpie ALL=(ALL) NOPASSWD: /usr/local/bin/redpie' >> /etc/sudoers

# --- Setup web_app ---
WORKDIR /app
COPY web_app/ .
RUN chown -R redpie:redpie /app
USER redpie
CMD ["python3", "-m", "flask", "run", "--host=0.0.0.0", "--port=5000"]