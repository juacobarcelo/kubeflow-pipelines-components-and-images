FROM python:3.10-slim-buster


RUN apt-get update \
&& apt-get -y install --no-install-recommends curl

RUN useradd -ms /bin/bash solver

USER solver
WORKDIR /home/solver

COPY requirements.txt ./tmp/pip-tmp/
RUN pip3  --disable-pip-version-check --no-cache-dir install --user -r ./tmp/pip-tmp/requirements.txt 
   # && rm -rf ./tmp/pip-tmp

COPY scripts/ ./scripts/

# ENTRYPOINT ["/bin/bash"]


