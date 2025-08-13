FROM --platform=linux/amd64 ubuntu:22.04
COPY flag.txt /root/
RUN apt-get update && apt-get install -y python3 python3-pip curl git sudo dos2unix
WORKDIR /app
COPY web_app/ .
COPY setup.sh .
RUN dos2unix /app/setup.sh && chmod +x /app/setup.sh && /app/setup.sh
RUN chown -R redpie:redpie /app && chown -R root:root /home/redpie/RedPie
USER redpie

# Run app as non-root user
CMD ["python3", "-m", "flask", "run", "--host=0.0.0.0", "--port=5000"]
