FROM --platform=linux/amd64 ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC 

RUN apt-get update && apt-get install -y \
    python3 python3-pip curl git sudo dos2unix python3-flask

    COPY flag.txt /root/
WORKDIR /app
COPY web_app/ .
COPY setup.sh .

RUN dos2unix /app/setup.sh && chmod +x /app/setup.sh && /app/setup.sh

RUN echo '#!/bin/bash\npython3 /home/redpie/RedPie/src/main.py "$@"' > /app/redpie.sh \
    && chown root:root /app/redpie.sh \
    && chmod 755 /app/redpie.sh

RUN chown -R redpie:redpie /app \
    && chown root:root /app/redpie.sh

USER redpie

# Run app as non-root user
CMD ["python3", "-m", "flask", "run", "--host=0.0.0.0", "--port=5000"]